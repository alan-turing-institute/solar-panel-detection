drop table if exists solar.fit;
create table solar.fit (
  postcode_stub varchar(7),
  installed_capacity float,
  declared_net_capacity float,
  constituency varchar(50),
  application_date date,
  commissioning_date date,
  tariff_code varchar(20),
  tariff_description varchar(100),
  installation_type varchar(25),
  llsoa_code varchar(20)
);
