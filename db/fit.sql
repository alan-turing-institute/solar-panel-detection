/*
** Create table containing fit dataset
*/

\echo Creating fit table ...

drop table if exists raw.fit;
drop table if exists fit;

create table raw.fit (
  fit_id                int,
  extension             char(1),
  postcode_stub         varchar(7),
  technology            varchar(24),
  installed_capacity    float,
  declared_net_capacity float,
  application_date      date,
  commissioning_date    date,
  mcs_issue_date        date,
  export_status         varchar(30),
  tariff_code           varchar(20),
  tariff_description    varchar(100),
  installation_type     varchar(25),
  country               varchar(15),
  local_authority       varchar(40),
  govt_office_region    varchar(40),
  constituency          varchar(60),
  accreditation_route   varchar(6),
  mpan_prefix           float,
  comm_school           varchar(40),
  llsoa_code            varchar(20)
);

\copy raw.fit from '../data/processed/fit.csv' delimiter ',' csv header;

-- Restrict raw.fit to Solar PV only
select * into fit
  from raw.fit
  where technology = 'Photovoltaic';

-- Add roughly calculated area for raw.fit entries to aid matching.
-- Solar PV has power approx. 52W / m^2
alter table fit
  add column "area" float;

update fit
  set area = declared_net_capacity/52;
