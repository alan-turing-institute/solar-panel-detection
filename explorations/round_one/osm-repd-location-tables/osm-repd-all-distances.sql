-- This shows all repd entries' distances to osm entries ordered by distance
-- but only those osm entries with an repd_id
-- Using nearest neighbour search
drop table if exists osm_repd_all_distances;
select
  raw.osm.osm_id,
  osm_repd_id_mapping.repd_id as repd_id_in_osm,
  repd.repd_id as closest_geo_match_from_repd_repd_id,
  repd.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
  ST_Distance(raw.osm.location::geography, repd.location::geography) as distance_meters
into osm_repd_all_distances
from raw.osm, repd, osm_repd_id_mapping
where raw.osm.osm_id = osm_repd_id_mapping.osm_id
order by ST_Distance(raw.osm.location::geography, repd.location::geography);
