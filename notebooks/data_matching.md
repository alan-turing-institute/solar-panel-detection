Data matching ideas
===================

REPD and OSM matching count table
--------

|  | Counts |
|---|---|
| OSM total | 126,939|
| REPD total | 5,686 |
|---|---|
| OSM without REPD id | 126,046|
| OSM with REPD id | 893|
| OSM with REPD id not in REPD | 1 (one of the OSM entries appears to have the repd_id `0`)|
| OSM with REPD id in REPD |892 |
|---|---|
| Unique REPD ids in OSM | 924 |
| REPD ids in OSM inc. duplicates | 932 |
| REPD with id not in OSM |4,762|

Latitude/Longitude coordinate matching
------

**Distances from OSM with REPD id to matching REPD:**

| | Distance (meters) |
|---|---|
| Min | 6|
| 1st Q. | 89|
| Med |251 |
| Mean | 747|
| 3rd Q. | 542|
| Max | 149,610|

| Query | Result |
|---|---|
| OSM total| 126,939|
| OSM with REPD id | 893 |
| OSM with REPD id with closest geographical match in REPD having that repd_id | |
| OSM with REPD id with closest geographical match in REPD having different repd_id | |
| OSM without REPD id within Xm of REPD installation | |
