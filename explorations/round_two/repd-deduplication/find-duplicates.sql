drop table if exists repd_all_distances;
drop table if exists temp;
CREATE EXTENSION if not exists fuzzystrmatch;
CREATE EXTENSION if not exists pg_trgm;
-- Duplicate this table so we can compare it against itself:
select *
into temp
from repd
where operational is not null;

-- Next 2 queries: Get the nearest other entry for each in the table above, but only those
-- within a certain distance (e.g. 300m)
select
  repd.site_name,
  replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(repd.site_name, 'solar', ''), 'Solar', ''), 'park', ''), 'Park', ''), 'farm', ''), 'Farm', ''), '(resubmission)', ''), '(Resubmission)', ''), 'extension', ''), 'resubmission', ''), ' - ', ''), 'Extension', ''), '  ', ' '), '()', '') as site_name_reduced,
  closest_pt.site_name as neighbour_site_name,
  replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(closest_pt.site_name, 'solar', ''), 'Solar', ''), 'park', ''), 'Park', ''), 'farm', ''), 'Farm', ''), '(resubmission)', ''), '(Resubmission)', ''), 'extension', ''), 'resubmission', ''), ' - ', ''), 'Extension', ''), '  ', ' '), '()', '') as neighbour_site_name_reduced,
  repd.repd_id,
  -- repd.co_location_repd_id as co_id,
  closest_pt.repd_id as neighbour_id,
  -- closest_pt.co_location_repd_id as neighbour_co_id,
  closest_pt.distance_meters,
  repd.capacity,
  closest_pt.capacity as neighbour_cap
  -- repd.latitude, -- Having these enables manual checking
  -- repd.longitude,
  -- closest_pt.latitude as neighbour_lat, -- Having these enables manual checking
  -- closest_pt.longitude as neighbour_lon
into repd_all_distances
from repd
CROSS JOIN LATERAL
  (SELECT
    temp.site_name,
     temp.repd_id,
     temp.co_location_repd_id,
     repd.location::geography <-> temp.location::geography as distance_meters,
     temp.latitude, -- Having these enables manual checking
     temp.longitude,
     temp.capacity
     FROM temp
     ORDER BY repd.location::geography <-> temp.location::geography) AS closest_pt
where repd.repd_id != closest_pt.repd_id
-- and repd.operational is not null
and closest_pt.distance_meters < 1380
order by closest_pt.distance_meters asc;

drop table temp;

drop table if exists repd_proximity_matches;
select -- This should NOT select definite matches
  site_name,
  neighbour_site_name,
  site_name_reduced,
  neighbour_site_name_reduced,
  -- levenshtein(site_name_reduced, neighbour_site_name_reduced, 1, 1, 2) as ld, -- not penalising insertions makes sense only if we can guarantee the 2nd arg is longer ( we can't)
  similarity(site_name_reduced, neighbour_site_name_reduced) as sd,
  repd_id,
  neighbour_id,
  distance_meters,
  capacity,
  neighbour_cap
into repd_proximity_matches
from repd_all_distances;

drop table if exists possible_repd_duplicates;
select *
into possible_repd_duplicates
from repd_proximity_matches
where sd < 0.2
and distance_meters > 0;
order by distance_meters asc;

drop table if exists repd_duplicates;
select *
into repd_duplicates
from repd_proximity_matches
where sd >= 0.2
or distance_meters = 0;
order by distance_meters asc;

select count(*) from repd_proximity_matches;
select count(*) from possible_repd_duplicates;
select count(*) from repd_duplicates;

select * from repd_duplicates;
