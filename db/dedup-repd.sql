drop table if exists repd_all_distances;
drop table if exists temp;
CREATE EXTENSION if not exists pg_trgm;

-- Duplicate this table so we can compare it against itself:
select *
into temp
from repd;

-- Get the nearest REPD to each REPD below threshold: 1380m
-- Get modified strings of the site names, removing common words
select
  repd.site_name,
  replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(repd.site_name, 'solar', ''), 'Solar', ''), 'park', ''), 'Park', ''), 'farm', ''), 'Farm', ''), '(resubmission)', ''), '(Resubmission)', ''), 'extension', ''), 'resubmission', ''), ' - ', ''), 'Extension', ''), '  ', ' '), '()', '') as site_name_reduced,
  closest_pt.site_name as neighbour_site_name,
  replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(closest_pt.site_name, 'solar', ''), 'Solar', ''), 'park', ''), 'Park', ''), 'farm', ''), 'Farm', ''), '(resubmission)', ''), '(Resubmission)', ''), 'extension', ''), 'resubmission', ''), ' - ', ''), 'Extension', ''), '  ', ' '), '()', '') as neighbour_site_name_reduced,
  repd.repd_id,
  closest_pt.repd_id as neighbour_id,
  closest_pt.distance_meters
into repd_all_distances
from repd
CROSS JOIN LATERAL
  (SELECT
    temp.site_name,
     temp.repd_id,
     temp.co_location_repd_id,
     repd.location::geography <-> temp.location::geography as distance_meters
     FROM temp
     ORDER BY repd.location::geography <-> temp.location::geography) AS closest_pt
where repd.repd_id != closest_pt.repd_id
and closest_pt.distance_meters < 1380 -- Everything over this distance looks to be separate installations
order by closest_pt.distance_meters asc;

drop table temp;

-- Use similarity function on site names sans common words
drop table if exists repd_proximity_matches;
select
  site_name,
  neighbour_site_name,
  site_name_reduced,
  neighbour_site_name_reduced,
  similarity(site_name_reduced, neighbour_site_name_reduced) as sd,
  repd_id,
  neighbour_id,
  distance_meters
into repd_proximity_matches
from repd_all_distances;

-- Decide what constitues REPD enrties being duplicates (to be grouped)
drop table if exists repd_duplicates;
select *
into repd_duplicates
from repd_proximity_matches
where sd >= 0.2 -- Small similarity in site name = likely same thing, given distance constraint
or distance_meters = 0; -- Where location identical, assume grouping even if name different

-- Create groupings of matched objects. TODO: update similar to James G OSM Dedup code
alter table repd_duplicates
  add column "ordered" BOOLEAN;

update repd_duplicates
  set ordered = repd_id > neighbour_id;

drop table if exists repd_group_leaders;
select repd_id, bool_and(ordered) as keep into repd_group_leaders
  from repd_duplicates
  group by repd_id;

select * from repd_group_leaders;
