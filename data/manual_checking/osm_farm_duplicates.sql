drop table if exists temp;
select
  osm_id,
  neighbour_osm_id,
  distance_meters,
  latitude,
  longitude,
  neighbour_lat,
  neighbour_lon
into temp
from osm_farm_duplicates;

\copy (select * from temp) to 'data/manual_checking/osm_solar_farm_neighbour_objects.csv' with csv header
drop table temp;
