
\echo -n Finding matches across datasets ...

drop table if exists matches;
create table matches (
  match_rule     integer,
  master_repd_id integer,
  master_osm_id  bigint,
  mv_id          integer,
  fit_id         integer
);

-- TODO: perform matching a second time, for non-operational REPD
\include data-matching-rules/rule-1.sql
\include data-matching-rules/rule-2.sql
\include data-matching-rules/rule-3.sql
\include data-matching-rules/rule-4.sql
\include data-matching-rules/rule-5.sql
