Data matching first (v0.1) round
===================

REPD and OSM matching
--------

**Notes:**

1. "location" OSM field shouldn't be "roof" for REPD installations (these are large solar farms). All those with a current REPD tag have "location" of "ground" or "surface".
2. Consider OSM object types: https://wiki.openstreetmap.org/wiki/Elements - perhaps may geographical matches will result from "nodes" that are not currently tagged with an REPD id but the equivalent "way" or "relation" does already have the REPD id
3. Dan Stowell has already done some work to combine OSM entries from the same solar plant with the "plantref" column, however it may not be useful to use this for matching if we ultimately want to use OSM data directly, rather than Dan's processing csv. Could be useful for validation purposes? (see data/as_received/solarpv-osm-uk-data-2019-11-17/dan_stowell_analysis/compile_osm_solar.py)
4. Since REPD contains things other than Solar panels, be sure to filter on Technology Type = Solar Photovoltaics
5. Looks like most of the OSM entries with "capacity" are those taken directly from REPD (already have a tagged REPD id), so not sure how useful capacity will be for matching

|                                              |                                                     Counts |
|----------------------------------------------+------------------------------------------------------------|
| OSM total                                    |                                                    126,939 |
| REPD total                                   |                                                      5,686 |
| REPD tech_type = 'Solar Photovoltaics'       |                                                      1,986 |
| ^ of which operational date not blank        |                                                      1,147 |
|----------------------------------------------+------------------------------------------------------------|
| OSM without REPD id                          |                                                    126,046 |
| OSM with REPD id                             |                                                        893 |
| OSM with REPD id and objtype = node `*`      |                                                          0 |
| OSM with REPD id and objtype = way `*`       |                                                        727 |
| OSM with REPD id and objtype = relation `*`  |                                                        166 |
| REPD ids present in OSM `**`                 |                                                        933 |
| OSM with REPD id not in REPD                 | 1 (one of the OSM entries appears to have the repd_id `0`) |
| OSM with REPD id in REPD                     |                                                        892 |
|----------------------------------------------+------------------------------------------------------------|
| Unique REPD ids in OSM                       |                                                        924 |
| REPD ids in OSM inc. duplicates              |                                                        932 |
| REPD with id not in OSM                      |                                                      4,762 |
|----------------------------------------------+------------------------------------------------------------|
| OSM with recorded capacity                   |                                                       1116 |
| OSM with recorded capacity and REPD id       |                                                        872 |
| OSM with recorded capacity without REPD id   |                                                        244 |
|----------------------------------------------+------------------------------------------------------------|
| OSM with REPD id and location = 'roof'       |                                                          0 |
| OSM with REPD id and location = 'ground'     |                                                         22 |
| OSM with REPD id and location = 'surface'    |                                                          9 |
|----------------------------------------------+------------------------------------------------------------|
| OSM with "plantref"                          |                                                      7,056 |
| OSM with "plantref" and REPD id              |                                                        845 |
| OSM with "plantref" and no REPD id           |                                                      6,211 |
|----------------------------------------------+------------------------------------------------------------|
| OSM with tag_power = 'plant'                 |                                                        917 |
| OSM with tag_power = 'generator'             |                                                    126,022 |
| OSM with tag_power = 'plant' and REPD id     |                                                        837 |
| OSM with tag_power = 'generator' and REPD id |                                                         56 |

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
| OSM with REPD id with closest geographical match in REPD having that repd_id | 760|
| OSM with REPD id with closest geographical match in REPD being co-located repd_id | 3|
| OSM with REPD id with closest geographical match in REPD being non-matching/ non-co-located| 162|

**Matching results:**

| Match rule | Result |
|---|---|
| 0   | 3,655 |
| 1a  | 3,155 |
| 1b  | 158 |
| 1c  | 2,979 |
| 1d  | 18  |
| 2   | 15  |
| 3a   | 110 |
|3b    | 50  |
|4     | 6,281|
|5a     | 5,231|
|5b    |224|
|5c    |189|
|6    | 5,675|
|7   | 4,389|
|8   | 139|

