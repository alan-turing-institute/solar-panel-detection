import pandas as pd
import re

def clean_repd_csv(csv_str):
    csv_str = csv_str.replace("\r", "").replace("†", "")
    rgx_list = ['\s*<br*\s*"', '\s*<br>\s*"']
    for rgx_match in rgx_list:
        csv_str = re.sub(rgx_match, '"', csv_str)
    return csv_str

# File paths
repd_file_path = "../data/data/as_received/REPD/Public-Database-September-2019.csv"
modified_repd_file_path = "../data/data/raw/repd_modified_processed.csv"

manual_modified_fit_file_path = '../data/data/raw/feed-in_tariff_installation_report_30_september_2019.csv'
modified_fit_file_path = "../data/data/raw/feed-in_tariff_installation_report_30_september_2019_processed.csv"

# Make edits to specific columns with pandas
repd_df = pd.read_csv(repd_file_path, encoding = "ISO-8859-1", skiprows=1)
repd_df['Storage Co-location REPD Ref ID'] = repd_df['Storage Co-location REPD Ref ID'].map(lambda x: float(str(x).replace(',','')))
repd_df['X-coordinate'] = repd_df['X-coordinate'].map(lambda x: float(str(x).replace(',','')))
repd_df['Y-coordinate'] = repd_df['Y-coordinate'].map(lambda x: float(str(x).replace(',','')))
repd_df['Post Code'] = repd_df['Post Code'].map(lambda x: str(x).replace(' ',''))
repd_df['FiT Tariff (p/kWh)'] = repd_df['FiT Tariff (p/kWh)'].map(lambda x: float(x))
repd_df.Address = repd_df.Address.str.replace('\r\n', ', ')
repd_df['Appeal Reference'] = repd_df['Appeal Reference'].map(lambda x: str(x).replace('\r\n', ''))
repd_csv_str = repd_df.to_csv(index=False)

fit_df = pd.read_csv(manual_modified_fit_file_path, encoding = "ISO-8859-1")
fit_csv_str = fit_df.to_csv(index=True)

# Make generic edits and save modified csv
with open(modified_repd_file_path, 'w') as repdfile:
    repdfile.write(clean_repd_csv(repd_csv_str))

with open(modified_fit_file_path, 'w') as fitfile:
    fitfile.write(fit_csv_str)
