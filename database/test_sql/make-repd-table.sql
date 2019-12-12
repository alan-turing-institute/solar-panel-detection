-- create schema solar;
drop table if exists solar.repd;
create table solar.repd (
  repd_id integer,
  capacity float,
  postcode varchar(15),
  x integer,
  y integer,
  lat float,
  lon float
);
