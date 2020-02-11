-- This query only works after the db is created with solar_db.sql
drop table if exists osm_possible_farm_duplicates;
drop table if exists temp;
drop table if exists temp2;
drop table if exists osm_dup;
drop table if exists osm_farm_duplicates;

select *
into osm_dup
from osm;

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

-- Get the nearest other entry for each in the table above, but only those
-- within a certain distance (e.g. 1000m)
select
  osm_possible_farm_duplicates.osm_id,
  closest_pt.osm_id as neighbour_osm_id,
  closest_pt.distance_meters,
  closest_pt.latitude as neighbour_lat,
  closest_pt.longitude as neighbour_lon,
  closest_pt.location
into temp2
from osm_possible_farm_duplicates
CROSS JOIN LATERAL
  (SELECT
     temp.osm_id,
     osm_possible_farm_duplicates.location::geography <-> temp.location::geography as distance_meters,
     raw.osm.latitude,
     raw.osm.longitude,
     raw.osm.location
     FROM temp, raw.osm
     where temp.osm_id = raw.osm.osm_id
     ORDER BY osm_possible_farm_duplicates.location::geography <-> raw.osm.location::geography
   LIMIT 2) AS closest_pt
where osm_possible_farm_duplicates.osm_id != closest_pt.osm_id;

select
  temp2.osm_id,
  temp2.neighbour_osm_id,
  temp2.distance_meters,
  osm_dup.latitude,
  osm_dup.longitude,
  temp2.neighbour_lat,
  temp2.neighbour_lon
into osm_farm_duplicates
from temp2, osm_dup
where temp2.osm_id = osm_dup.osm_id
and ST_Distance(osm_dup.location::geography, temp2.location::geography) < 300 -- limit to those closer than Xm
ORDER BY temp2.distance_meters desc;

drop table temp;
drop table temp2;
drop table osm_dup;
drop table osm_possible_farm_duplicates;
