create schema if not exists solar;

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

drop table if exists solar.repd;
create table solar.repd (
  old_repd_id varchar(15),
  repd_id integer,
  record_last_updated date,
  tech_type varchar(40),
  storage_type varchar(40),
  co_location_repd_id varchar(10),
  capacity varchar(8),
  chp_enabled varchar(3),
  ro_banding varchar(10),
  fit_tariff varchar(10),
  cfd_capacity varchar(10),
  turbine_capacity varchar(10),
  num_turbines varchar(10),
  height_turbines varchar(10),
  mounting_type varchar(10),
  dev_status varchar(40),
  dev_status_short varchar(30),
  county varchar(30),
  region varchar(20),
  country varchar (20),
  postcode varchar(15),
  x varchar(10),
  y varchar(10),
  planning_authority varchar(70),
  appeal_reference varchar(50),
  sec_state_ref varchar(50),
  type_sec_state_intervention varchar(20),
  judicial_review integer,
  offshore_wind_round varchar(10),
  planning_application_submitted date,
  planning_application_withdrawn date,
  planning_permission_refused date,
  appeal_lodged date,
  appeal_withdrawn date,
  appeal_refused date,
  appeal_granted date,
  planning_permission_granted date,
  sec_state_intervened date,
  sec_state_refused date,
  sec_state_granted date,
  planning_permission_expired date,
  under_construction date,
  operational date,
  primary key (repd_id)
);

drop table if exists solar.mv;
create table solar.mv (
  area float,
  confidence char(1),
  install_date varchar(30), -- problem is that some of them don't have proper dates e.g. "<2016-06" and some have multiple separated by comma
  iso_code_short char(2),
  iso_code char(6),
  attribution varchar(50),
  longitude float,
  latitude float,
  primary key (latitude, longitude)
);

drop table if exists solar.fit;
create table solar.fit (
  extension char(1),
  postcode_stub varchar(7),
  technology varchar(24),
  installed_capacity float,
  declared_net_capacity float,
  application_date date,
  commissioning_date date,
  mcs_issue_date date,
  export_status varchar(30),
  tariff_code varchar(20),
  tariff_description varchar(100),
  installation_type varchar(25),
  country varchar(15),
  local_authority varchar(40),
  govt_office_region varchar(40),
  constituency varchar(60),
  accreditation_route varchar(6),
  mpan_prefix int,
  comm_school varchar(40),
  llsoa_code varchar(20)
);

-- Upload data
-- The subdir data/raw/ should be a symbolic link to the actual data on the shared space
\copy solar.repd from 'data/raw/repd_modified.csv' delimiter ',' csv header;
\copy solar.osm from 'data/raw/osm_compile_processed_PV_objects_modified.csv' delimiter ',' csv header;
\copy solar.mv from 'data/raw/machine_vision.csv' delimiter ',' csv header;
\copy solar.fit from 'data/raw/feed-in_tariff_installation_report_30_september_2019.csv' delimiter ',' csv header;
