-- Match rule 2 (see doc/matching.md)
-- insert into matches

select *
into repd_copy
from repd;

-- TODO: modify so that we don't only get those with an repd in osm
drop table if exists temp_match;
select repd.master_repd_id,
       osm.master_osm_id,
       osm_with_existing_repd_neighbours.distance_meters,
       CONCAT  (osm.objtype, '/', osm.osm_id) AS "osm",
       repd.latitude as r_lat,
       repd.longitude as r_lon,
       repd.site_name,
       repd_copy.repd_id,
       repd_copy.site_name

  from osm_with_existing_repd_neighbours, osm, repd, osm_repd_id_mapping, repd_copy
  where osm_with_existing_repd_neighbours.osm_id = osm.osm_id
  and osm_repd_id_mapping.osm_id = osm_with_existing_repd_neighbours.osm_id
  and repd_copy.repd_id = osm_repd_id_mapping.repd_id
  and osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd.repd_id
  and osm.objtype != 'node'
  and osm.osm_id = osm.master_osm_id
  and repd.repd_id = repd.master_repd_id
  and not exists (
    select
    from matches
    where matches.master_repd_id = repd.master_repd_id
    or matches.master_osm_id = osm.master_osm_id
  )
  order by osm_with_existing_repd_neighbours.distance_meters;
