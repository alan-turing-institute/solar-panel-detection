drop table if exists osm_neighbours;
drop table if exists temp;

-- the purpose of the below is to find objects that are oddly close and check if they are part of the same thing
select *
into temp
from osm;
-- todo: Perhaps we should modify this to be only for relations/ways if takes too long with the nodes
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
     ORDER BY osm.location::geography <-> temp.location::geography
   LIMIT 1) AS closest_pt;
