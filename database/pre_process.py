from dateutil.parser import parse
import pandas as pd
import re

#############################################################################
### REPD edits ##############################################################
#############################################################################

def clean_repd_csv(csv_str):
    csv_str = csv_str.replace("\r", "").replace("†", "")
    rgx_list = ['\s*<br*\s*"', '\s*<br>\s*"']
    for rgx_match in rgx_list:
        csv_str = re.sub(rgx_match, '"', csv_str)
    return csv_str

# File paths
repd_file_path = "../data/data/as_received/REPD/Public-Database-September-2019.csv"
modified_repd_file_path = "../data/data/raw/repd_modified_processed.csv"

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

# Make generic edits and save modified csv
with open(modified_repd_file_path, 'w') as repdfile:
    repdfile.write(clean_repd_csv(repd_csv_str))

#############################################################################
### FiT edits ###############################################################
#############################################################################

manual_modified_fit_file_path = '../data/data/raw/feed-in_tariff_installation_report_30_september_2019.csv'
modified_fit_file_path = "../data/data/raw/feed-in_tariff_installation_report_30_september_2019_processed.csv"

fit_df = pd.read_csv(manual_modified_fit_file_path, encoding = "ISO-8859-1")
fit_csv_str = fit_df.to_csv(index=True)

with open(modified_fit_file_path, 'w') as fitfile:
    fitfile.write(fit_csv_str)

#############################################################################
### OSM edits ###############################################################
#############################################################################

# File paths
manual_modified_osm_file_path = "../data/data/raw/osm_compile_processed_PV_objects_modified.csv"
modified_osm_file_path = "../data/data/raw/osm_compile_processed_PV_objects_modified_processed.csv"

# Edit tagged date column with pandas
osm_df = pd.read_csv(manual_modified_osm_file_path, encoding = "ISO-8859-1")
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

with open(modified_osm_file_path, 'w') as osmfile:
    osmfile.write(osm_csv_str)
