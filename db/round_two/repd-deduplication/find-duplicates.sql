drop table if exists temp;
-- Duplicate this table so we can compare it against itself:
select *
into temp
from repd
where tech_type = 'Solar Photovoltaics'; -- update solar_db.sql

-- Next 2 queries: Get the nearest other entry for each in the table above, but only those
-- within a certain distance (e.g. 300m)
select
  repd.repd_id,
  closest_pt.repd_id as neighbour_id,
  closest_pt.distance_meters,
  repd.latitude, -- Having these enables manual checking
  repd.longitude,
  closest_pt.latitude as neighbour_lat, -- Having these enables manual checking
  closest_pt.longitude as neighbour_lon
into repd_all_distances
from repd
CROSS JOIN LATERAL
  (SELECT
     temp.repd_id,
     repd.location::geography <-> temp.location::geography as distance_meters,
     temp.latitude, -- Having these enables manual checking
     temp.longitude
     FROM temp
     ORDER BY repd.location::geography <-> temp.location::geography) AS closest_pt
where repd.repd_id != closest_pt.repd_id
and repd.tech_type = 'Solar Photovoltaics';

drop table temp;
