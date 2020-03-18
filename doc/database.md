% The hut23-425 database

This note documents the creation of the `hut23-425` database and the initial
deduplication of the data.

We use an "Extract-Load-Transform" methodology: Tables of the source datasets
are first uploaded (from the `data/processed` directory) into the schema `raw`
in the database, then post-processed in the database and saved as tables in the
default schema. (Some tables do not require post-processing and are uploaded
directly into the default schema.) In this note, we assume that the
pre-processing has already taken place.

In summary, the final tables created, and row counts as of commit `0d8d38b` are:

| Table                 | Row count | Master entity field | Master entity count |
|-----------------------|-----------|---------------------|---------------------|
| `osm`                 |    126,939| `master_osm_id`     |              119,427|
| `repd`                |      1,986| `master_repd_id`    |               1,736 |
| `fit`                 |    863,079|                     |                     |
| `machine_vision`      |      2,221|                     |                     |
| `osm_repd_id_mapping` |       933 |                     |                     |

(In the above table, the master entity count is the number of the distinct
entries in the named column)

# 1. Database creation scripts

These scripts assume the existence of a local Postgres installation containing a
database called `hut23-425`. To create the database, run:

```bash
createdb hut23-425 "Solar PV database matching"
```

## Upload of source data

SQL code to create the tables and populate the database is in the `db/`
directory. To create the complete database, change to that directory and run:

```bash
psql -f make-database.sql hut23-425
```

This script will in turn call `osm.sql`, `repd.sql`, `fit.sql`, `mv.sql`,
`match-osm-repd.sql`, and `dedup-osm.sql` which create and populate the data
tables from the respective source data in `../data/processed/` (adding a small
number of additional columns) and then postprocessing. Note that the schema
`raw` is used as a staging area for certain tables where it is necessary to do
some postprocessing. After postprocessing the working tables will be in the
default schema.

- `raw.osm`: The raw OSM data.
- `raw.repd`: The raw REPD data.
- `repd`: The REPD data, restricted to solar PV technologies.
- `osm`: The OSM data, de-duplicated.
- `fit`: The FiT data.
- `machine_vision`: The machine vision data.

A field, `area`, is added to the `fit` table, containing an estimate of the area
of the solar panel(s) based on the declared net capacity.

The tables `osm`, `repd`, and `machine_vision` include a latitude and longitude
for each installation. An additional field `location` is added to these tables
containing these coordinates converted to a Postgis point.

The `repd` table has been restricted to those installations whose technology
type is “solar Photovoltaics” and whose development status is “Operational.”

## Primary keys for the uploaded data

### FiT: `row_id`

We presume each row of the FiT data denotes an individual installation. However,
there is no defined primary key for this dataset. To allow us to reference the
original rows later an index is added to the dataset between `raw` and
`processed`.

### REPD: `repd_id`

The source data contains a unique identifier, `Ref ID`, for each
installation. This field has been renamed to `repd_id` and used as the primary
key.

### OSM: `osm_id`

The OSM data has a unique identifier, `id`, for each row. This field has been
renamed `osm_id` and used as the primary key but note that it does not
necessarily represent a unique installation.

### Machine Vision: `mv_id`

We have added a row identifier, `mv_id`, to the pre-processed machine vision dataset.

# 2. Preliminary matching between OSM and REPD

The table `osm_repd_id_mapping(osm_id, repd_id)` maps OSM identifiers to REPD
identifiers.

The entries in the OSM dataset were tagged (in the original data) with zero
or more REPD identifiers. These are present in the field `repd_id_str` as a
semicolon-separated list. The script `match-osm-repd.sql` “un-nests” these
identifiers as a set of rows matched to the corresponding `osm_id`.

# 3. Deduplication of the OSM dataset

An OSM entry `objtype` can be one of `relation`, `way`, or `node`.  In the case
of a `relation`, there may be several other entries classified as `way` that are
actually the components of the `relation`, all of which refer to a single PV
installation. There may also be several `way`s that are part of the same
installation even though there is no unifying `relation`.

The script `dedup-osm.sql` identifies groups of objects in the OSM data that are
likely part of the same installation. An extra column, `master_osm_id` is added
to the `osm` table; this column contains a unique `osm_id` for each object in
a single cluster. (The particular `osm_id` used has no significance.)

## Using the `plantref` field

Some of the OSM objects have already been tagged as being part of the same
installation. These are indicated by an entry in the field `plantref` of the
form `way/123456789` where the digits indicate another `osm_id`. If this field
is non-`NULL`, the number is copied across to `osm_master_id`.

## Using proximity

The remainder of the script identifies pairs of installations that are within
300 metres of each other; it then extends this relation to an equivalence
relation and tags objects that are equivalent to each other with a common
`master_osm_id`. (In fact, the tag is the greatest `osm_id` from the group but
this choice is simply for convenience.)

### Technical note

The relation that contains parts of objects within 300m of each other is clearly
a symmetric relation but it is not necessarily transitive. (It may be the case
that A and B are within 300m of each other and B and C are within 300m of each
other but A is more than 300m from C.) To extend the proximity relation to an
equivalence relation we form the transitive closure of the proximity relation.

Taking the transitive closure is acheived in SQL through the use of a "recursive
common table expression" (recursive CTE). In the script, it is the query that
begins “`WITH RECURSIVE ...`”. The primary use of recursive CTEs is, in fact, to
compute transitive closures.


# 4. Deduplication of the REPD dataset

The REPD dataset also contains objects that are close enough in both proximity
and name that we believe they are likely to be part of the same installation.

Deduplication proceeds in a similar manner to the OSM database. We use a
slightly larger distance threshold (1380 m) but include a measure of similarity
between the installation names using Postgres' `similarity` function. In
addition, prior to computing the similarity of names, we “normalise” the names
to remove certain common words (such as “farm”).

As with the OSM data, a new field, `master_repd_id` is added to the `repd` table
that is non-`NULL` and unique for sites that are believed to be the same site.
