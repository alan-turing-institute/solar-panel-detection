% Matching

This note documents the matching of entities between the various datasets in the
`hut23-425` database.


# Match Rules:

## OSM-REPD

First, proximity match to get the nearest neighbouring REPD for every single OSM object,

1. The master REPD id of the REPD id in OSM, where this is < 500m from the nearest neighbour REPD object to an OSM object
2. The nearest neighbour in meters of OSM entries to REPD entries where the REPD ID is the same as that already present in OSM data. Accept those that are the same (regardless of distance). This should catch any that aren't covered by rule 0. (Implementation note: added rule 2.5 which comes after rule 2, implementing the same idea with a different proximity search. It re-runs the nearest neighbour search but only for matching REPD IDs rather than any REPD ID.)
3. Nearest neighbour for remaining OSM/REPD where the OSM `objtype` is `way` or `relation` and the object is a "group master" (the `osm_id = master_osm_id` or `repd_id = master_repd_id`). Accept all matches that are below a distance threshold of 700 meters.
4. Nearest REPD neighbour for OSM nodes, where REPD has "Scheme" in the title, with a distance threshold of 5KM.
5. Repeat 4, with no distance threshold

Repeat matching rules 1-5 for non-operational REPD entries. Label these match rules 1a, 2a etc.

## Machine Vision dataset

First, proximity match to get the nearest neighbouring OSM way/relation for every single Machine Vision object and separately, the nearest REPD for each Machine Vision Object.

6. Nearest neighbour REPD to each Machine Vision object, below a 1000m distance threshold.
7. Nearest neighbour OSM way/relation to each Machine Vision object, below a 1000m distance threshold.

# Matches

| Rule | Count | Total |
| ---  | ---   |  ---  |
|  1   |  825  |  825  |
|  2   |  0    |  825  |
|  3   |  88   |  913  |
|  4   |  1,192|  2,105|
|  5   |  68   |  2,173|
|  1a  |  2    |  2,175|
|  2a  |  0    |  2,175|
|  3a  |  46   |  2,221|
|  4a  |  893  |  3,114|
|  5a  |  0    |  3,114|
| ---- | ----- | ----- |
|  6   |  1,759|       |
|  7   |  1,851|       |

# Notes

Doesn't look like any of the nodes where nearest REPD is not a scheme are genuine matches. Many matches to "Goldthorpe" REPD, which made me think this could be a scheme. Unlikely though, because the operator is Aldi.

Rule 4/5 are intended to distinguish between those OSM nodes that are very likely to be part of a scheme and those that are slightly less likely.