0. **Match Rule 0:** If the closest REPD point to an OSM point is <250m away
1. **Match Rule 1a:** If the closest REPD point to an OSM point is <250m away and that OSM entry not already tagged with REPD id
  - **Match Rule 1b:** 1a and OSM objtype = "node"
  - **Match Rule 1c:** 1a and OSM objtype = "way"
  - **Match Rule 1d:** 1b and OSM objtype = "relation"
2. **Match Rule 2:** Match rule 1 + OSM tag_power = "plant" (ignores most matches found by rule 1)
3. **Match Rule 3a:** If the closest REPD point to an OSM point is closer than REPD id already tagged for that OSM.
  - **Match Rule 3b:** 3a but only those where closest REPD point is <250m
4. **Match Rule 4:** If the closest REPD point to an OSM point is <500m away
5. **Match Rule 5a:** Match rule 4 + filter by location is either "ground", "surface" or not labeled (note, this ignores matches like John Lennon Airport, see below)
  - **Match Rule 5b:** 5a, but only those where "plantref" isn't already filled in
  - **Match Rule 5c:** 5b, but only the novel matches (those where the closest REPD point is not already correctly tagged as the REPD id for that OSM)
6. **Match Rule 6:** Match rule 4, but only the novel matches (those where the closest REPD point is not already correctly tagged as the REPD id for that OSM)
7. **Match Rule 7:** Match rule 6, but also removing those where the OSM linked by "plantref" (the master way or relation) has the correct REPD id already.
8. **Match Rule 8:** Match rule 6, but only those that have a plantref master OSM id that is their own OSM id (these are effectively the OSM with incorrectly tagged REPD id)

**Example matches that appear correct:**

| Match rule | REPD Site Name| REPD id  | OSM id | OSM objtype |OSM "plantref" |OSM "tag_power"| Notes | Novel match find |
|---|---|---|---|---|---|---|---|---|
| 1a/b|Walton WTW PV|2388|2189625035|node|:x:|generator|See notes below 1.|:x:|
| 1a/b|John Lennon Airport Scheme|6750|6601390246 (and many other clustered nodes)|node|:x:|generator|See notes below 2.|✅|
|1a/c|Marchington Solar Farm|2036|746116910 to 746116917|way|:x:|generator|Checked with OSM (solar data instance) and gmaps|✅|
| 1a/d | Bumpers Farm Phase 1 | 2186|4483073|relation|relation/4476342|generator|The OSM id 4476342 (tag_power=plant) does already have the same REPD id tagged. |:x:|
| 2  |Crannaford Solar Farm|1984|290068926|way|way/290068926|plant|See notes below 3.|✅|
| 2  |Bishop's Waltham Solar Farm | 1325| 10221632|relation|relation/10221632|plant|There are 15 entries, including this one, in the OSM XML that have k="site" v="solar_farm"|✅|

**Example match notes:**

These refer to the table above.

1. There is an REPD tagged "way" that has a 2nd associated "way" without the REPD id. Both of these have many associated "node"s, which are already filtered out from the data loaded from Dan Stowell's processed csv (present in xml). However, looking at OSM (solar data instance) this particular "node"  appears to be located separately from the "way"s, but within Walton WTW. They have the same capacity, but different timestamp (7 year diff), which suggests some de-duplication of the OSM data may be required.
2. Seems like this one wasn't picked up by OSM editors as a likely REPD because it is not a solar farm, rather a collection of rooftop solar panels. Makes sense that these are all under "John Lennon Airport Scheme" and therefore are what this REPD id refers to. They are in an estate(s) near the airport and there is no alternative solar farm to which the REPD entry could refer nearby on the OSM map.
3. This also has the name of the farm already in OSM (but not the OSM csv), which looks like another field that can easily be used to match between OSM and REPD, it just isn't present for most OSM (but is for ~500). Note, it's very close to 2 other farms (but perhaps >250m away). There are nearby points in OSM that form part of the farm, linked by Dan's "plantref" attribute. This result, plus the one for Marchington solar farm, suggests we can use "plantref" to add repd_id to linked OSM entries, but that not all tag_power=plant OSM entries already have an repd_id.

