-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_with_repd_id_repd_closest table with db/osm-repd/find-closest-repd-to-osm-with-repd_id.sql

select
  osm_with_repd_id_repd_closest.osm_id,
  osm.objtype,
  osm_with_repd_id_repd_closest.repd_id_in_osm,
  osm_with_repd_id_repd_closest.closest_geo_match_from_repd_repd_id,
  osm_with_repd_id_repd_closest.closest_geo_match_from_repd_co_location_repd_id,
  osm_with_repd_id_repd_closest.distance_meters
into match_rule_11_results
from osm_with_repd_id_repd_closest, osm
where (repd_id_in_osm = closest_geo_match_from_repd_repd_id
  or repd_id_in_osm = closest_geo_match_from_repd_co_location_repd_id)
and osm_with_repd_id_repd_closest.osm_id = osm.osm_id
order by distance_meters desc;

select * from match_rule_11_results;

select count(*) from match_rule_11_results
where repd_id_in_osm = closest_geo_match_from_repd_repd_id;

select count(*) from match_rule_11_results
where repd_id_in_osm = closest_geo_match_from_repd_co_location_repd_id;

select count(*) from match_rule_11_results;

select count(*) from match_rule_11_results
where objtype = 'node';

select count(*) from match_rule_11_results
where objtype !='node';
