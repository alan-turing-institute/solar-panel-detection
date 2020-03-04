select count(*) from osm_with_repd_id_repd_closest
where repd_id_in_osm = closest_geo_match_from_repd_repd_id;

select count(*) from osm_with_repd_id_repd_closest
where repd_id_in_osm = closest_geo_match_from_repd_co_location_repd_id;
