select
  repd.master_repd_id,
  machine_vision.mv_id,
  mv_repd_neighbours.mv_date,
  mv_repd_neighbours.mv_area,
  mv_repd_neighbours.distance_meters,
  repd.latitude as repd_lat,
  repd.longitude as repd_lon,
  machine_vision.latitude as mv_lat,
  machine_vision.longitude as mv_lon
from mv_repd_neighbours, repd, machine_vision
where repd.repd_id = mv_repd_neighbours.repd_id
and machine_vision.mv_id = mv_repd_neighbours.mv_id
and mv_repd_neighbours.distance_meters < 1000
order by distance_meters;
