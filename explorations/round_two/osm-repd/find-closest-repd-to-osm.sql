drop table if exists osm_repd_closest;
select
  osm.osm_id,
  closest_pt.repd_id as closest_geo_match_from_repd_repd_id,
  closest_pt.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
  closest_pt.distance_meters,
  closest_pt.site_name
into osm_repd_closest
from osm
CROSS JOIN LATERAL
  (SELECT
     repd.repd_id,
     repd.co_location_repd_id,
     repd.site_name,
     osm.location::geography <-> repd.location::geography as distance_meters
     FROM repd
     ORDER BY osm.location::geography <-> repd.location::geography
   LIMIT 1) AS closest_pt;
