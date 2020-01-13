drop table if exists solar.fit;
create table temp_table (
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
copy temp_table
from '/Users/echalstrey/projects/solar-panel-detection/data/raw/feed-in_tariff_installation_report_30_september_2019.csv' delimiter ',' header csv;
select distinct *
into solar.fit
from temp_table;
select count(*) from temp_table;
select count(*) from solar.fit;
drop table if exists temp_table;
alter table if exists solar.fit add primary key (postcode_stub, local_authority, tariff_description, installed_capacity, commissioning_date);
select postcode_stub, local_authority, tariff_code, installation_type, installed_capacity, declared_net_capacity, application_date, commissioning_date, mcs_issue_date, export_status, mpan_prefix, constituency, accreditation_route, comm_school, llsoa_code, extension, count(*)
from solar.fit
group by postcode_stub, local_authority, tariff_code, installation_type, installed_capacity, declared_net_capacity, application_date, commissioning_date, mcs_issue_date, export_status, mpan_prefix, constituency, accreditation_route, comm_school, llsoa_code, extension
having count(*) > 1; 
