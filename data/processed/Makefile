# Create "processed" datasets from "raw" datasets

all: repd-2019-09.csv fit-2019-09.csv osm.csv

repd-2019-09.csv: ../as_received/REPD/Public-Database-September-2019.csv
	./pre-process-repd.py < $< > $@

fit-2019-09.csv: ../raw/feed-in_tariff_installation_report_30_september_2019.csv
	./pre-process-fit.py < $< > $@

osm.csv: ../raw/osm_compile_processed_PV_objects_modified.csv
	./pre-process-osm.py < $< > $@
