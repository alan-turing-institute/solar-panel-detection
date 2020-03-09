/*
** Deduplicate the OSM dataset
*/

\echo Deduplicating OSM dataset ...

drop table if exists osm;

drop table if exists osm_possible_farm_duplicates;
drop table if exists temp;
drop table if exists osm_farm_duplicates;
drop table if exists osm_dedup;
drop table if exists osm_farm_deleteables;


select * into osm
  from raw.osm;

-- Create master_osm_id from plantref as int

alter table osm
  add column "master_osm_id" varchar(20);

update osm
  set master_osm_id = (string_to_array(plantref, '/'))[2];

alter table osm
  alter column master_osm_id
    set data type bigint
      using cast (master_osm_id as bigint);

alter table osm
  drop column plantref;

-- Deduplicate further for matching by removing objects that are part of the same farm

select * into osm_possible_farm_duplicates
  from osm
  where objtype != 'node' -- ignore nodes
    and ((located != 'roof' -- ignore rooftop things
                  and located != 'rood'
                  and located != 'roofq'
                  and located != 'rof'
                  and located != 'roofs')
          or located is null)
    and master_osm_id is null; -- ignore those that already have a plantref (already de-duplicated)

-- Duplicate this table so we can compare it against itself:
select * into temp
  from osm_possible_farm_duplicates;

-- Next 2 queries: Get the nearest other entry for each in the table above, but only those
-- within a certain distance (e.g. 300m)

select osm_possible_farm_duplicates.objtype,
       osm_possible_farm_duplicates.osm_id,
       osm_possible_farm_duplicates.located,
       closest_pt.objtype as neighbour_objtype,
       closest_pt.osm_id as neighbour_osm_id,
       closest_pt.located as neighbour_located,
       closest_pt.distance_meters,
       closest_pt.location
  into osm_farm_duplicates
  from osm_possible_farm_duplicates
  CROSS JOIN LATERAL
  (SELECT temp.objtype,
          temp.osm_id,
          temp.located,
          osm_possible_farm_duplicates.location::geography <-> temp.location::geography as distance_meters,
          osm.location
     FROM temp, osm
     where temp.osm_id = osm.osm_id
     ORDER BY osm_possible_farm_duplicates.location::geography <-> osm.location::geography) AS closest_pt
  where osm_possible_farm_duplicates.osm_id != closest_pt.osm_id
  and closest_pt.distance_meters < 300;


-- Remove extra objects from each farm
alter table osm_farm_duplicates
  add column "ordered" BOOLEAN;

update osm_farm_duplicates
  set ordered = osm_id > neighbour_osm_id;

select osm_id, bool_and(ordered) as keep into osm_farm_deleteables
  from osm_farm_duplicates
  group by osm_id;

select *
  into osm_dedup
  from osm
  where not exists (
    SELECT
    FROM osm_farm_deleteables
    where osm.osm_id = osm_farm_deleteables.osm_id
    and osm_farm_deleteables.keep = False);

drop table temp;
drop table osm_farm_deleteables;

-- Commented out the below, to avoid the reduced osm table overwiting the original
-- That's no longer what we want
-----------------------
-- Finally, update the osm table to be the de-duplicated version
-- drop table osm;
-- select *
-- into osm
-- from osm_dedup;
-- drop table osm_dedup;

