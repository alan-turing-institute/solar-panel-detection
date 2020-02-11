# Create "processed" datasets from "raw" datasets

all: repd-2019-09.csv fit-2019-09.csv osm.csv machine_vision.csv pre-process-repd.py pre-process-fit.py pre-process-osm.py pre-process-mv.py

repd-2019-09.csv: ../as_received/REPD/Public-Database-September-2019.csv pre-process-repd.py
	./pre-process-repd.py < $< > $@

fit-2019-09.csv: ../raw/feed-in_tariff_installation_report_30_september_2019.csv pre-process-fit.py
	./pre-process-fit.py < $< > $@

osm.csv: ../raw/osm_compile_processed_PV_objects_modified.csv pre-process-osm.py
	./pre-process-osm.py < $< > $@

machine_vision.csv: ../as_received/machine-vision-descartes/Kruitwagen_Story_GB_fc.geojson pre-process-mv.py
	./pre-process-mv.py < $< > $@
