-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_mv_closest table with db/osm-mv/find-closest-mv-to-osm.sql
select
  osm_mv_closest.osm_id,
  machine_vision.mv_id,
  osm_mv_closest.osm_date,
  osm_mv_closest.mv_date,
  osm_mv_closest.osm_area,
  osm_mv_closest.mv_area,
  osm_mv_closest.distance_meters,
  osm.latitude as osm_lat,
  osm.longitude as osm_lon,
  machine_vision.latitude as mv_lat,
  machine_vision.longitude as mv_lon,
  osm.objtype,
  osm.located
into match_rule_mv1_results
from osm_mv_closest, osm, machine_vision
where distance_meters < 500
and osm.osm_id = osm_mv_closest.osm_id
and machine_vision.mv_id = osm_mv_closest.mv_id
-- and osm.objtype != 'node' -- ignore nodes
-- and osm.located != 'roof' -- ignore rooftop things
-- and osm.located != 'rood'
-- and osm.located != 'roofq'
-- and osm.located != 'rof'
-- and osm.located != 'roofs'
order by distance_meters;

select * from match_rule_mv1_results;
