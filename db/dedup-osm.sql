/*
** Deduplicate the OSM dataset and add field `master_osm_id`
**
** Some OSM rows represent geographical entities that are in reality component parts
** of a single installation (often a solar "farm").
** This script adds a field `master_osm_id` that contains a unique `osm_id` for all
** members of a single group.
*/

\echo -n Deduplicating OSM dataset ...

-- PARAMETERS: cluster_distance is the distance (in metres) within which we count
-- two objects as certainly being part of the same cluster.

\set cluster_distance 300

drop table if exists osm cascade;
drop table if exists osm_dedup;

-- The field plantref, if not null, contains a value of the form 'way/123456789'.
-- We extract the part after the "/", which corresponds to another osm_id.

select objtype,
       osm_id,
       username,
       time_created,
       latitude,
       longitude,
       area,
       capacity,
       modules,
       located,
       orientation,
       cast(split_part(plantref, '/', 2) as bigint) as master_osm_id,
       tag_power,
       repd_id_str,
       tag_start_date,
       location
  into osm
  from raw.osm;

/*
** Deduplicate objects that are part of the same farm
**
** 1. Find groups of objects within 300m of each other;
** 2. Call these "the same" and close over this equivalence relation
** 3. Choose one osm_id from each equivalence class
*/

\echo clustering ...

-- osm_parts(osm_id1, osm_id2)
-- All pairs of objects that are within 300m of each other

create temporary view osm_parts as
with maybe_dupes(osm_id, location) as (
  -- ignore nodes, (various misspellings of) rooftop things,
  -- and cases where there is already a master_osm_id.
  -- NB. "X is not true" is true if X is false or X is null
  select osm_id, location from osm
  where
    objtype != 'node'
    and (located in ('roof', 'rood', 'roofq', 'rof', 'roofs')) is not true
    and master_osm_id is null
)
-- find objects within 300 m of each other
select md1.osm_id as osm_id1, md2.osm_id as osm_id2
  from maybe_dupes as md1, maybe_dupes as md2
  where md1.osm_id != md2.osm_id
        and md1.location::geography <-> md2.location::geography < :cluster_distance;

-- osm_clusters(osm_id1, osm_id2)
-- Objects that can be reached through a chain of connections

create temporary view osm_clusters as
with recursive osm_clusters(osm_id1, osm_id2) as (
    select osm_id1, osm_id2
    from osm_parts
  union
    select osm_clusters.osm_id1 as osm_id1, osm_parts.osm_id2 as osm_id2
    from osm_clusters cross join osm_parts
    where osm_clusters.osm_id2 = osm_parts.osm_id1
  )
  select osm_id1, osm_id2 FROM osm_clusters;

-- osm_dedup(osm_id, master_osm_id)
-- master_osm_id is the largest osm_id over all objects within the
-- same cluster

select osm_id1 as osm_id, max(osm_id2) as master_osm_id
  into osm_dedup
  from osm_clusters
  group by osm_id1;

/*
** Merge the new groupings into the osm table
*/

update osm
  set (master_osm_id) =
    (select master_osm_id
     from osm_dedup
     where osm_dedup.osm_id = osm.osm_id)
  where master_osm_id is null;

-- Add master id identical to id for all singletons, to aid matching
update osm
  set master_osm_id = osm_id
  where master_osm_id is null;
