-- This shows the osm entries close to repd entries, but only those with an repd_id already
-- Using nearest neighbour search
select solar.osm.osm_id, solar.osm_repd_id_mapping.repd_id, solar.repd.repd_id as matching_repd_id
from solar.osm, solar.repd, solar.osm_repd_id_mapping
where solar.osm.osm_id = solar.osm_repd_id_mapping.osm_id
and solar.osm.geom && ST_Expand(solar.repd.geom, 200) -- Find all those within 200m
order by ST_Distance(solar.osm.geom, solar.repd.geom);

-- I don't understand why this code results in a table with many copies of the same ids
select solar.osm.osm_id, solar.osm.repd_id_str, solar.repd.repd_id as matching_repd_id
from solar.osm, solar.repd, solar.osm_repd_id_mapping
where solar.osm.repd_id_str = '1878'
and solar.osm.geom && ST_Expand(solar.repd.geom, 200) -- Find all those within 200m
order by ST_Distance(solar.osm.geom, solar.repd.geom) asc;

-- How many osm rows are there?
select count(*) from solar.osm; -- 126,939

-- How many osm rows with REPD are there?
select count(repd_id_str) from solar.osm; -- 893

-- How many osm geoms match to repd geoms?


-- Out of those, how to make
