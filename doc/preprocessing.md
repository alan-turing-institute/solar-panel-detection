Manual pre-processing datasets
===========

These are the manual data transformations made to get the files in `data/raw` from `data/as_received`.

FiT
----

1. Combine the 3 spreadsheets into one
2. Remove rows above header
3. Convert to csv
4. Save as `data/raw/fit.csv`

OSM (csv)
----

Starting file: `compile_processed_PV_objects.csv`

These were the manual edits that we needed to fix typos in the uncontrolled OSM source data. Note there could be others in future OSM data releases:

1. Changed "6modifiable areal unit problem" to 6 for id=6844767626 in generator:solar:modules column.
2. Changed 14w to 14 for id=699666802 in generator:solar:modules column
3. Save as `data/raw/osm.csv`

REPD
----

No changes. Save as `data/raw/repd.csv`.

Machine vision dataset
-----

No changes. Save as `data/raw/machine_vision.geojson`.
