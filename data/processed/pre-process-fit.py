#!/usr/bin/env python3
### Process the FiT data to add an index column
### Reads from stdin, writes to stdout

import sys
import pandas as pd

manual_modified_fit_file_path = '../data/data/raw/feed-in_tariff_installation_report_30_september_2019.csv'
modified_fit_file_path = "../data/data/raw/feed-in_tariff_installation_report_30_september_2019_processed.csv"

sys.stdin.reconfigure(encoding='iso-8859-1')
fit_df = pd.read_csv(sys.stdin)
fit_csv_str = fit_df.to_csv(index=True)

sys.stdout.write(fit_csv_str)
