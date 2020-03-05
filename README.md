# Solar Panel Detection (Turing Climate Action Call)

Project code: R-SPES-115 - Enabling worldwide solar PV nowcasting via machine vision and open data

Hut23 issue: https://github.com/alan-turing-institute/Hut23/issues/425

- [Sheffield Solar](https://www.solar.sheffield.ac.uk/)
- [Open Climate Fix](https://openclimatefix.org/)
- [Open Street Map](https://www.openstreetmap.org)
- [Open Infrastructure Map](https://openinframap.org)

## Main Project Description

Using a combination of AI (machine vision), open data and short term forecasting, the project aims to determine the amount of solar electricity being put into the UK grid at a given time (i.e. right now: "Nowcasting").

Dan Stowell (Queen Mary) and collaborators are working on using a number of datasets, each of which are incomplete and messy, to create an estimate of all solar panels and their orientation in the UK. This will involve some data wrangling to combine a number of geospatial data sources and then use data science methods to determine the solar panel assets across the UK and provide a web service to disseminate the results.

Data sources will be from Open Street Maps, which has been tagging solar panels in the UK, as well as other data provided by Sheffield Solar and Open Climate Fix. The REG would be doing most of the data wrangling and machine learning on the project, with the other partners providing data and expertise.

## REG Project

**Goal:** Aggregate UK solar PV data into a structured format, which can be accessed.

Dan Stowell says: "Plan A" is to use an instance of the OpenStreetMap (OSM) server which Damien (openclimatefix) has spun up, as the primary data warehouse. This can host the data for us in OSM's native format, while allowing us to add the extra metadata that wouldn't normally be in OSM (i.e. that from linked data sources FiT and REPD, see below).

**Challenges:**

1. Link the tagged panels in OSM to the other data sources
2. Unsure: *Find other solar PV objects in OSM based on other data sources?*

## Overview of the directory structure

```
.
|-- admin            -- project process and planning docs
|-- data
|   |-- as_received  -- symbolic link
|   |-- raw          -- symbolic link
|-- database
`-- notebooks
```


## Data

Data is held in two directories: `as_received` contains the data precisely as
downloaded from its original source, in its original format; `raw` contains all
the data used by the project in a format suitable for use by software in the
project (for example, as `csv` files ready for upload to a database). Between
`as_received` and `raw` there may be some non-automated transformations (eg,
saving an Excel file as `csv`). No non-automated transformation is permitted
after `raw`.

The following sources of data are used:

- OpenStreetMap - [Great Britain download (Geofabrik)](https://download.geofabrik.de/europe/great-britain.html). Dan Stowell has sent a data file that includes tagged UK solar PV objects for the UK.
    - [OSM data types](https://wiki.openstreetmap.org/wiki/Elements)
    - [Solar PV tagging](https://wiki.openstreetmap.org/wiki/Tag:generator:source%3Dsolar)
    - Osmium package [pyosmium](https://github.com/osmcode/pyosmium) - `pip install osmium`
- [FiT](https://www.ofgem.gov.uk/environmental-programmes/fit/contacts-guidance-and-resources/public-reports-and-data-fit/installation-reports) - Report of installed PV (and other tech including wind). 100,000s entries.
- [REPD](https://www.gov.uk/government/publications/renewable-energy-planning-database-monthly-extract) - Official UK data from the "renewable energy planning database". Large solar farms only.

## Output

What we should have by the end of the project is a set of scripts that will take input datasets (REPD, OSM, FiT and machine vision – each in diff format), perform data cleaning/conversion, populate a PostgreSQL database, perform grouping of data where necessary (duplicate entries in REPD, multiple solar farm components in OSM) and then match entries between the data tables, based on the matching criteria we have come up with.

The result of matching will be table(s) that link the unique identifiers of the data tables. These should also link somehow to info on how each of the matches were determined (which rules they satisfied), which will be written up in documentation.

The data cleaning, grouping and matching stages will all be documented as fully as possible. It should be possible for anyone to refer to this GitHub repo, follow the instructions to create the db and run matching (possibly as simple as a single make command) with either the current datasets or newer versions (e.g. more recently downloaded REPD spreadsheet) and then have the match table(s) in Postgres.
