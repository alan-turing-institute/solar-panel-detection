drop table if exists osm_with_repd_id_repd_closest;
select
  osm.osm_id,
  osm_repd_id_mapping.repd_id as repd_id_in_osm,
  closest_pt.repd_id as closest_geo_match_from_repd_repd_id,
  closest_pt.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
  closest_pt.distance_meters
into osm_with_repd_id_repd_closest
from osm, osm_repd_id_mapping
CROSS JOIN LATERAL
  (SELECT
     repd.repd_id,
     repd.co_location_repd_id,
     osm.location::geography <-> repd.location::geography as distance_meters
     FROM repd
     ORDER BY osm.location::geography <-> repd.location::geography
   LIMIT 1) AS closest_pt
where osm.osm_id = osm_repd_id_mapping.osm_id;

-- OSM with REPD id with closest geographical match in REPD having that repd_id and co-located REPD id:
select count(*) from osm_with_repd_id_repd_closest where repd_id_in_osm = closest_geo_match_from_repd_repd_id;
select count(*) from osm_with_repd_id_repd_closest where repd_id_in_osm = closest_geo_match_from_repd_co_location_repd_id;
