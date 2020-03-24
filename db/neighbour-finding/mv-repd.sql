drop table if exists mv_repd_neighbours;
select closest_pt.repd_id,
       closest_pt.co_location_repd_id,
       closest_pt.master_repd_id,
       machine_vision.install_date as mv_date,
       machine_vision.area as mv_area,
       closest_pt.distance_meters,
       machine_vision.mv_id as mv_id
  into mv_repd_neighbours
  from machine_vision
  CROSS JOIN LATERAL
    (SELECT
       repd.repd_id,
       repd.co_location_repd_id,
       repd.master_repd_id,
       machine_vision.location::geography <-> repd.location::geography as distance_meters
       FROM repd
       ORDER BY machine_vision.location::geography <-> repd.location::geography
     LIMIT 1) AS closest_pt;
