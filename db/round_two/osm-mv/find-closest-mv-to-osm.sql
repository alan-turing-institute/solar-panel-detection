drop table if exists osm_mv_closest;
select
  osm.osm_id,
  osm.tag_start_date as osm_date,
  closest_pt.install_date as mv_date,
  osm.area as osm_area,
  closest_pt.area as mv_area,
  closest_pt.distance_meters,
  closest_pt.mv_id as mv_id
into osm_mv_closest
from osm
CROSS JOIN LATERAL
  (SELECT
     machine_vision.mv_id,
     machine_vision.install_date,
     machine_vision.area,
     osm.location::geography <-> machine_vision.location::geography as distance_meters
     FROM machine_vision
     ORDER BY osm.location::geography <-> machine_vision.location::geography
   LIMIT 1) AS closest_pt;
