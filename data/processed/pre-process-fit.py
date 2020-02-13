#!/usr/bin/env python3
### Process the FiT data to add an index column
### Reads from stdin, writes to stdout

import sys
import pandas as pd

sys.stdin.reconfigure(encoding='iso-8859-1')
fit_df = pd.read_csv(sys.stdin)
fit_csv_str = fit_df.to_csv(index=True)

sys.stdout.write(fit_csv_str)
