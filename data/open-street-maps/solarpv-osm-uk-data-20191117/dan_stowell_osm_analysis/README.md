This is Dan Stowell's python script that he's been using to process the OSM data (to check progress, produce plots etc): The script contains a lot of little things that deal with quirky data - e.g. various different ways to express the compass orientation of a PV installation. So in a way, the script is a great document of the known quirks in the data.

Perhaps the most difficult thing the script does is deal with the fact that a single PV installation could be a node, an area, an area with areas inside, a "relation" of multiple separate areas, ... .

The script also produces an over-simplified CSV of PV installs, which is included here.
