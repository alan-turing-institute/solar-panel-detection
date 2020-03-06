% The hut23-425 database

This note documents the creation of the `hut23-425` database.

## Database creation scripts

SQL code to create and populate the database is in the `db/` directory. To
create the complete database, change to that directory and run:

```bash
psql -f make-database.sql
```

This script will in turn call `osm.sql`, `repd.sql`, `fit.sql`, and `mv.sql`
which create and populate the following tables, and add a small number of
additional columns. Note that the schema `raw` is used as a staging area for
certain tables were it is necessary to do some postprocessing; after
postprocessing the 



- `raw.osm`: The raw OSM data.
- `raw.repd`: The raw REPD data.
- `repd`: The REPD data restricted to solar PV technologies.
- `fit`: The FiT data. 
- `mv`: The machine vision data. 

A field, `area`, is added to the `fit` table, containing an estimate of the area
of the solar panel(s) based on the declared net capacity.

The tables `osm`, `repd`, and `mv` include a latitude and longitude for each
installation. An additional field `location` is added to these tables containing
these coordinates converted to a Postgis point.

The schema `raw` is used as a staging area for certain tables. 



## Post-processing scripts





