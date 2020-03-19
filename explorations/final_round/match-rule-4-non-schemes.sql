--- Match rule 5 (see doc/matching.md)
-- insert into matches

select repd.master_repd_id,
       osm.master_osm_id,
       osm_repd_neighbours.distance_meters,
       CONCAT  (osm.objtype, '/', osm.osm_id) AS "osm",
       repd.latitude as r_lat,
       repd.longitude as r_lon,
       repd.site_name,
       osm.capacity as osm_cap,
       repd.capacity as repd_cap

  from osm_repd_neighbours, osm, repd
  where osm_repd_neighbours.osm_id = osm.osm_id
  and osm_repd_neighbours.closest_geo_match_from_repd_repd_id = repd.repd_id
  and osm.osm_id = osm.master_osm_id
  and repd.repd_id = repd.master_repd_id
  and not exists (
    select
    from matches
    where matches.master_repd_id = repd.master_repd_id
    or matches.master_osm_id = osm.master_osm_id
  )
  and osm.objtype = 'node'
  and repd.site_name not like '%Scheme%'
  and osm_repd_neighbours.distance_meters < 1000
  order by osm_repd_neighbours.distance_meters;
