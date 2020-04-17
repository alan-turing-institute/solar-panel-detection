#!/usr/bin/env python3
### Process the OSM data to fix date formatting
### Reads from stdin, writes to stdout

import sys
import pandas as pd
from dateutil.parser import parse

osm_df = pd.read_csv(sys.stdin)

# Check the file has the columns we expect and order them as we expect
# If the columns don't exist, make the column empty
output_df = pd.DataFrame()
required_columns = ['objtype',
                    'id',
                    'user',
                    'timestamp',
                    'lat',
                    'lon',
                    'calc_area',
                    'calc_capacity',
                    'generator:solar:modules',
                    'location',
                    'orientation',
                    'plantref',
                    'tag_power',
                    'tag_repd:id',
                    'tag_start_date']

for col in required_columns:
    try:
        output_df[col] = osm_df[col]
    except KeyError:
        output_df[col] = np.nan

# Edit tagged date column with pandas
dates = []
before_date_strs = ['before ']
after_date_strs = ['.']
mistakes = [('-00', '-01')]
for date in output_df['tag_start_date']:
    if pd.notna(date):
        og_date = date
        date = str(date)
        for string in before_date_strs:
            date = date.split(string)[-1]
        for string in after_date_strs:
            date = date.split(string)[0]
        for mistake, correction in mistakes:
            date = date.replace(mistake, correction)
        dates.append(parse(date, ignoretz=True, default=parse('2020-01-01')))
    else:
        dates.append(None)
output_df['tag_start_date'] = dates

osm_csv_str = output_df.to_csv(index=False)

sys.stdout.write(osm_csv_str)
