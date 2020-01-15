import pandas as pd

repd = "../data/raw/repd_modified.csv"
# fit = "../data/raw/feed-in_tariff_installation_report_30_september_2019.csv"
# osm = "../data/raw/osm_compile_processed_PV_objects_modified.csv"

repd_df = pd.read_csv(repd, encoding = "ISO-8859-1")
# fit_df = pd.read_csv(fit, encoding = "ISO-8859-1")
# osm_df = pd.read_csv(osm, encoding = "ISO-8859-1")

repd_df['Storage Co-location REPD Ref ID'] = repd_df['Storage Co-location REPD Ref ID'].map(lambda x: float(str(x).replace(',','')))
repd_df['FiT Tariff (p/kWh)'] = repd_df['FiT Tariff (p/kWh)'].map(lambda x: float(x))
repd_df.Address = repd_df.Address.str.replace('\r\n', ', ')
repd_df['Appeal Reference'] = repd_df['Appeal Reference'].map(lambda x: str(x).replace('\r\n', ''))

modified_repd_file_path = "../data/raw/repd_modified_processed.csv"
repd_csv_str = repd_df.to_csv(index=False)

with open(modified_repd_file_path, 'w') as repdfile:
    temp = repd_csv_str.replace("\r", "")
    repdfile.write(temp)
