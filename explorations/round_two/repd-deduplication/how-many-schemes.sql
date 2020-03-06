select site_name
into schemes
from repd
where site_name like '%Scheme%'
and tech_type = 'Solar Photovoltaics';

select * from schemes;
select count(*) from schemes;
