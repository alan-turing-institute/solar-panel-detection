% Matching

This note documents the matching of entities between the various datasets in the
`hut23-425` database.


# Match Rules:

1. The nearest neighbour in meters of OSM entries to REPD entries where the REPD ID is the same as that already present in OSM data. Accept those that are the same (regardless of distance).
2. Nearest neighbour for remaining OSM/REPD where the OSM `objtype` is `way` or `relation` and the object is a "group master" (the `osm_id = master_osm_id` or `repd_id = master_repd_id`). Accept all matches that are below a distance threshold and don't exceed a capacity difference of X.

# Matches

| Rule | Count |
| ---  | ---   |
|  1   |  880  |
