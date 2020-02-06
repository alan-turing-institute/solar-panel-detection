select distinct solar.osm.located from solar.osm;

select count(*)
from solar.osm
where solar.osm.repd_id_str is not null
and (solar.osm.located = 'roof'
or solar.osm.located = 'rood'
or solar.osm.located = 'rof'
or solar.osm.located = 'roofq'
or solar.osm.located = 'roofs');

select solar.osm.located, count(solar.osm.located)
from solar.osm
where solar.osm.repd_id_str is not null
group by solar.osm.located;
