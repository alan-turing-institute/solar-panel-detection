-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_repd_closest table with db/osm-repd/find-closest-repd-to-osm.sql

drop table if exists match_rule_13_results;
drop table if exists temp_table;

select
  osm_repd_closest.osm_id,
  osm_repd_id_mapping.repd_id as osm_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_co_location_repd_id,
  osm_repd_closest.site_name,
  osm_repd_closest.distance_meters
into temp_table
from osm_repd_closest
left join osm_repd_id_mapping on osm_repd_closest.osm_id = osm_repd_id_mapping.osm_id
where osm_repd_closest.distance_meters < 500;

select
  CONCAT  (osm.objtype, '/', temp_table.osm_id) AS "osm",
  temp_table.osm_repd_id,
  temp_table.closest_geo_match_from_repd_repd_id as match_repd_id,
  temp_table.closest_geo_match_from_repd_co_location_repd_id as match_co_repd,
  temp_table.site_name as repd_name,
  temp_table.distance_meters,
  -- osm.objtype,
  -- osm.plantref,
  -- osm.time_created,
  -- osm.area,
  osm.capacity as osm_capacity,
  repd.capacity as repd_capacity,
  repd.latitude as r_lat,
  repd.longitude as r_lon,
  repd.operational
into match_rule_13_results
from temp_table, osm, repd
where temp_table.osm_id = osm.osm_id
and temp_table.closest_geo_match_from_repd_repd_id = repd.repd_id -- use this to display other repd fields
and osm.objtype = 'node'
and repd.site_name like '%Scheme%';

drop table temp_table;

select *
from match_rule_13_results;
