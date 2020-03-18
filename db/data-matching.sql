
\echo -n Finding matches across datasets ...

drop table if exists matches;
create table matches (
  match_rule     integer,
  master_repd_id integer,
  master_osm_id  bigint,
  mv_id          integer,
  fit_id         integer
);

drop table if exists repd_operational;
select * into repd_operational from repd where dev_status = 'Operational';

drop table if exists repd_non_operational;
select * into repd_non_operational from repd where dev_status != 'Operational';

\include data-matching-rules/rule-1.sql
\include data-matching-rules/rule-2.sql
\include data-matching-rules/rule-3.sql
\include data-matching-rules/rule-4.sql
\include data-matching-rules/rule-5.sql
