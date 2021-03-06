-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_repd_closest table with database/osm-repd-location-tables/find-closest-repd-to-osm-inc-no-repd_id.sql

drop table if exists match_rule_2_results;
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
where osm_repd_closest.distance_meters < 250;

select
  temp_table.osm_id,
  temp_table.osm_repd_id,
  temp_table.closest_geo_match_from_repd_repd_id as repd_id,
  temp_table.closest_geo_match_from_repd_co_location_repd_id as co_repd,
  temp_table.site_name as repd_name,
  temp_table.distance_meters,
  raw.osm.objtype,
  raw.osm.plantref,
  raw.osm.time_created,
  raw.osm.area,
  raw.osm.capacity,
  raw.osm.latitude as lat,
  raw.osm.longitude as lon
into match_rule_2_results
from temp_table, raw.osm
where temp_table.osm_id = raw.osm.osm_id
and temp_table.osm_repd_id is null
and raw.osm.tag_power = 'plant';

drop table temp_table;

select count(*) from match_rule_2_results;
select count(*) from match_rule_2_results where objtype='node';
select count(*) from match_rule_2_results where objtype='way';
select count(*) from match_rule_2_results where objtype='relation';
