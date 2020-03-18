% Matching

This note documents the matching of entities between the various datasets in the
`hut23-425` database.


# Match Rules:

1. The master REPD id of the REPD id in OSM, where this is < 500m from the nearest neighbour REPD object to an OSM object
2. The nearest neighbour in meters of OSM entries to REPD entries where the REPD ID is the same as that already present in OSM data. Accept those that are the same (regardless of distance). This should catch any that aren't covered by rule 0.
3. Nearest neighbour for remaining OSM/REPD where the OSM `objtype` is `way` or `relation` and the object is a "group master" (the `osm_id = master_osm_id` or `repd_id = master_repd_id`). Accept all matches that are below a distance threshold of 700 meters.
4. Nearest REPD neighbour for OSM nodes, where REPD has "Scheme" in the title, with a distance threshold of 5KM.
5. Nearest neighbour for remaining OSM nodes and REPD's that don't have "Scheme" in title (not just group masters), with a very low distance threshold.
8. Repeat 4, with no distance threshold
7. Repeat matching rules 0-4 for non-operational REPD entries

# Matches

| Rule | Count | Total |
| ---  | ---   |
|  1   |  876  |  876  |
|  2   |  0    |  876  |
|  3   |  89   |  965  |
|  4   |  1,233|  2,198|
