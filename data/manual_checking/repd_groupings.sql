drop table if exists repd_duplicates_csv;
select
  site_name,
  neighbour_site_name,
  repd_id,
  neighbour_id,
  distance_meters
into repd_duplicates_csv
from repd_duplicates;

\copy (select * from repd_duplicates_csv) to 'data/manual_checking/repd_groupings.csv' with csv header

drop table if exists repd_ambiguous_csv;
select
  site_name,
  neighbour_site_name,
  repd_id,
  neighbour_id,
  distance_meters
into repd_ambiguous_csv
from possible_repd_duplicates;

\copy (select * from repd_ambiguous_csv) to 'data/manual_checking/repd_ambiguous.csv' with csv header
