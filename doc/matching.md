% Matching

This note documents the matching of entities between the various datasets in the
`hut23-425` database.


# Match Rules:

1. The master REPD id of the REPD id in OSM, where this is < 500m from the nearest neighbour REPD object to an OSM object
2. The nearest neighbour in meters of OSM entries to REPD entries where the REPD ID is the same as that already present in OSM data. Accept those that are the same (regardless of distance). This should catch any that aren't covered by rule 0.
3. Nearest neighbour for remaining OSM/REPD where the OSM `objtype` is `way` or `relation` and the object is a "group master" (the `osm_id = master_osm_id` or `repd_id = master_repd_id`). Accept all matches that are below a distance threshold of 700 meters.
4. Nearest REPD neighbour for OSM nodes, where REPD has "Scheme" in the title, with a distance threshold of 5KM.
5. Repeat 4, with no distance threshold

Repeat matching rules 1-5 for non-operational REPD entries

# Matches

| Rule | Count | Total |
| ---  | ---   |
|  1   |  825  |  825  |
|  2   |  0    |  825  |
|  3   |  88   |  913  |
|  4   |  1,192|  2,105|
|  5   |  68   |  2,173|

# Notes

Doesn't look like any of the nodes where nearest REPD is not a scheme are genuine matches. Many matches to "Goldthorpe" REPD, which made me think this could be a scheme. Unlikely though, because the operator is Aldi.

Rule 4/5 are intended to distinguish between those OSM nodes that are very likely to be part of a scheme and those that are slightly less likely.
