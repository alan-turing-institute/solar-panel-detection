-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_repd_closest table with database/osm-repd-location-tables/find-closest-repd-to-osm-inc-no-repd_id.sql

drop table if exists match_rule_5_results;
drop table if exists temp_table;

select
  osm_repd_closest.osm_id,
  solar.osm_repd_id_mapping.repd_id as osm_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_co_location_repd_id,
  osm_repd_closest.site_name,
  osm_repd_closest.distance_meters
into temp_table
from osm_repd_closest
left join solar.osm_repd_id_mapping on osm_repd_closest.osm_id = solar.osm_repd_id_mapping.osm_id
where osm_repd_closest.distance_meters < 500;

select
  temp_table.osm_id,
  temp_table.osm_repd_id,
  temp_table.closest_geo_match_from_repd_repd_id as repd_id,
  temp_table.closest_geo_match_from_repd_co_location_repd_id as co_repd,
  temp_table.site_name as repd_name,
  temp_table.distance_meters,
  -- solar.osm.objtype,
  solar.osm.plantref,
  -- solar.osm.time_created,
  -- solar.osm.area,
  solar.osm.located,
  solar.osm.capacity as osm_capacity,
  solar.repd.capacity as repd_capacity,
  solar.osm.latitude as lat,
  solar.osm.longitude as lon
into match_rule_5_results
from temp_table, solar.osm, solar.repd
where temp_table.osm_id = solar.osm.osm_id
and temp_table.closest_geo_match_from_repd_repd_id = solar.repd.repd_id  -- use this to display other repd fields
and (solar.osm.located is null
or solar.osm.located = 'ground'
or solar.osm.located = 'surface');

drop table temp_table;

select count(*) from match_rule_5_results;
select count(*) from match_rule_5_results where plantref is null;
select count(*) from match_rule_5_results where plantref is null and (osm_repd_id is null or osm_repd_id != repd_id);
