drop table if exists osm_possible_farm_duplicates;
drop table if exists temp;
drop table if exists osm_dup;

select *
into osm_dup
from osm;

select *
into osm_possible_farm_duplicates
from osm
where osm.objtype != 'node' -- ignore nodes
and (osm.master_osm_id != osm.osm_id -- ignore those that already have a plantref (already de-duplicated)
  or osm.master_osm_id is null)
and osm.located != 'roof' -- ignore rooftop things
and osm.located != 'rood'
and osm.located != 'roofq'
and osm.located != 'rof'
and osm.located != 'roofs';

-- Duplicate this table so we can compare it against itself:
select *
into temp
from osm_possible_farm_duplicates;

-- Modify to get the location from osm
SELECT
  osm_possible_farm_duplicates.osm_id,
  temp.osm_id as neighbouring_osm_id,
  ST_Distance(osm_dup.location::geography, raw.osm.location::geography) as dist
FROM
  osm_possible_farm_duplicates,
  temp,
  osm_dup,
  raw.osm
WHERE osm_possible_farm_duplicates.osm_id != temp.osm_id
and osm_dup.osm_id = osm_possible_farm_duplicates.osm_id
and raw.osm.osm_id = temp.osm_id
and ST_Distance(osm_dup.location::geography, raw.osm.location::geography) < 1000
ORDER BY osm_possible_farm_duplicates.osm_id ASC;
