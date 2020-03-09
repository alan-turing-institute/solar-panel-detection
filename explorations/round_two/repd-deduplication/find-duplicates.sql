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
  closest_pt.site_name as neighbour_name,
  levenshtein(repd.site_name, closest_pt.site_name, 0,2,2) as ld, -- not penalising insertions makes sense only if we can guarantee the 2nd arg is longer ( we can't)
  similarity(repd.site_name, closest_pt.site_name) as sd,
  repd.repd_id,
  -- repd.co_location_repd_id as co_id,
  closest_pt.repd_id as neighbour_id,
  -- closest_pt.co_location_repd_id as neighbour_co_id,
  closest_pt.distance_meters
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
     temp.longitude
     FROM temp
     ORDER BY repd.location::geography <-> temp.location::geography) AS closest_pt
where repd.repd_id != closest_pt.repd_id
-- and repd.operational is not null
and closest_pt.distance_meters < 2000
order by closest_pt.distance_meters asc;

drop table temp;

select
  *
from repd_all_distances;
-- where sd < 0.5
-- where site_name % ANY(STRING_TO_ARRAY(neighbour_name,' '));/
