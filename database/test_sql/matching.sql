-- SELECT ST_DistanceSphere(st_makepoint(-115, 40), st_makepoint(-118, 38)) As dist_meters
-- FROM
-- 	(SELECT ST_GeomFromText('LINESTRING(-118.584 38.374,-118.583 38.5)', 4326)) as foo;

select solar.osm.osm_id, solar.osm.repd_id_str, solar.repd.repd_id from solar.osm, solar.repd where solar.osm.repd_id_str = '1285' order by ST_Distance(solar.osm.geom, solar.repd.geom) ASC LIMIT 1;
