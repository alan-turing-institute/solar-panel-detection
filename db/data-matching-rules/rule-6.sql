-- Match rule 6 (see doc/matching.md)
\echo -n Performing match rule 6...

insert into matches
select '6', repd.master_repd_id, NULL, mv_repd_neighbours.mv_id
  from mv_repd_neighbours, repd
  where repd.repd_id = mv_repd_neighbours.repd_id
  and mv_repd_neighbours.distance_meters < 1000;