| Match rule | REPD Site Name| REPD id  |REPD id in OSM| OSM id | Distance (m) OSM to matched REPD |Distance (m) OSM to tagged REPD | Notes | Novel match find |
|---|---|---|---|---|---|---|---|---|
|3a| Building ONE (Science museum group)/ Wroughton Airfield Solar Park|7252|1735|455150879|||What looks to be the case here is that 2 adjacent installments are tagged as being the same thing in OSM|:x:|
|3a/b| Bronwylfa Reservoir|1520|4734|722350032|||The tagged REPD id clearly a mistake and looking at OSM map the macthed REPD is correct|✅|
|3a|Newton Margate/Margate Solar Farm|5079|4878|746155615|311|398|See 1. below|?|

1. Looking at OSM, there is only one farm in the vicinity, so perhaps the other is missing. Unclear whether to trust the tagged REPD id in this instance. Doesn't look to be a duplicate in REPD because capacity (1.5 and 3 MWelec) and postcode (PL31 1HF and PL31 1HE) vary. No point filtering on capacity if the capacity in OSM comes from REPD.

| Match rule | REPD Site Name| REPD id  | OSM id | Distance (m) OSM to matched REPD |OSM capacity (MW)|REPD capacity (MW)| OSM location | OSM plantref |Notes | Correct |
|---|---|---|---|---|---|---|---|---|---|---|
|4 (and 5b) |Crossness Sewage Works PV|2385|2189686633|493|1.5|1.5|||Validated looking at OSM XML: <tag k="description" v="Large solar PV array at Crossness Sewage Works"/> |✅|
|4  |Ernesettle Solar Farm|5395|6767581041|499||5 |roof||Looking at OSM map, there is an estate with many rooftop solar panels, of which this is one, close to the solar farm|:x:|
| 5a | Grange Farm Solar Farm | 2120 | 634025632 |500||4.9||way/550883524|Checked with OSM map. The OSM with id=550883524 has the correct REPD id already.|✅|
| 5b | Lower Easton Farm | 1849 | 701370103 |496||13.5|||Checked with OSM map.|✅|

TODO: Can we add an SQL query that gets the repd_id for the OSM id of the plantref? This can be represented in the osm_repd_id of the match result, so we can see ignore those where the REPD id is already found.

Matching first (v0.1) round Conclusions
=======================

For a first attempt at proximity matching OSM data entries to REPD (via distance between lat/lon coordinate points), I've simply taken the closest match in meters for all REPD-OSM, excluding those beyond a threshold (e.g. 250m, 500m). At first glance this appears to work very well; I struggled to find example matches by checking manually in OSM or gmaps that looked wrong. It has however revealed several important features of the data, relevant to the ultimate goal of creating a dataset with one entry per solar PV installation:

