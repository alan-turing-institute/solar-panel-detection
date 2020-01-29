-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_repd_closest table with database/osm-repd-location-tables/find-closest-repd-to-osm-inc-no-repd_id.sql

drop table if exists match_rule_1_results;
drop table if exists temp_table;

select
  osm_repd_closest.osm_id,
  solar.osm_repd_id_mapping.repd_id as osm_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_repd_id,
  osm_repd_closest.distance_meters
into temp_table
from osm_repd_closest
left join solar.osm_repd_id_mapping on osm_repd_closest.osm_id = solar.osm_repd_id_mapping.osm_id
where osm_repd_closest.distance_meters < 250;

select
  temp_table.osm_id,
  temp_table.osm_repd_id,
  temp_table.closest_geo_match_from_repd_repd_id,
  temp_table.distance_meters,
  solar.osm.objtype,
  solar.osm.plantref,
  solar.osm.tag_power,
  solar.osm.time_created,
  solar.osm.area,
  solar.osm.capacity
into match_rule_1_results
from temp_table, solar.osm
where temp_table.osm_id = solar.osm.osm_id
and temp_table.osm_repd_id is null;

drop table temp_table;

select count(*) from match_rule_1_results;
select count(*) from match_rule_1_results where objtype='node';
select count(*) from match_rule_1_results where objtype='way';
select count(*) from match_rule_1_results where objtype='relation';
