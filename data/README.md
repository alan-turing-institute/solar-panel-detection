Data fields
========

Dan Stowell says:

A word about "primary keys": objects in OSM have identifiers and they're generally stable, though they're not guaranteed persistent (if a user deletes an object and then maps it again as a completely new object, there's not much we can do about that).

The FiT data contains no primary key at all. The REPD data does have unique identifiers (hooray!). For about 900 solar farms in OSM, we've added a tag "repd:id" which allows you to connect an OSM solar farm directly to its corresponding entry in REPD.

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
| Identifier|REPD id | **tag_repd:id** :ballot_box_with_check: (~900 for which this relevant) | :x: | **Ref ID** ✅|

British National Grid X/Y coordinates can be converted to latitude and longitude. Here is a [Python package](https://pypi.org/project/bng-latlon/) for that.

A few more examples that use info that Dan Stowell has calculated (see [compile_osm_solar.py](open-street-maps/solarpv-osm-uk-data-20191117/dan_stowell_osm_analysis/compile_osm_solar.py)) rather than OSM data fields:

| Field type | Field | OpenStreetMap | FiT | REPD
|---|---|:---:|:---:|:---:|
| Size| Area | **calc_area** :ballot_box_with_check: (not all entries) | :x:| :x:|
| Capacity| Capacity | **calc_capacity**:ballot_box_with_check: (not all entries)| **Installed capacity**, **Declared net capacity** ✅ (All entries)| **Installed Capacity (MWelec)** ✅ (All entries) |
