-- Before running this query:
-- 1. Create DB with database/solar_db.sql
-- 2. Create osm_repd_closest table with database/osm-repd-location-tables/find-closest-repd-to-osm-inc-no-repd_id.sql

drop table if exists match_rule_3a_results;
drop table if exists match_rule_3b_results;
drop table if exists temp_table1;
drop table if exists temp_table2;

select
  osm_repd_closest.osm_id,
  osm_repd_id_mapping.repd_id as osm_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_co_location_repd_id,
  osm_repd_closest.site_name,
  osm_repd_closest.distance_meters
into temp_table1
from osm_repd_closest
left join osm_repd_id_mapping on osm_repd_closest.osm_id = osm_repd_id_mapping.osm_id;

select
  osm_repd_closest.osm_id,
  osm_repd_id_mapping.repd_id as osm_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_co_location_repd_id,
  osm_repd_closest.site_name,
  osm_repd_closest.distance_meters
into temp_table2
from osm_repd_closest
left join osm_repd_id_mapping on osm_repd_closest.osm_id = osm_repd_id_mapping.osm_id
where osm_repd_closest.distance_meters < 250;

select
  temp_table1.osm_id,
  temp_table1.osm_repd_id,
  temp_table1.closest_geo_match_from_repd_repd_id as repd_id,
  temp_table1.closest_geo_match_from_repd_co_location_repd_id as co_repd,
  temp_table1.site_name as repd_name,
  temp_table1.distance_meters as d_match,
  raw.osm.location::geography <-> repd.location::geography as d_tagged,
  -- raw.osm.objtype,
  -- raw.osm.plantref,
  raw.osm.latitude as o_lat,
  raw.osm.longitude as o_lon,
  repd.latitude as rt_lat, -- coordinates for the "incorrectly" tagged repd entry
  repd.longitude as rt_lon
into match_rule_3a_results
from temp_table1, raw.osm, repd
where temp_table1.osm_id = raw.osm.osm_id
and temp_table1.osm_repd_id is not null
and temp_table1.osm_repd_id = repd.repd_id -- get the REPD entry that was originally tagged for this OSM
and raw.osm.location::geography <-> repd.location::geography > temp_table1.distance_meters; -- but only those further than the OSM distance match

select
  temp_table2.osm_id,
  temp_table2.osm_repd_id,
  temp_table2.closest_geo_match_from_repd_repd_id as repd_id,
  temp_table2.closest_geo_match_from_repd_co_location_repd_id as co_repd,
  temp_table2.site_name as repd_name,
  temp_table2.distance_meters as d_match,
  raw.osm.location::geography <-> repd.location::geography as d_tagged,
  -- raw.osm.objtype,
  -- raw.osm.plantref,
  raw.osm.latitude as lat,
  raw.osm.longitude as lon,
  repd.latitude as r_lat, -- coordinates for the "incorrectly" tagged repd entry
  repd.longitude as r_lon
into match_rule_3b_results
from temp_table2, raw.osm, repd
where temp_table2.osm_id = raw.osm.osm_id
and temp_table2.osm_repd_id is not null
and temp_table2.osm_repd_id = repd.repd_id -- get the REPD entry that was originally tagged for this OSM
and raw.osm.location::geography <-> repd.location::geography > temp_table2.distance_meters; -- but only those further than the OSM distance match

drop table temp_table1;
drop table temp_table2;

select count(*) from match_rule_3a_results;
select count(*) from match_rule_3b_results;