1. Currently in the OSM solar dataset, there is a lack of consistency in how solar farms are represented. With some having a "relation" and others having a "way" that other "way"s and "node"s (in OSM terminology) are related to. In some cases, the relation id in the OSM data already links all OSM objects that are part of the same farm/plant, and in others, Dan has already (via Python script) linked objects via the OSM id of one of the farm objects. The distance matching did reveal cases where additional OSM objects (those not already linked to a master "relation" or "way" of a solar farm) matched to an REPD id, but by manually checking the OSM instance we have set up with the solar data, these additional objects appear to be part of the same solar farm. So I need to put some thought into how best to further de-duplicate the OSM data, to reduce false positives in proximity matching to REPD.
2. It was tempting when matching to REPD to rule out OSM "node" objects, since all of the OSM data already labeled with an REPD id are a "way" or "relation" and also to rule out objects where the location is designated "roof", since all the current labeled ones are "ground" or "surface". The proximity matching has revealed one interesting case that shows we can't be this strict. A large number of rooftop solar panels are present on an estate next to John Lennon Airport, which are <500m from the geolocation of "John Lennon Airport Scheme" in REPD. Looking at OSM, there are no solar farms nearby and the fact that it's a scheme suggests this is a correct match. A quick look through the REPD site names reveals there are a lot containing the word "Scheme", suggesting this is not an edge case. I need to think further how best to factor this in to proximity matching and how to infer the boundaries for areas of clustered "node"s that represent a single REPD entry (and not miss those at the edge of these areas or include those that are external). The capacity value in REPD will presumably apply to the cluster of solar panels taken as a whole.
3. There are some cases I've found where REPD farms are in close proximity and so distance matching alone won't guarantee that an OSM entry gets matched to the correct one. So a next step could be to filter these ambiguous cases by installation date or other data fields from REPD/OSM. I'm not certain filtering on capacity will be helpful since most of the OSM entries with a capacity value are likely to have been taken from OSM directly (of 1,116 OSM entries with recorded capacity, 872 also had an REPD id).

Data matching round 2 (v1.0)
=======================================

OSM solar farm De-duplication
----

It's difficult to assess at this stage how many of the 5,686 REPD farms are already represented in OSM, but after de-duplication of the OSM entries belonging to the same farms and subsequent matching attempts to REPD, we should then be able to also tell which (if any) REPD entries are missing from OSM entirely.

1. Remove any where the `plantref` is not its own OSM id to deduplicate - DONE
2. Do geo matching within OSM to find ones that are super close and check them out manually - DONE
3. De-duplicate on geography as necessary
    - Ignore nodes, because these are not farms
    - Ignore rooftop installations - also not farms
    - Only worry about those not already de-duplicated with `plantref`
    - Of the objects in the list satisfying these 3 conditions, filter those with closest object from same list within Xm and check manually that they are part of the same thing and then update their master_osm_id in `osm` table and remove all but one in `osm`.
    - Also need to make sure that any capacity or area for these objects is summed (NOTE: realistically this is not easy to do and we are not likely to use capacity for farm matching to REPD)
4. Check that no information is lost when we remove Solar farm objects that have a different OSM id to that of their plantref

|  | OSM Counts|Notes|
|---|---|---|
| Total no de-duplication| 126,939||
| Not located on roof and not objtype "node"| 826 ||
| Deduplication 1) minus those with a "plantref" id that is not the same as its OSM id (links to another)|120,800 ||
| Not located on roof and not objtype "node" and not already de-duplicated| 117 ||
| ^ + has another object of this kind within 2,000m | 85 |Manually checked the 5 (85-80) and they are not the same farm|
| ^ + has another object of this kind within 300m | 80 |Manually checking some of the furthest ones and they are part of the same large farm|
| Deduplication 2) Distance based | ||
|---|---|---|
|**After Deduplication**|||
| Total with recorded tag_start_date | 46 ||
| Total with recorded tag_start_date and REPD id| 12 ||
| Total with recorded tag_start_date without REPD id| 34 ||
| Total with recorded capacity |1,102 ||
| Total with recorded capacity and REPD id |868 ||
| Total with recorded capacity without REPD id | 234||

Stats for Matching
-----

| |Count|Notes|
|---|---|---|
|REPD entries with "Scheme" in title | 5| |
| FiT with installation type = "Domestic" | 824,989| |
| FiT with installation type = "Community" | 3,360| |
| FiT with installation type = "Non Domestic (Commercial)" | 32,658| |
| FiT with installation type = "Non Domestic (Industrial)" | 2,072| |

Match rule ideas
-------

