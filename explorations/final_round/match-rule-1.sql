-- Match rule 0 (see doc/matching.md)
drop table if exists repd_copy;
select * into repd_copy from repd;
-- insert into matches
select 0, repd_copy.master_repd_id, osm.master_osm_id
  from osm_with_existing_repd_neighbours, osm, repd, repd_copy
  -- Table linking:
  where osm_with_existing_repd_neighbours.osm_id = osm.osm_id
  and osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd.repd_id
  and osm_with_existing_repd_neighbours.repd_id_in_osm = repd_copy.repd_id
  -- Matching relevant:
  and repd.location::geography <-> repd_copy.location::geography < 500;
