drop table if exists osm_with_repd_id_repd_closest;
select
  osm_repd_closest.osm_id,
  osm_repd_id_mapping.repd_id as repd_id_in_osm,
  osm_repd_closest.closest_geo_match_from_repd_repd_id,
  osm_repd_closest.closest_geo_match_from_repd_co_location_repd_id,
  osm_repd_closest.distance_meters,
  osm_repd_closest.site_name
into osm_with_repd_id_repd_closest
from osm_repd_closest, osm_repd_id_mapping
where osm_repd_closest.osm_id = osm_repd_id_mapping.osm_id;

-- OSM with REPD id with closest geographical match in REPD having that repd_id and co-located REPD id:
-- See Match Rule 11
