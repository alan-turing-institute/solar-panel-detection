# Solar Panel Detection (Turing Climate Action Call)

Project code: R-SPES-115 - Enabling worldwide solar PV nowcasting via machine vision and open data

Hut23 issue: https://github.com/alan-turing-institute/Hut23/issues/425

- [Sheffield Solar](https://www.solar.sheffield.ac.uk/)
- [Open Climate Fix](https://openclimatefix.org/)
- [Open Street Map](https://www.openstreetmap.org)
- [Open Infrastructure Map](https://openinframap.org)

## Main Project Description

Using a combination of AI (machine vision), open data and short term forecasting, the project aims to determine the amount of solar electricity being put into the UK grid at a given time (i.e., “right now”, or “nowcasting”).

Dan Stowell (Queen Mary) and collaborators are working on using a number of datasets, each of which are incomplete and messy, to create an estimate of all solar panels and their orientation in the UK. This will involve some data wrangling to combine a number of geospatial data sources and then use data science methods to determine the solar panel assets across the UK and provide a web service to disseminate the results.

Data sources will be from Open Street Maps, which has been tagging solar panels in the UK, as well as other data provided by Sheffield Solar and Open Climate Fix. The REG would be doing most of the data wrangling and machine learning on the project, with the other partners providing data and expertise.

## REG Project

### Goals

1. Aggregate UK solar PV data into a structured format, which can be accessed.
2. Link the tagged panels in OSM to the other data sources

## Overview of the directory structure

```
.
|-- admin            -- project process and planning docs
|-- data
|   |-- as_received  -- downloaded data files
|   |-- raw          -- manually edited files (replace dummy data)
|   |-- processed
|-- db               -- database creation
|-- doc              -- documentation
|-- explorations     -- exploratory work
`-- notebooks
```


## Data

Data is held in three directories: `as_received` contains the data precisely as
downloaded from its original source and in its original format; `raw` contains
data that has been manually restructured or reformatted to be suitable for use by
software in the project (see "Using this repo" header below). `processed` contains data that may have been processed in some way, such as by Python code, but is still thought of as “source” data.

The following sources of data are used:

- OpenStreetMap - [Great Britain download (Geofabrik)](https://download.geofabrik.de/europe/great-britain.html).
    - [OSM data types](https://wiki.openstreetmap.org/wiki/Elements)
    - [Solar PV tagging](https://wiki.openstreetmap.org/wiki/Tag:generator:source%3Dsolar)
- [FiT](https://www.ofgem.gov.uk/environmental-programmes/fit/contacts-guidance-and-resources/public-reports-and-data-fit/installation-reports) - Report of installed PV (and other tech including wind). 100,000s entries.
- [REPD](https://www.gov.uk/government/publications/renewable-energy-planning-database-monthly-extract) - Official UK data from the "renewable energy planning database". It contains large solar farms only.
- Machine Vision dataset - supplied by Descartes labs (Oxford), not publicly available yet.

## Project outcome

This repo includes a set of scripts that will take
input datasets (REPD, OSM, FiT and machine vision – each in diff format),
perform data cleaning/conversion, populate a PostgreSQL database, perform
grouping of data where necessary (there are duplicate entries in REPD, multiple solar farm
components in OSM) and then match entries between the data tables, based on the
matching criteria we have come up with.

The database creation and matching scripts should work with newer versions of the source data files, or at least do so with minimal changes to the data processing (see "Using this repo" below).

The result of matching is a table in the database called `matches` that links the unique identifiers of the
data tables. This also contains a column called `match_rule`, which refers to the method by which the match was determined, as documented in [doc/matching](doc/matching.md).

## Using this repo

### Install requirements

1. Install [PostgreSQL](https://www.postgresql.org/download/)
2. Install Python 3 (version 3.7 or later) and `pip`
3. Run `pip install -r requirements.txt`
4. Install [Osmium](https://osmcode.org/osmium-tool/)

### Download and prepare data files

1. Download the following data files from the internet and store locally. We recommend saving these original data files within the directory structure under `data/as_received`:
    - OSM PBF file (GB extract): [Download](https://download.geofabrik.de/europe/great-britain-latest.osm.pbf)
    - FiT reports: Navigate to [ofgem](https://www.ofgem.gov.uk/environmental-programmes/fit/contacts-guidance-and-resources/public-reports-and-data-fit/installation-reports) and click the link for the latest Installation Report (during the Turing project, 30 September 2019 was used), then download the main document AND subsidiary documents
    - REPD CSV file: [Download](https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/879414/renewable-energy-planning-database-march-2020.csv) - this is always the most up to date version
    - Machine Vision dataset: supplied by Descartes labs (Oxford), not publicly available yet.
2. Navigate to `submodules/compile_osm_solar` and edit the `osmsourcefpath` in `compile_osm_solar.py` so that the file path points to the OSM PBF file you downloaded. After installing the requirements in the submodule README, run `python compile_osm_solar.py`. One of the data files produced is a csv, which we use as source data. You can move this file to `data/as_received`
3. Carry out manual edits to the data files, as described in [doc/preprocessing](doc/preprocessing.md) and save them in `data/raw` under the names suggested by the doc, replacing the default dummy data files.
4. Navigate to `data/processed` and type `make` - this will create versions of the data files ready for import to PostgreSQL

### Run the database creation and data matching

4. Make sure you have PostgreSQL on your machine, then run the command: `createdb hut23-425 "Solar PV database matching"` - this creates the empty database.
5. Navigate to `db` and run the command `psql -f make-database.sql hut23-425` - this populates the database (see [doc/database](doc/database.md)), carries out some de-duplication of the datasets and performs the matching procedure (see [doc/matching](doc/matching.md)). Note: this may take several minutes.

Note that the above commands require you to have admin rights on your PostgreSQL server. On standard Debian-based machines you could prepend the commands with `sudo -u postgres`, or you could assign privileges to your own user account.

## External collaborators guidance

From April 2020 this repo is no longer under active development, however a fork of the project is being created by [Open Climate Fix](https://github.com/openclimatefix) if you wish to open issues and pull requests there.
