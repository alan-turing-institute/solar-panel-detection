Data matching ideas
===================

REPD and OSM matching
--------

**Notes:**

1. "Location" OSM field probably shouldn't be "roof" for REPD installations (these are large solar farms)
2. Consider OSM object types: https://wiki.openstreetmap.org/wiki/Elements - perhaps may geographical matches will result from "nodes" that are not currently tagged with an REPD id but the equivalent "way" or "relation" does already have the REPD id
3. Dan Stowell has already done some work to combine OSM entries from the same solar plant with the "plantref" column, however it may not be useful to use this for matching if we ultimately want to use OSM data directly, rather than Dan's processing csv. Could be useful for validation purposes? (see data/as_received/solarpv-osm-uk-data-2019-11-17/dan_stowell_analysis/compile_osm_solar.py)
4. Since REPD contains things other than Solar panels, be sure to filter on Technology Type = Solar Photovoltaics

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
| 1a  | 3155 |
| 1b  | 158 |
| 1c  | 2979 |
| 1d  | 18  |
| 2   | 15  |

1. **Match Rule 1a:** If a geo match is closer than 250m and that OSM entry not already tagged with REPD id
  - **Match Rule 1b:** 1a and OSM objtype = "node"
  - **Match Rule 1c:** 1a and OSM objtype = "way"
  - **Match Rule 1d:** 1b and OSM objtype = "relation"
2. **Match Rule 2:** Match rule 1 + OSM tag_power = "plant" (ignores most matches found by rule 1)

**Example matches that appear correct:**

| Match rule | REPD Site Name| REPD id  | OSM id | OSM objtype |OSM "plantref" |OSM "tag_power"| Notes | Novel match find |
|---|---|---|---|---|---|---|---|---|
| 1a/b|Walton WTW PV|2388|2189625035|node|:x:|generator|See notes below 1.|:x:|
| 1a/b|John Lennon Airport Scheme|6750|6601390246 (and many other clustered nodes)|node|:x:|generator|See notes below 2.|✅|
|1a/c|Marchington Solar Farm|2036|746116910 to 746116917|way|:x:|generator|Checked with OSM (solar data instance) and gmaps|✅|
| 1a/d | Bumpers Farm Phase 1 | 2186|4483073|relation|relation/4476342|generator|The OSM id 4476342 (tag_power=plant) does already have the same REPD id tagged. |:x:|
| 2  |Crannaford Solar Farm|1984|290068926|way|way/290068926|plant|See notes below 3.|✅|

**Example match notes:**

These refer to the table above.

1. There is an REPD tagged "way" that has a 2nd associated "way" without the REPD id. Both of these have many associated "node"s, which are already filtered out from the data loaded from Dan Stowell's processed csv (present in xml). However, looking at OSM (solar data instance) this particular "node"  appears to be located separately from the "way"s, but within Walton WTW. They have the same capacity, but different timestamp (7 year diff), which suggests some de-duplication of the OSM data may be required.
2. Seems like this one wasn't picked up by OSM editors as a likely REPD because it is not a solar farm, rather a collection of rooftop solar panels. Makes sense that these are all under "John Lennon Airport Scheme" and therefore are what this REPD id refers to. They are in an estate(s) near the airport and there is no alternative solar farm to which the REPD entry could refer nearby on the OSM map.
3. This also has the name of the farm already in OSM (but not the OSM csv), which looks like another field that can easily be used to match between OSM and REPD, it just isn't present for most OSM (but is for ~500). Note, it's very close to 2 other farms (but perhaps >250m away). There are nearby points in OSM that form part of the farm, linked by Dan's "plantref" attribute. This result, plus the one for Marchington solar farm, suggests we can use "plantref" to add repd_id to linked OSM entries, but that not all tag_power=plant OSM entries already have an repd_id.
