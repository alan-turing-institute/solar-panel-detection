/*
** Preliminary matching: OSM to REPD
**
** In raw.osm, the field repd_id_str contains a semicolon-separated list of REPD
** ids, possibly empty, whereas we would like this mapping in first normal form.
*/

\echo Breaking out REPD id tags from the OSM dataset

-- osm_repd_id_mapping(osm_id, repd_id)

drop table if exists osm_repd_id_mapping;

select raw.osm.osm_id, x.repd_id into osm_repd_id_mapping
  from raw.osm cross join unnest(string_to_array(repd_id_str, ';')) with ordinality as x(repd_id)
  order by raw.osm.osm_id, x.repd_id;

alter table osm_repd_id_mapping
  alter column repd_id
    set data type int
      using cast (repd_id as integer);


