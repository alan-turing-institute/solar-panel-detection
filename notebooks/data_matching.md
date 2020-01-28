Data matching ideas
===================

REPD and OSM matching
--------

**Notes:**

1. "Location" OSM field probably shouldn't be "roof" for REPD installations (these are large solar farms)
2. Consider OSM object types: https://wiki.openstreetmap.org/wiki/Elements - perhaps may geographical matches will result from "nodes" that are not currently tagged with an REPD id but the equivalent "way" or "relation" does already have the REPD id

|  | Counts |
|---|---|
| OSM total | 126,939|
| REPD total | 5,686 |
|---|---|
| OSM without REPD id | 126,046|
| OSM with REPD id | 893|
| OSM with REPD id and objtype = node | 0|
| OSM with REPD id and objtype = way | 727|
| OSM with REPD id and objtype = relation | 166|
| REPD ids present in OSM `**` | 933 |
| OSM with REPD id not in REPD | 1 (one of the OSM entries appears to have the repd_id `0`)|
| OSM with REPD id in REPD |892 |
|---|---|
| Unique REPD ids in OSM | 924 |
| REPD ids in OSM inc. duplicates | 932 |
| REPD with id not in OSM |4,762|

- `*` OSM object types: https://wiki.openstreetmap.org/wiki/Elements
- `**` including those within the same OSM entry and any that are not genuine REPD ids (found in REPD)

### Latitude/Longitude coordinate matching

**Distances from OSM with REPD id to matching REPD:**

| | Distance (meters) |
|---|---|
| Min | 6|
| 1st Q. | 89|
| Med |251 |
| Mean | 747|
| 3rd Q. | 542|
| Max | 149,610|

**Stats on REPD tagged OSM records:**

|  | Counts |
|---|---|
| OSM with REPD id with closest geographical match in REPD having that repd_id | 765|
| OSM with REPD id with closest geographical match in REPD being co-located repd_id | 3|
| OSM with REPD id with closest geographical match in REPD being non-matching/ non-co-located| 165|

**Matching results:**

| Match rule | Result |
|---|---|
| 1a  | 3982 |
| 1b  | 442 |
| 1c  | 3425 |
| 1d  | 115  |

1. **Match Rule 1a:** If a geo match is closer than 250m and that OSM entry not already tagged with REPD id
  - **Match Rule 1b:** 1a and OSM objtype = "node"
  - **Match Rule 1c:** 1a and OSM objtype = "way"
  - **Match Rule 1d:** 1b and OSM objtype = "relation"
2. **Match Rule 2:** If a geo match is closer than 250m and that OSM entry not already tagged with REPD id and second closest > 1000m
