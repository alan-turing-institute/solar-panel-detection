
\echo -n Finding matches across datasets ...

drop table if exists matches;
create table matches (
  match_rule     integer,
  master_repd_id integer,
  master_osm_id  bigint,
  mv_id          integer,
  fit_id         integer
);


-- Match rule 0 (see doc/matching.md)
drop table if exists repd_copy;
select * into repd_copy from repd;
insert into matches
select 0, repd_copy.master_repd_id, osm.master_osm_id
  from osm_with_existing_repd_neighbours, osm, repd, repd_copy
  -- Table linking:
  where osm_with_existing_repd_neighbours.osm_id = osm.osm_id
  and osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd.repd_id
  and osm_with_existing_repd_neighbours.repd_id_in_osm = repd_copy.repd_id
  -- Matching relevant:
  and repd.location::geography <-> repd_copy.location::geography < 500;


-- Match rule 1 (see doc/matching.md)
insert into matches
select 1, repd.master_repd_id, osm.master_osm_id
  from osm_with_existing_repd_neighbours, osm, repd, repd_copy
  -- Table linking:
  where osm_with_existing_repd_neighbours.osm_id = osm.osm_id
  and osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd.repd_id
  and osm_with_existing_repd_neighbours.repd_id_in_osm = repd_copy.repd_id
  -- Not matches already found:
  and not exists (
    select
    from matches
    where matches.master_repd_id = repd.master_repd_id
    or matches.master_osm_id = osm.master_osm_id
  )
  -- Matching relevant:
  and   (osm_with_existing_repd_neighbours.repd_id_in_osm = osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id
      or osm_with_existing_repd_neighbours.repd_id_in_osm = osm_with_existing_repd_neighbours.closest_geo_match_from_repd_co_location_repd_id
      or osm_with_existing_repd_neighbours.repd_id_in_osm = repd.master_repd_id
      or osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd_copy.co_location_repd_id
      or osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd_copy.master_repd_id
    );


-- Match rule 2 (see doc/matching.md)
insert into matches
select 2, repd.master_repd_id, osm.master_osm_id
  from osm_repd_neighbours, osm, repd
  where osm_repd_neighbours.osm_id = osm.osm_id
  and osm_repd_neighbours.closest_geo_match_from_repd_repd_id = repd.repd_id
  and osm.objtype != 'node'
  and osm.osm_id = osm.master_osm_id
  and repd.repd_id = repd.master_repd_id
  and not exists (
    select
    from matches
    where matches.master_repd_id = repd.master_repd_id
    or matches.master_osm_id = osm.master_osm_id
  )
  and osm_repd_neighbours.distance_meters < 700
  order by osm_repd_neighbours.distance_meters;
