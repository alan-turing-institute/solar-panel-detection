
select
  osm_mv_neighbours.osm_id,
  osm.master_osm_id,
  machine_vision.mv_id,
  osm_mv_neighbours.osm_date,
  osm_mv_neighbours.mv_date,
  osm_mv_neighbours.osm_area,
  osm_mv_neighbours.mv_area,
  osm_mv_neighbours.distance_meters,
  osm.latitude as osm_lat,
  osm.longitude as osm_lon,
  machine_vision.latitude as mv_lat,
  machine_vision.longitude as mv_lon,
  osm.objtype,
  osm.located
from osm_mv_neighbours, osm, machine_vision
where osm.osm_id = osm_mv_neighbours.osm_id
and machine_vision.mv_id = osm_mv_neighbours.mv_id
order by distance_meters;
