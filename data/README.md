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

| Field | OpenStreetMap | FiT | REPD
|:---|:---:|:---:|:---:|
| Post code | :x: | :ballot_box_with_check: (First half only, all entries, also includes other address fields) | :ballot_box_with_check: (Full post code, not all entries, also includes other address fields)|
| Lat/Lon | ✅ | :x: | :x: |
| X/Y coords | :x: | :x: | ✅ |
| Area | :ballot_box_with_check: (calc_area, not all entries) | :x:| :x:|
| Capacity | :ballot_box_with_check: (calc_capacity, not all entries)| :ballot_box_with_check: (Multiple: Installed capacity, declared net capacity. All entries)| :ballot_box_with_check: (Installed Capacity (MWelec), all entries) |
|REPD id | :ballot_box_with_check: (tag_repd:id, ~900 for which this relevant) | :x: | ✅  (Ref ID)|
