
\echo -n Finding matches across datasets ...

drop table if exists matches;
create table matches (
  master_repd_id integer,
  master_osm_id  bigint,
  mv_id          integer,
  fit_id         integer
);

-- Find the nearest neighbouring REPD object to each OSM object
 drop table if exists osm_repd_neighbours;
 select osm.osm_id,
        closest_pt.repd_id as closest_geo_match_from_repd_repd_id,
        closest_pt.co_location_repd_id as closest_geo_match_from_repd_co_location_repd_id,
        closest_pt.distance_meters
   into osm_repd_neighbours
   from osm
   CROSS JOIN LATERAL
     (SELECT
        repd.repd_id,
        repd.co_location_repd_id,
        osm.location::geography <-> repd.location::geography as distance_meters
        FROM repd
        ORDER BY osm.location::geography <-> repd.location::geography
      LIMIT 1) AS closest_pt;

-- Create a table that compares the neighbour REPD ID to those that were found
-- in the OSM data (where present)
drop table if exists osm_with_existing_repd_neighbours;
select osm_repd_neighbours.osm_id,
       osm_repd_id_mapping.repd_id as repd_id_in_osm,
       osm_repd_neighbours.closest_geo_match_from_repd_repd_id,
       osm_repd_neighbours.closest_geo_match_from_repd_co_location_repd_id,
       osm_repd_neighbours.distance_meters
  into osm_with_existing_repd_neighbours
  from osm_repd_neighbours, osm_repd_id_mapping
  where osm_repd_neighbours.osm_id = osm_repd_id_mapping.osm_id;

-- Match rule 1 (see doc/matching.md)
insert into matches
select repd.master_repd_id, osm.master_osm_id
  from osm_with_existing_repd_neighbours, osm, repd
  where osm_with_existing_repd_neighbours.osm_id = osm.osm_id
  and osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id = repd.repd_id
  and (osm_with_existing_repd_neighbours.repd_id_in_osm = osm_with_existing_repd_neighbours.closest_geo_match_from_repd_repd_id
      or osm_with_existing_repd_neighbours.repd_id_in_osm = osm_with_existing_repd_neighbours.closest_geo_match_from_repd_co_location_repd_id
      or osm_with_existing_repd_neighbours.repd_id_in_osm = repd.master_repd_id);
