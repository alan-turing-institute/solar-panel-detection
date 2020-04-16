#!/usr/bin/env python3
### Process the FiT data to add an index column
### Reads from stdin, writes to stdout

import sys
import pandas as pd
import numpy as np

sys.stdin.reconfigure(encoding='iso-8859-1')
fit_df = pd.read_csv(sys.stdin)

# Check the file has the columns we expect and order them as we expect
# If the columns don't exist, make the column empty
output_df = pd.DataFrame()
required_columns = ['Extension (Y/N)',
                    'Postcode',
                    'Technology',
                    'Installed capacity',
                    'Declared net capacity',
                    'Application date',
                    'Commissioning date',
                    'MCS issue date',
                    'Export status',
                    'Tariff code',
                    'Tariff description',
                    'Installation type',
                    'Country',
                    'Local authority',
                    'Government office region',
                    'Constituency',
                    'Accreditation Route',
                    'MPAN Prefix',
                    'Community/school category',
                    'LLSOA code']

for col in required_columns:
    try:
        output_df[col] = fit_df[col]
    except KeyError:
        output_df[col] = np.nan

# Add index column
fit_csv_str = output_df.to_csv(index=True)

sys.stdout.write(fit_csv_str)
