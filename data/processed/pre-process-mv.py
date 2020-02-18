#!/usr/bin/env python3
### Create a CSV for easy import to PostgreSQL
### Get the centre of the polygons as point coordinates for the machine vision objects
### Remove the string "<2016-06" from dates as this can't be loaded as a date in PostgreSQL
### Reads from stdin, writes to stdout

import geopandas as gpd
import sys

machine_vision = "../as_received/machine-vision-descartes/Kruitwagen_Story_GB_fc.geojson"
sys.stdin.reconfigure(encoding='iso-8859-1')
machine_vision_df = gpd.read_file(machine_vision)

def getXY(pt):
    return (pt.x, pt.y)
centroidseries = machine_vision_df['geometry'].centroid
centroidlist = map(getXY, centroidseries)
machine_vision_df['x'], machine_vision_df['y'] = [list(t) for t in zip(*map(getXY, centroidseries))]

def remove_bad_date(dt_str):
    """Remove the string representing any date before 2016-06 and also only take
    the first of those with 2 dates; take the earlier date as correct for
    install date"""
    return(dt_str.replace("<2016-06", "").split(",")[0])
machine_vision_df['install_date'] = list(map(remove_bad_date, machine_vision_df['install_date']))

# TODO: if we need this in PostgreSQL/PostGIS, figure out the correct data type for table column
machine_vision_df = machine_vision_df.drop(['geometry'], axis=1)

mv_csv_str = machine_vision_df.to_csv(index=False)

sys.stdout.write(mv_csv_str)
