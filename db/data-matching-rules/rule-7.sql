-- Match rule 7 (see doc/matching.md)
\echo -n Performing match rule 7...

insert into matches
select '7', NULL, osm.master_osm_id, osm_mv_neighbours.mv_id
  from osm_mv_neighbours, osm
  where osm.osm_id = osm_mv_neighbours.osm_id
  and osm_mv_neighbours.distance_meters < 1000;
