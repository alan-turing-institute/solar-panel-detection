drop table if exists solar.mv;
create table solar.mv (
  area float,
  confidence char(1),
  install_date varchar(30), -- problem is that some of them don't have proper dates e.g. "<2016-06" and some have multiple separated by comma
  iso_code_short char(2),
  iso_code char(6),
  attribution varchar(50),
  longitude float,
  latitude float
);
copy solar.mv
from '/Users/echalstrey/projects/solar-panel-detection/data/raw/machine_vision.csv' delimiter ',' header csv;