-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_repd_closest table with database/osm-repd-location-tables/find-closest-repd-to-osm-inc-no-repd_id.sql

drop table if exists osm_plantref_mapping;
select
  osm_id,
  (string_to_array(plantref, '/'))[2] as master_osm_id
into osm_plantref_mapping
from solar.osm;

alter table osm_plantref_mapping
alter column master_osm_id type bigint using master_osm_id::bigint;

drop table if exists match_rule_8_results;
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
  temp_table.distance_meters
into match_rule_8_results
from temp_table, solar.osm_repd_id_mapping, solar.repd, osm_plantref_mapping
where temp_table.closest_geo_match_from_repd_repd_id = solar.repd.repd_id -- use this to display other repd fields
and (temp_table.osm_repd_id != temp_table.closest_geo_match_from_repd_repd_id
  or temp_table.osm_repd_id is null) -- where repd id not already correctly tagged...
and temp_table.osm_id = osm_plantref_mapping.osm_id
and osm_plantref_mapping.master_osm_id = solar.osm_repd_id_mapping.osm_id
and osm_plantref_mapping.master_osm_id = osm_plantref_mapping.osm_id;

drop table temp_table;

select count(*) from match_rule_8_results;
