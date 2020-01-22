-- I think this shows the nearest osm entry to the repd entry with repd_id 1285
-- Using nearest neighbour search
select solar.osm.osm_id, solar.osm_repd_id_mapping.repd_id, solar.repd.repd_id
from solar.osm, solar.repd, solar.osm_repd_id_mapping
where solar.osm_repd_id_mapping.repd_id = 1285 and solar.osm.osm_id = solar.osm_repd_id_mapping.osm_id
order by ST_Distance(solar.osm.geom, solar.repd.geom)
ASC LIMIT 1;
