# Create "processed" datasets from "raw" datasets

all: repd.csv fit.csv osm.csv machine_vision.csv pre-process-repd.py pre-process-fit.py pre-process-osm.py pre-process-mv.py

repd.csv: ../raw/repd.csv pre-process-repd.py
	./pre-process-repd.py < $< > $@

fit.csv: ../raw/fit.csv pre-process-fit.py
	./pre-process-fit.py < $< > $@

osm.csv: ../raw/osm.csv pre-process-osm.py
	./pre-process-osm.py < $< > $@

machine_vision.csv: ../raw/machine_vision.geojson pre-process-mv.py
	./pre-process-mv.py < $< > $@
