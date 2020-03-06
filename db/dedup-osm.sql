/*
** Deduplicate the OSM dataset
*/

\echo Deduplicating OSM dataset ...


-- Create de-duplicated osm table
-- First de-duplicate by reducing to one row for each farm linked by "plantref"

drop table if exists osm_plantref_mapping;

select osm_id, (string_to_array(plantref, '/'))[2] as master_osm_id
  into osm_plantref_mapping
  from solar.osm;

alter table osm_plantref_mapping
  alter column master_osm_id type bigint using master_osm_id::bigint;

drop table if exists osm;

select
    raw.osm.objtype,
    raw.osm.osm_id,
    raw.osm.username,
    raw.osm.time_created,
    raw.osm.latitude,
    raw.osm.longitude,
    raw.osm.area,
    raw.osm.capacity,
    raw.osm.modules,
    raw.osm.located,
    raw.osm.orientation,
    osm_plantref_mapping.master_osm_id,
    raw.osm.tag_power,
    raw.osm.repd_id_str,
    raw.osm.tag_start_date,
    raw.osm.location
  into osm
  from raw.osm
       left join osm_plantref_mapping
       on osm_plantref_mapping.osm_id = raw.osm.osm_id
  where osm_plantref_mapping.osm_id = osm_plantref_mapping.master_osm_id
        or raw.osm.plantref is null;

-- Deduplicate further for matching by removing objects that are part of the same farm
drop table if exists osm_possible_farm_duplicates;
drop table if exists temp;
drop table if exists osm_farm_duplicates;
drop table if exists osm_dedup;
drop table if exists osm_farm_deleteables;

select *
into osm_possible_farm_duplicates
from osm
where osm.objtype != 'node' -- ignore nodes
and (osm.master_osm_id != osm.osm_id -- ignore those that already have a plantref (already de-duplicated)
  or osm.master_osm_id is null)
and osm.located != 'roof' -- ignore rooftop things
and osm.located != 'rood'
and osm.located != 'roofq'
and osm.located != 'rof'
and osm.located != 'roofs';

-- Duplicate this table so we can compare it against itself:
select *
into temp
from osm_possible_farm_duplicates;

-- Next 2 queries: Get the nearest other entry for each in the table above, but only those
-- within a certain distance (e.g. 300m)
select
  osm_possible_farm_duplicates.objtype,
  osm_possible_farm_duplicates.osm_id,
  closest_pt.objtype as neighbour_objtype,
  closest_pt.osm_id as neighbour_osm_id,
  closest_pt.distance_meters,
  closest_pt.location
into osm_farm_duplicates
from osm_possible_farm_duplicates
CROSS JOIN LATERAL
  (SELECT
     temp.objtype,
     temp.osm_id,
     osm_possible_farm_duplicates.location::geography <-> temp.location::geography as distance_meters,
     osm.location
     FROM temp, osm
     where temp.osm_id = osm.osm_id
     ORDER BY osm_possible_farm_duplicates.location::geography <-> osm.location::geography) AS closest_pt
where osm_possible_farm_duplicates.osm_id != closest_pt.osm_id
and closest_pt.distance_meters < 300;

drop table temp;

-- Remove extra objects from each farm
alter table osm_farm_duplicates add column "ordered" BOOLEAN;
update osm_farm_duplicates
set ordered = osm_id > neighbour_osm_id;

select osm_id, bool_and(ordered) as keep
into osm_farm_deleteables
from osm_farm_duplicates
group by osm_id;

select *
into osm_dedup
from osm
where not exists(
  SELECT
  FROM osm_farm_deleteables
  where osm.osm_id = osm_farm_deleteables.osm_id
  and osm_farm_deleteables.keep = False
);

drop table osm_farm_deleteables;

-- Finally, update the OSM table to be the de-duplicated version
drop table osm;
select *
into osm
from osm_dedup;
drop table osm_dedup;
