/*
** Deduplicate the REPD dataset.
** 
** Identify individual entries as being the same solar farm if:
** 1. They are within a certain disance; and
** 2. They have a "similar" name
**
** Names are similar if their reduced forms are close by trigram matching.
** The reduced form of a name is the name with certain common words (like "Farm") removed.
**
*/

create extension if not exists pg_trgm; -- trigram matching

\echo -n Deduplicating REPD dataset ...

-- PARAMETERS:
--
-- cluster_distance is the distance (in metres) within which we count
-- two objects as potentially being part of the same cluster. 
--
-- name_distance is the threshold (in trigram matching) for counting two site
-- names as potentially representing the same site.

\set cluster_distance 1380
\set identical_cluster_distance 5
\set name_distance 0.2


create temporary view parts(repd_id1, repd_id2) as
with temp(repd_id, location, reduced_site_name) as (
  -- Within `site_name` remove the following strings:
  --   solar, Solar, park, Park, farm, Farm, resubmission, (resubmission), (Resubmission),
  --   extension, Extension, ()
  -- also remove ' - ' and reduce two consecutive spaces to one. 
  select repd_id,
         location,
         regexp_replace(
           regexp_replace(
           site_name,
           'solar|Solar|park|Park|farm|Farm|\(resubmission\)|\(Resubmission\)|resubmission|Resubmission|extension|Extension|\(\)', '', 'g'),
         ' +', ' ', 'g') as reduced_site_name
   from repd
)
  select x.repd_id as repd_id1,
         y.repd_id as repd_id2
    from temp as x cross join temp as y
    -- two sites are the same if they are close and have similar names; or if they
    -- are so close as to be clearly the same.
    where x.repd_id != y.repd_id
      and ((x.location::geography <-> y.location::geography < :cluster_distance
            and similarity(x.reduced_site_name, y.reduced_site_name) >= :name_distance)
           or x.location::geography <-> y.location::geography < :identical_cluster_distance);


-- clusters(repd_id1, repd_id2)
-- Objects that can be reached through a chain of connections

create temporary view clusters as
with recursive clusters(repd_id1, repd_id2) as (
    select repd_id1, repd_id2
    from parts
  union
    select clusters.repd_id1 as repd_id1, parts.repd_id2 as repd_id2
    from clusters cross join parts 
    where clusters.repd_id2 = parts.repd_id1
  )
  select repd_id1, repd_id2 FROM clusters;


-- repd_dedup(repd_id, master_repd_id)
-- master_repd_id is the largest repd_id over all objects within the
-- same cluster

create temporary view repd_dedup as 
select repd_id1 as repd_id, max(repd_id2) as master_repd_id
  from clusters
  group by repd_id1;

/* 
** Merge the new groupings into the repd table
*/

alter table repd
  add column master_repd_id integer;  -- default is NULL

\echo clustering ...

update repd
  set (master_repd_id) =
    (select master_repd_id
       from repd_dedup
      where repd_dedup.repd_id = repd.repd_id)
    where master_repd_id is null;