### OSM-REPD

**Ideal matching rules:**

After each match rule: Remove all members of these REPD groups from the REPD table (or a copy of it) and same for OSM, before continuing matching. Add the REPD and OSM id to the match table plus the match rule (e.g. int of 1) to the match rule column.

1. The nearest neighbour in meters of OSM ways/relations to REPD entries where the REPD ID is the same as already tagged in OSM data. Accept those that are the same (regardless of distance).
2. Nearest neighbour for remaining ways/relation group masters (master_osm_id and master_repd_id). Accept all matches that are below a distance threshold and don't exceed a capacity difference of X.
3. Nearest neighbour for nodes, and REPD's with "Scheme" in the title, with a high distance threshold.
4. Nearest neighbour for remaining nodes and REPD's (not just group masters), with a very low distance threshold.

**Sanity checking:**

1. Work out how to infer the boundaries for clustered node installations like John Lennon Airport Scheme (match nodes separately). See how many more you get by increasing the range around the REPD coordinates and look at other examples if there are any, then devise rule. Only 5 "schemes".
2. Check OSM `tag_start_date` against REPD `operational`. Only 46 have these filled but "Crannaford Solar Farm" shows that these can match even when not taken from REPD (this is a known distance match, see above) and at the "Trickey Warren" REPD for instance, could we use this field to differentiate from neighbouring solar farms?
2. Could postcode could be used as a sanity check for distance matching? This would require some kind of rough conversion of postcode to geolocation? This may be possible with PostGIS?
3. Validate that matches roughly match on area by comparing OSM area to REPD area calculated roughly from capacity

### OSM-MV and REPD-MV

1. Proximity match OSM-MV
2. Proximity match REPD-MV

**Notes:**

Machine vision dataset is apparently only solar farms. It also was trained using the OSM data!! But then the algorithm searches satellite images. Weird that only ~2,000 in this dataset.

### OSM-FiT

1. For ways in OSM, match to FiT based on area, which can be roughly calculated from capacity.
2. Get rough area of installations using Postcode and LLSOA with GIS if possible and use this for proximity filtering: https://postgis.net/docs/Geocode.html

OSM-REPD distance matching continued
--------

**Stats on REPD tagged OSM records:**

|  | Counts |
|---|---|
| OSM with REPD id with closest geographical match in REPD having that repd_id | 760|
| OSM with REPD id with closest geographical match in REPD being co-located repd_id | 3|
| OSM with REPD id with closest geographical match in REPD being non-matching/ non-co-located| 162|

**Matching results:**

WARNING: These match results will have multiple rows for some OSM ids where there was multiple REPDs already tagged in OSM. Think of them as OSM-REPD associations.

| Match rule | Result |
|---|---|
| 9a  | 98 |
| 9b   | 59|
| 10a  | 602 |
| 10b  | 374 |
| 10c | 298 |
| 11 | 866 |

### Before REPD/OSM de-duplicated

1. **Match Rule 9a:** If the closest REPD point to an OSM point is <500m away and the OSM record already has an REPD id tagged which is different
    - **Match Rule 9b:** 9a but only the REPD that are operational
2. **Match Rule 10a:** If the closest REPD point to an OSM **way or relation** is <500m away and matched REPD was already correctly tagged in OSM
    - **Match Rule 10b:** 10a but where the REPD id in OSM was different or non-existent (9a + non-existent)
    - **Match Rule 10c:** 10b but only the REPD that are operational (9b + non-existent)

### After REPD/OSM de-duplicated

3. **Match Rule 11:** If closest REPD point to an OSM point is that which is already tagged or the co-repd-id of the match, or the master_repd_id (see results, all are ways and relations).
3. **Match Rule 12:** If the closest REPD point to an OSM **node** is <500m away, excluding REPD with "Scheme" in the title
4. **Match Rule 13:** If the closest REPD *scheme* to an OSM **node** is <500m away
    - Try this with a wider area (e.g. 2000m)
