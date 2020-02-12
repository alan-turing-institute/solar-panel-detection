-- What are the distances for the osm's that have an repd_id's lat/lon with matching repd_ids
-- Using nearest neighbour search
drop table if exists repd_linked_distances;
select
  raw.osm.osm_id,
  osm_repd_id_mapping.repd_id as repd_id_in_osm,
  repd.repd_id as closest_geo_match_from_repd_repd_id,
  repd.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
  ST_Distance(raw.osm.location::geography,repd.location::geography) as distance_meters
into repd_linked_distances
from raw.osm,repd, osm_repd_id_mapping
where raw.osm.osm_id = osm_repd_id_mapping.osm_id
and repd.repd_id = osm_repd_id_mapping.repd_id
order by ST_Distance(raw.osm.location::geography,repd.location::geography);

-- Get 6 number summary
select
  min(distance_meters),
  percentile_disc(0.25) within group (order by repd_linked_distances.distance_meters) as first_quartile,
  percentile_disc(0.5) within group (order by repd_linked_distances.distance_meters) as median,
  avg(distance_meters) as mean,
  percentile_disc(0.75) within group (order by repd_linked_distances.distance_meters) as third_quartile,
  max(distance_meters)
from repd_linked_distances;
