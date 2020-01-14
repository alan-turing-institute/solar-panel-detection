import pandas as pd

repd = "../data/raw/repd_modified.csv"
fit = "../data/raw/feed-in_tariff_installation_report_30_september_2019.csv"
osm = "../data/raw/osm_compile_processed_PV_objects_modified.csv"

repd_df = pd.read_csv(repd, encoding = "ISO-8859-1")
fit_df = pd.read_csv(fit, encoding = "ISO-8859-1")
osm_df = pd.read_csv(osm, encoding = "ISO-8859-1")

repd_df['Storage Co-location REPD Ref ID'] = repd_df['Storage Co-location REPD Ref ID'].map(lambda x: float(str(x).replace(',','')))
repd_df['FiT Tariff (p/kWh)'] = repd_df['FiT Tariff (p/kWh)'].map(lambda x: float(x))
