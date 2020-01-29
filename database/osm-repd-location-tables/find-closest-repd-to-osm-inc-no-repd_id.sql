drop table if exists osm_repd_closest;
select
  solar.osm.osm_id,
  closest_pt.repd_id as closest_geo_match_from_repd_repd_id,
  closest_pt.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
  closest_pt.distance_meters
into osm_repd_closest
from solar.osm
CROSS JOIN LATERAL
  (SELECT
     solar.repd.repd_id,
     solar.repd.co_location_repd_id,
     solar.osm.location::geography <-> solar.repd.location::geography as distance_meters
     FROM solar.repd
     where solar.repd.tech_type = 'Solar Photovoltaics'
     ORDER BY solar.osm.location::geography <-> solar.repd.location::geography
   LIMIT 1) AS closest_pt;
