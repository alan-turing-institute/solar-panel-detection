-- Match rule 1 (see doc/matching.md)
\echo -n Performing match rule 1a...

drop table if exists repd_copy;
select * into repd_copy from repd_non_operational;
insert into matches
select '1a', repd_copy.master_repd_id, osm.master_osm_id
  from osm_with_existing_repd_neighbours, osm, repd_non_operational, repd_copy
  -- Table linking:
  where osm_with_existing_repd_neighbours.osm_id = osm.osm_id
  and osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd_non_operational.repd_id
  and osm_with_existing_repd_neighbours.repd_id_in_osm = repd_copy.repd_id
  -- Not matches already found:
  and not exists (
    select
    from matches
    where matches.master_repd_id = repd_non_operational.master_repd_id
    or matches.master_osm_id = osm.master_osm_id
  )
  -- Matching relevant:
  and repd_non_operational.location::geography <-> repd_copy.location::geography < 500;
