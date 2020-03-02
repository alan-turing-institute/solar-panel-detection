drop table if exists temp;
drop table if exists osm_dup;
select * into osm_dup from osm;
select
  CONCAT  ('https://www.openstreetmap.org/', objtype, '/', osm_id) AS "object",
  CONCAT  ('https://www.openstreetmap.org/', neighbour_objtype, '/', neighbour_osm_id) AS "neighbour_object",
  distance_meters
into temp
from osm_farm_duplicates;

\copy (select * from temp) to 'data/manual_checking/osm_solar_farm_neighbour_objects.csv' with csv header
drop table temp;
drop table osm_dup;
