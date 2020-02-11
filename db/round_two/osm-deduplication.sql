-- This query only works after the db is created with solar_db.sql

drop table if exists osm_neighbours;
drop table if exists temp;

-- the purpose of the below is to find objects that are oddly close and check if they are part of the same thing
select *
into temp
from osm;

select
  osm.osm_id,
  closest_pt.osm_id as neighbour_osm_id,
  closest_pt.distance_meters
into osm_neighbours
from osm
CROSS JOIN LATERAL
  (SELECT
     temp.osm_id,
     osm.location::geography <-> temp.location::geography as distance_meters
     FROM temp
     where temp.objtype != 'node' -- There is no point de-duplicating nodes, these are separate objects
     ORDER BY osm.location::geography <-> temp.location::geography
   LIMIT 2) AS closest_pt
where osm.objtype != 'node'
and osm.osm_id != closest_pt.osm_id;

drop table temp;

select
  osm_neighbours.osm_id,
  osm.master_osm_id,
  osm_neighbours.neighbour_osm_id,
  osm_neighbours.distance_meters,
  osm.latitude,
  osm.longitude
from osm_neighbours, osm
where osm_neighbours.osm_id = osm.osm_id
and (osm.master_osm_id != osm.osm_id -- ignore those that already have a plantref (already de-duplicated)
  or osm.master_osm_id is null)
and osm.located != 'roof'
and osm.located != 'rood'
and osm.located != 'roofq'
and osm.located != 'rof'
and osm.located != 'roofs'
order by osm_neighbours.distance_meters asc;

-- Counts of objects that still may need de-duplication

-- select count(*)
-- from osm
-- where osm.objtype != 'node'
-- and (osm.master_osm_id != osm.osm_id -- ignore those that already have a plantref (already de-duplicated)
--   or osm.master_osm_id is null)
-- and osm.located != 'roof'
-- and osm.located != 'rood'
-- and osm.located != 'roofq'
-- and osm.located != 'rof'
-- and osm.located != 'roofs';
--
-- select count(*)
-- from raw.osm
-- where osm.objtype != 'node'
-- and osm.located != 'roof'
-- and osm.located != 'rood'
-- and osm.located != 'roofq'
-- and osm.located != 'rof'
-- and osm.located != 'roofs';
