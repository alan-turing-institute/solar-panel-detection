-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_repd_closest table with database/osm-repd-location-tables/find-closest-repd-to-osm-inc-no-repd_id.sql

select
  osm_repd_closest.osm_id,
  osm_repd_closest.closest_geo_match_from_repd_repd_id,
  solar.osm_repd_id_mapping.repd_id as osm_repd_id
from osm_repd_closest
left join solar.osm_repd_id_mapping on osm_repd_closest.osm_id = solar.osm_repd_id_mapping.osm_id
where osm_repd_closest.distance_meters < 250;
