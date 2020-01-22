#!/usr/bin/env python3
### Process the OSM data to fix date formatting
### Reads from stdin, writes to stdout

import sys
import pandas as pd
from dateutil.parser import parse

sys.stdin.reconfigure(encoding='iso-8859-1')
osm_df = pd.read_csv(sys.stdin)

# Edit tagged date column with pandas
dates = []
before_date_strs = ['before ']
after_date_strs = ['.']
mistakes = [('-00', '-01')]
for date in osm_df['tag_start_date']:
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
osm_df['tag_start_date'] = dates

osm_csv_str = osm_df.to_csv(index=False)

sys.stdout.write(osm_csv_str)
