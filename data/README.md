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
| **OSM** | id | 9537182 | 684035481| 10304120| 10305610|10298564 |
|  | plant:output:electricity | 1.7 MW | 18.8 MW| 3.5 MW| 1 MW| 5 MW|
|  | repd:id  | 6132 |2143 |5207 |1994 | 5834|
| | timestamp | 2019-05-02T20:52:30Z |2019-05-03T21:41:29Z |2019-11-16T14:03:13Z | 2019-11-16T21:30:41Z| 2019-11-14T22:35:13Z|
|  | lat | 51.496088 | 51.935457| 51.558094|52.019079 | 52.89991|
| | lon | -0.407339 |0.93541 | -2.655681| -0.011644|-3.015247 |
| **REPD** | Ref ID  | 6132 | 2143| 5207| 1994| 5834|
|  | Installed Capacity (MWelec)  | 1.7 | 18.8| 3.5| 1| 5|
|  | Post Code | UB2 5XU | CO4 5NW| BS35 4NL| SG8 8AZ| :x:|
|  | Planning Application Submitted | 28/07/2015|16/06/2014	 |13/04/2015 |24/11/2013 | 23/09/2015|
|  | Planning Permission Granted | 14/09/2015 |15/09/2014 | 01/09/2015| 03/12/2013| 23/12/2015|
|  | Under Construction | 19/04/2016 |26/11/2014 | 28/02/2015| :x:| 12/12/2016|
|  | Operational |19/05/2016 | 19/03/2015 | 31/03/2016| 08/03/2014| 15/02/2017|
|  | Record Last Updated (dd/mm/yyyy) | 31/05/2016 |14/08/2015 |17/06/2016 | 26/08/2014| 04/12/2017|
|  | FiT Tariff (p/kWh) | :x: |1.4 |:x: | :x:| :x:|
|  | Address | Western International Market, Hayes Road, Southall, London |Langham, Colchester | Land adjacent to Church Road and the M49, Severn Beach, Bristol| Hatchpen Farm, Reed, Royston|Land At, Rhosygadfa, Gobowen, Oswestry |
|  | X-coordinate  | 510,606 |601,454 | 354,510| 536,397|331,810 |
|  | Y-coordinate  | 178,655 |231,228 | 184,911| 237,730|334,117 |
| REPD derived | lat  | 51.496026 | 51.943065| 51.561233|52.02123 | 52.900149|
| | lon  | -0.408078 |0.929579 | -2.657613| -0.013603|-3.01518 |
| **FiT**| Installed capacity  |  | 18| | | |
| | Declared net capacity  |  | 18| | | |
| | Postcode  |  | CO4| | | |
| | Constituency | | Colchester | | | |
| | Application date | | 07/09/2015| | | |
| | Commissioning date  |  | 27/07/2015| | | |
| | Tariff code |  | PV/10-50/06H-1| | | |
| | Tariff description |  | PV (>10Âª50kW)-2015/16 - Degression - H| | | |
| | Installation type | | Non Domestic (Commercial)| |
| | LLSOA code | | E01021668 | | | |
