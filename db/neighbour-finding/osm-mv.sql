drop table if exists osm_mv_neighbours;
select closest_pt.osm_id,
       closest_pt.tag_start_date as osm_date,
       machine_vision.install_date as mv_date,
       closest_pt.area as osm_area,
       machine_vision.area as mv_area,
       closest_pt.distance_meters,
       machine_vision.mv_id as mv_id
  into osm_mv_neighbours
  from machine_vision
  CROSS JOIN LATERAL
    (SELECT
       osm.osm_id,
       osm.tag_start_date,
       osm.area,
       machine_vision.location::geography <-> osm.location::geography as distance_meters
       FROM osm
     LIMIT 1) AS closest_pt;
