select
  osm_mv_closest.osm_id,
  osm_mv_closest.osm_date,
  osm_mv_closest.mv_date,
  osm_mv_closest.osm_area,
  osm_mv_closest.mv_area,
  osm_mv_closest.distance_meters,
  osm.latitude as osm_lat,
  osm.longitude as osm_lon,
  machine_vision.latitude as mv_lat,
  machine_vision.longitude as mv_lon
from osm_mv_closest, osm, machine_vision
where distance_meters < 500
and osm.osm_id = osm_mv_closest.osm_id
and machine_vision.location = osm_mv_closest.mv_location
order by distance_meters;
