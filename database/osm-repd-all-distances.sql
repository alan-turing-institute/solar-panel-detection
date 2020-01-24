-- This shows all repd entries' distances to osm entries ordered by distance
-- but only those osm entries with an repd_id
-- Using nearest neighbour search
select solar.osm.osm_id, solar.osm_repd_id_mapping.repd_id as repd_id_in_osm,
solar.repd.repd_id as closest_geo_match_from_repd_repd_id,
solar.repd.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
ST_Distance(solar.osm.geom::geography, solar.repd.geom::geography) as distance_meters
from solar.osm, solar.repd, solar.osm_repd_id_mapping
where solar.osm.osm_id = solar.osm_repd_id_mapping.osm_id
order by ST_Distance(solar.osm.geom::geography, solar.repd.geom::geography);