5. **Match Rule 14:** If the closest REPD *scheme* to an OSM **relation or way** is <500m away

| Match rule | REPD Site Name|REPD id|REPD Site Name in OSM|REPD id in OSM| OSM id |Distance (m)| Notes | Novel match find |
|---|---|---|---|---|---|---|---|---|
| 9 | Helland Meads |1224 |Helland Meads - resubmission |2164|717941405 | 173 |There are quite a few other resubmissions like this, suggesting we need to de-duplicate REPD| :x: |
| 9 | Court Farm (Frome)|2316|West Woodlands|4889|7877228|384|On closer inspection, these two REPD have the exact same coordinates, so perhaps also duplicates? Perhaps we need to deduplicate those with exact coordinates?| ? |
| 9 | Christchurch Energy|2308|Waterditch Solar Farm|5315|684035422|198|Same as above, this time coordinates are not exact match between 2 REPDs, but looking at OSM, they are clearly referring to same farm| ? |

Match rule 9 clearly shows the need for de-duplication of REPD is needed before we can proceed with matching to OSM. Not doing so will affect the matching of OSM objects that aren't already tagged with an REPD id as well as those that are already.

Match rule 10b: come back to this after REPD de-duplication done and also check against master/group id. The only other things to consider are whether to filter on capacity and whether to increase the distance threshold.

Match rule 11 shows that of the correctly tagged REPD in OSM, some are up to 2.4KM away. This suggests we should have a matching distance of up to 3000m (rather than 500m, for ways and relations at least).

OSM-MV matching
------

1. **Match rule MV1:** If the closest MV point to an OSM point is <500m away.
2. **Match rule MV2:** MV1, no nodes, area is in the same order of magnitude

| Match rule | OSM id|MV id|Distance (m)|OSM area| MV area|OSM objtype| OSM located| Notes | Correct match find? |
|---|---|---|---|---|---|---|---|---|---|
|MV1|6767536119|1862|135|0|4,572|node|roof|The actual thing that MV has spotted appears to be panels on top of B&Q Bournemouth (checked with Google Maps).|:x:|
|MV1|721173461|1962|385|16.7|1,990|way|roof|Clearly parts of distinct installations, due to being on separate buildings on either side of an A road|:x:|
|MV1|314886516|2164|117|165,665|141,813|way||Match for Chibson solar farm|✅|
|MV1|2189625035|1506|72|0|52,346|node||A few matches like this where a node describes a solar plant, but there are also way(s) present more appropriate to match to|<-- yes but|
|MV1|3209363222|1167|100|0|206,382|node||Looks like a node has been added to OSM here but no one thought to add a way with more info. The match doesn't really have any use because node has no metadata.|✅|

**Matching Notes:**

In general, looks like OSM nodes are unlikely to be match correctly to MV, since MV is larger installations and farms only, most of the proximity matches under 500m are where there are rooftop nodes nearby to a farm.

OSM-FiT matching
--------

Output dataset
--------

### Accepted matches

TODO: update this section as per Ideal matching rules above.

These are things we can say are definitely matches, or decide they probably are based on the assumptions in the notes in the table below:

| Match rule | Count | Notes |
|---|---|---|
| 11 | 763 | These are doubly validated by what was included in OSM's REPD ID and proximity matching |


The output of refined matching rules should be to add to tables that link the database tables.

1. REPD - REPD dedup ID table (or just add column to REPD as we have for OSM)
2. OSM same as above
3. Table below. Anything that doesn't have a master ID, should have a master ID of itself. Caveats and multiple matches should be explained: Could also have a table that shows the uniqueness of match results in case de-dedup was inadequate OR matching was inadequate via the counts (Low Priority).

| REPD dedup (master) ID | OSM dedup (master) ID | MV ID |
|---|---|---|
|...|...|...|

Add FiT afterwards if time.
