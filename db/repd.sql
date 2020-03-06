/*
** Create table containing REPD database
*/

\echo Creating REPD table ...

drop table if exists raw.repd;
drop table if exists repd;

create table raw.repd (
  old_repd_id                    varchar(15),
  repd_id                        integer,
  record_last_updated            date,
  operator                       varchar(100),
  site_name                      varchar(100),
  tech_type                      varchar(40),
  storage_type                   varchar(40),
  co_location_repd_id            float, -- can't make this int as csv contains NaN, but this is fixed below
  capacity                       varchar(8),
  chp_enabled                    varchar(3),
  ro_banding                     varchar(10),
  fit_tariff                     float,
  cfd_capacity                   varchar(10),
  turbine_capacity               varchar(10),
  num_turbines                   varchar(10),
  height_turbines                varchar(10),
  mounting_type                  varchar(10),
  dev_status                     varchar(40),
  dev_status_short               varchar(30),
  address                        varchar(300),
  county                         varchar(30),
  region                         varchar(20),
  country                        varchar(20),
  postcode                       varchar(15),
  x                              float,
  y                              float,
  planning_authority             varchar(70),
  planning_application_reference varchar(50),
  appeal_reference               varchar(50),
  sec_state_ref                  varchar(50),
  type_sec_state_intervention    varchar(20),
  judicial_review                float,
  offshore_wind_round            varchar(10),
  planning_application_submitted date,
  planning_application_withdrawn date,
  planning_permission_refused    date,
  appeal_lodged                  date,
  appeal_withdrawn               date,
  appeal_refused                 date,
  appeal_granted                 date,
  planning_permission_granted    date,
  sec_state_intervened           date,
  sec_state_refused              date,
  sec_state_granted              date,
  planning_permission_expired    date,
  under_construction             date,
  operational                    date,
  latitude                       float,
  longitude                      float,
  primary key (repd_id)
);

\copy raw.repd from '../data/processed/repd-2019-09.csv' delimiter ',' csv header;


/* -----------------------------------------------------------------------------
** Edit table as necessary
*/

-- Change co_location_repd_id to integer
alter table raw.repd
  alter column co_location_repd_id
    set data type int
      using cast (co_location_repd_id as integer);


-- Create geometry columns for geographical comparison/matching
-- NB: Spatial Reference ID 4326 refers to WGS84

alter table raw.repd
  add column location geometry(Point, 4326);

update raw.repd
  set location = ST_SetSRID(ST_MakePoint(longitude, latitude), 4326);

/* -----------------------------------------------------------------------------
** Generate final table
*/

-- Restrict REPD to Solar PV only
select * into repd
  from raw.repd
  where tech_type = 'Solar Photovoltaics';

alter table repd
  drop column tech_type;

