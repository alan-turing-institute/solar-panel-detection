#!/usr/bin/env python3
### Create a CSV for easy import to PostgreSQL
### Get the centre of the polygons as point coordinates for the machine vision objects
### Reads from stdin, writes to stdout

import geopandas as gpd
import sys

machine_vision = "../as_received/machine-vision-descartes/Kruitwagen_Story_GB_fc.geojson"
sys.stdin.reconfigure(encoding='iso-8859-1')
machine_vision_df = gpd.read_file(machine_vision)

x = []
y = []
for index, row in machine_vision_df.iterrows():
    point = gpd.GeoSeries(machine_vision_df.centroid)
    x = point.x
    y = point.y
machine_vision_df['x'] = x
machine_vision_df['y'] = y

# TODO: if we need this in PostgreSQL/PostGIS, figure out the correct data type for table column
machine_vision_df = machine_vision_df.drop(['geometry'], axis=1)

mv_csv_str = machine_vision_df.to_csv(index=False)

sys.stdout.write(mv_csv_str)
