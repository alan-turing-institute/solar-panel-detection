/*
** Create table containing OSM database
*/

\echo Creating OSM table ...

drop table if exists raw.osm;

create table raw.osm (
  objtype        varchar(8),
  osm_id         bigint,
  username       varchar(60),
  time_created   date,
  latitude       float,
  longitude      float,
  area           float,
  capacity       float,
  modules        float,
  located        varchar(20),
  orientation    varchar(10),
  plantref       varchar(20),
  tag_power      varchar(15),
  repd_id_str    varchar(20),
  tag_start_date date,
  primary key (osm_id)
);

\copy raw.osm from '../data/processed/osm.csv' delimiter ',' csv header;

/* -----------------------------------------------------------------------------
** Edit table as necessary
*/

-- Create geometry columns for geographical comparison/matching
-- NB: Spatial Reference ID 4326 refers to WGS84

alter table raw.osm
  add column location geometry(Point, 4326);

update raw.osm
  set location = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);
