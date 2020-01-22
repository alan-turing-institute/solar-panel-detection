#!/usr/bin/env python3
### Process the REPD data to remove oddities
### Reads from stdin, writes to stdout

import sys
import pandas as pd
import re

# Remove "carriage returns" and the dagger symbol
def clean_repd_csv(csv_str):
    csv_str = csv_str.replace("\r", "").replace("†", "")
    rgx_list = ['\s*<br*\s*"', '\s*<br>\s*"']
    for rgx_match in rgx_list:
        csv_str = re.sub(rgx_match, '"', csv_str)
    return csv_str

sys.stdin.reconfigure(encoding='iso-8859-1')
repd_df = pd.read_csv(sys.stdin, skiprows=1)

# Remove thousand-separator commas from number fields
repd_df['Storage Co-location REPD Ref ID'] = repd_df['Storage Co-location REPD Ref ID'].map(lambda x: float(str(x).replace(',','')))
repd_df['X-coordinate'] = repd_df['X-coordinate'].map(lambda x: float(str(x).replace(',','')))
repd_df['Y-coordinate'] = repd_df['Y-coordinate'].map(lambda x: float(str(x).replace(',','')))

# Remove spaces from postcodes
repd_df['Post Code'] = repd_df['Post Code'].map(lambda x: str(x).replace(' ',''))

# Ensure the tariff is numeric 
repd_df['FiT Tariff (p/kWh)'] = repd_df['FiT Tariff (p/kWh)'].map(lambda x: float(x))

# Remove line breaks from within certain fields
repd_df['Address'] = repd_df['Address'].str.replace('\r\n', ', ')
repd_df['Appeal Reference'] = repd_df['Appeal Reference'].map(lambda x: str(x).replace('\r\n', ''))

repd_csv_str = repd_df.to_csv(index=False)

# Make generic edits and write out 
sys.stdout.write(clean_repd_csv(repd_csv_str))
