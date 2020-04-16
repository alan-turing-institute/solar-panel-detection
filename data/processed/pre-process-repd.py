#!/usr/bin/env python3
### Process the REPD data to remove oddities
### Reads from stdin, writes to stdout

from bng_to_latlon import OSGB36toWGS84 as convert
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

# Check the file has the columns we expect and order them as we expect
# If the columns don't exist, make the column empty
output_df = pd.DataFrame()
required_columns = ['Old Ref ID',
                    'Ref ID',
                    'Record Last Updated (dd/mm/yyyy)',
                    'Operator (or Applicant)',
                    'Site Name',
                    'Technology Type',
                    'Storage Type',
                    'Storage Co-location REPD Ref ID',
                    'Installed Capacity (MWelec)',
                    'CHP Enabled',
                    'RO Banding (ROC/MWh)',
                    'FiT Tariff (p/kWh)',
                    'CfD Capacity (MW)',
                    'Turbine Capacity (MW)',
                    'No. of Turbines',
                    'Height of Turbines (m)',
                    'Mounting Type for Solar',
                    'Development Status',
                    'Development Status (short)',
                    'Address',
                    'County',
                    'Region',
                    'Country',
                    'Post Code',
                    'X-coordinate',
                    'Y-coordinate',
                    'Planning Authority',
                    'Planning Application Reference',
                    'Appeal Reference',
                    'Secretary of State Reference',
                    'Type of Secretary of State Intervention',
                    'Judicial Review',
                    'Offshore Wind Round',
                    'Planning Application Submitted',
                    'Planning Application Withdrawn',
                    'Planning Permission Refused',
                    'Appeal Lodged',
                    'Appeal Withdrawn',
                    'Appeal Refused',
                    'Appeal Granted',
                    'Planning Permission Granted',
                    'Secretary of State - Intervened',
                    'Secretary of State - Refusal',
                    'Secretary of State - Granted',
                    'Planning Permission Expired',
                    'Under Construction',
                    'Operational']

for col in required_columns:
    try:
        output_df[col] = repd_df[col]
    except KeyError:
        output_df[col] = np.nan

# Remove thousand-separator commas from number fields
output_df['Storage Co-location REPD Ref ID'] = output_df['Storage Co-location REPD Ref ID'].map(lambda x: float(str(x).replace(',','')))
output_df['X-coordinate'] = output_df['X-coordinate'].map(lambda x: float(str(x).replace(',','')))
output_df['Y-coordinate'] = output_df['Y-coordinate'].map(lambda x: float(str(x).replace(',','')))

# Remove spaces from postcodes
output_df['Post Code'] = output_df['Post Code'].map(lambda x: str(x).replace(' ',''))

# Ensure the tariff is numeric
output_df['FiT Tariff (p/kWh)'] = output_df['FiT Tariff (p/kWh)'].map(lambda x: float(x))

# Remove line breaks from within certain fields
output_df['Address'] = output_df['Address'].str.replace('\r\n', ', ')
output_df['Appeal Reference'] = output_df['Appeal Reference'].map(lambda x: str(x).replace('\r\n', ''))

# Convert each BNG coordinate to lat and lon and add new columns
for index, row in output_df.iterrows():
    # Ignore any rows that don't have an X and Y coordinate
    if pd.notna(row['X-coordinate']) and pd.notna(row['Y-coordinate']):
        lat, lon = convert(row['X-coordinate'], row['Y-coordinate'])
        output_df.set_value(index,'latitude', lat)
        output_df.set_value(index,'longitude', lon)

repd_csv_str = output_df.to_csv(index=False)

# Make generic edits and write out
sys.stdout.write(clean_repd_csv(repd_csv_str))
