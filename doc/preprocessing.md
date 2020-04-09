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

1. Changed scientific notation numbers to decimals
2. Changed "6modifiable areal unit problem" to 6 for id=6844767626 in generator:solar:modules column. Similarly edited id=6844935727 and id=6844935728
3. Changed "roofhttp://www.alpenverein.at/bk/bergauf/bergauf2019/Bergauf_4_2019/" to "roof" in location column for 100 rows
4. Changed 14w to 14 for id=699666802 in generator:solar:modules column
5. Save as `data/raw/osm.csv`

REPD
----

No changes. Save as `data/raw/repd.csv`.

Machine vision dataset
-----

No changes. Save as `data/raw/machine_vision.geojson`.
