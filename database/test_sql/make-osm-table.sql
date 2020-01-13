drop table if exists solar.osm;
create table solar.osm (
  objtype varchar(8),
  id bigint,
  username varchar(60),
  time_created date,
  latitude float,
  longitude float,
  area float,
  capacity float,
  modules int,
  located varchar(20),
  orientation varchar(10),
  plantref varchar(20),
  tag_power varchar(15),
  repd_id varchar(20), -- should be int, but some rows have multiple separated by semicolon
  tag_start_date varchar(20), -- for some reason "2008" is invalid input for type date, but also, some are like "before 2012-02-19"
  primary key (id)
);
copy solar.osm
from '/Users/echalstrey/projects/solar-panel-detection/data/raw/osm_compile_processed_PV_objects_modified.csv' delimiter ',' header csv;
