drop table if exists osm_with_repd_id_repd_closest;
select
  solar.osm.osm_id,
  solar.osm_repd_id_mapping.repd_id as repd_id_in_osm,
  closest_pt.repd_id as closest_geo_match_from_repd_repd_id,
  closest_pt.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
  closest_pt.distance_meters
into osm_with_repd_id_repd_closest
from solar.osm, solar.osm_repd_id_mapping
CROSS JOIN LATERAL
  (SELECT
     solar.repd.repd_id,
     solar.repd.co_location_repd_id,
     solar.osm.location::geography <-> solar.repd.location::geography as distance_meters
     FROM solar.repd
     ORDER BY solar.osm.location::geography <-> solar.repd.location::geography
   LIMIT 1) AS closest_pt
where solar.osm.osm_id = solar.osm_repd_id_mapping.osm_id;

-- select count(*) from osm_repd_closest;
-- select count(*) from osm_repd_closest where repd_id_in_osm = closest_geo_match_from_repd_repd_id;
-- select count(*) from osm_repd_closest where repd_id_in_osm = closest_geo_match_from_repd_co_location_repd_id;
