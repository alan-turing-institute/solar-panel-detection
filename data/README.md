Data fields
========

Dan Stowell says:

A word about "primary keys": objects in OSM have identifiers and they're generally stable, though they're not guaranteed persistent (if a user deletes an object and then maps it again as a completely new object, there's not much we can do about that).

The FiT data contains no primary key at all. The REPD data does have unique identifiers. For about 900 solar farms in OSM, we've added a tag "repd:id" which allows you to connect an OSM solar farm directly to its corresponding entry in REPD.

| Icon | Meaning |
| ---  | --- |
| :x:  | Data doesn't have this field |
| :ballot_box_with_check: | Data has this field, with caveats |
| ✅ | Data has this field |
|**Bold text** | Actual name of field in data |

| Field type | Field | OpenStreetMap | FiT | REPD
|---|---|:---:|:---:|:---:|
| Location | Post code | :x: | **Postcode**:ballot_box_with_check: (First half only, all entries, also includes other address fields) | **Post Code** :ballot_box_with_check: (Full post code, not all entries, also includes other address fields)|
| Location | Latitude and Longitude | **lat**, **lon** ✅ | :x: | :x: |
| Location| X/Y coords (BNG)| :x: | :x: | **X-coordinate**, **Y-coordinate** ✅ |
| Location | LLSOA (Lower Layer Super Output Area) | :x: | **LLSOA code** ✅ | :x: |
| Identifier|REPD id | **tag_repd:id** :ballot_box_with_check: (~900 for which this relevant) | :x: | **Ref ID** ✅|
| FiT tariff info | Various | :x: | :ballot_box_with_check: **Tariff code**, **Tariff description**| :ballot_box_with_check: **FiT Tariff (p/kWh)**

British National Grid X/Y coordinates can be converted to latitude and longitude. Here is a [Python package](https://pypi.org/project/bng-latlon/) for that.

Doesn't look easily possible to match on tariff info.

A few more examples that use info that Dan Stowell has calculated (see [compile_osm_solar.py](open-street-maps/solarpv-osm-uk-data-20191117/dan_stowell_osm_analysis/compile_osm_solar.py)) rather than OSM data fields:

| Field type | Field | OpenStreetMap | FiT | REPD
|---|---|:---:|:---:|:---:|
| Size| Area | **calc_area** :ballot_box_with_check: (not all entries) | :x:| :x:|
| Capacity| Capacity | **calc_capacity**:ballot_box_with_check: (not all entries)| **Installed capacity**, **Declared net capacity** ✅ (All entries)| **Installed Capacity (MWelec)** ✅ (All entries) |


Example Matches (found manually)
---------

| OpenStreetMap | FiT | REPD |
|:---:|:---:|:---:|
| ✅ **id** = 9537182, **plantref** = relation/9537182, **tag_repd:id** = 6132 | :x: Filtering part 2 of the report spreadsheet by **Postcode** = UB2 and **Local authority** = Hounslow gives 22 results | ✅**Ref ID** = 6132 |
| ✅ **id** = 684035481, **plantref** = way/684035481, **tag_repd:id** = 2143, **calc_capacity** = 18,800| :ballot_box_with_check: Possible match - Row 73582 (feed-in_tariff_installation_report_30_september_2019_-_part_1.xlsx) **Installed capacity** = 18, **Postcode** = CO4| ✅ **Ref ID** = 2143, **Installed Capacity (MWelec)** = 18.8, **Post Code** = CO4 5NW|

| |  | I | II | III | IV | V |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| **OSM** | id | 9537182 | 684035481| | | |
|  | plant:output:electricity |  | 18.8 MW| | | |
|  | repd:id  | 6132 |2143 | | | |
| OSM derived | lat |  | 51.935457| | | |
| | lon |  |0.93541 | | | |
| **REPD** | Ref ID  | 6132 | 2143| | | |
|  | Installed Capacity (MWelec)  |  | 18.8| | | |
|  | X-coordinate  |  |601,454 | | | |
|  | Y-coordinate  |  |231,228 | | | |
| REPD derived | lat  |  | 51.943065| | | |
| | lon  |  |0.929579 | | | |
| **FiT**|   |  | | | | |
