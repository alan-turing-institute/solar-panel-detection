-- Create csv of pairwise farm objject to neighbour farm object proximity matches <300m
drop table if exists temp;
select
  CONCAT  ('https://www.openstreetmap.org/', objtype, '/', osm_id) AS "object",
  located,
  CONCAT  ('https://www.openstreetmap.org/', neighbour_objtype, '/', neighbour_osm_id) AS "neighbour_object",
  neighbour_located,
  distance_meters
into temp
from osm_farm_duplicates
order by distance_meters desc;

\copy (select * from temp) to 'data/manual_checking/osm_solar_farm_neighbour_objects.csv' with csv header
drop table temp;

-- Create a csv similar mapping exisiting master_osm_id ans osm_ids (fromn Dan's plantref)

select
  CONCAT  ('https://www.openstreetmap.org/', objtype, '/', osm_id) AS "object",
  CONCAT  ('https://www.openstreetmap.org/', objtype, '/', master_osm_id) AS "plantref",
  osm.located
into temp
from osm
where osm.master_osm_id is not null;

\copy (select * from temp) to 'data/manual_checking/existing_plantrefs.csv' with csv header
drop table temp;
