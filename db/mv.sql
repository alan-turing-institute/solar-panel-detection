/*
** Create table containing Machine Vision database
*/

\echo Creating Machine Vision table ...

drop table if exists machine_vision;

create table machine_vision (
  mv_id          int,
  area           float,
  confidence     char(1),
  install_date   date, -- problem: some don't have proper dates e.g. "<2016-06" and some have multiple dates separated by commas
  iso_code_short char(2),
  iso_code       char(6),
  attribution    varchar(50),
  longitude      float,
  latitude       float,
  primary key (mv_id)
);

\copy machine_vision from '../data/processed/machine_vision.csv' delimiter ',' csv header;

/* -----------------------------------------------------------------------------
** Edit table as necessary
*/

-- Create geometry columns for geographical comparison/matching
-- NB: Spatial Reference ID 4326 refers to WGS84

alter table machine_vision
  add column location geometry(Point, 4326);
  
update machine_vision
  set location = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);


