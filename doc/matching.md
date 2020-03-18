% Matching

This note documents the matching of entities between the various datasets in the
`hut23-425` database.


# Match Rules:

1. The master REPD id of the REPD id in OSM, where this is < 500m from the nearest neighbour REPD object to an OSM object
2. The nearest neighbour in meters of OSM entries to REPD entries where the REPD ID is the same as that already present in OSM data. Accept those that are the same (regardless of distance). This should catch any that aren't covered by rule 0.
3. Nearest neighbour for remaining OSM/REPD where the OSM `objtype` is `way` or `relation` and the object is a "group master" (the `osm_id = master_osm_id` or `repd_id = master_repd_id`). Accept all matches that are below a distance threshold of 700 meters.
4. Nearest neighbour for OSM nodes, for REPD's with "Scheme" in the title, with a high distance threshold.
5. Nearest neighbour for remaining nodes and REPD's (not just group masters), with a very low distance threshold.
6. Repeat matching rules 0-4 for non-operational REPD entries

# Matches

| Rule | Count | Total |
| ---  | ---   |
|  1   |  876  |  876  |
|  2   |  0    |  876  |
|  3   |  89   |  965  |
