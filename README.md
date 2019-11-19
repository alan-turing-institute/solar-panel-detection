# Solar Panel Detection (Turing Climate Action Call)

Project code: R-SPES-115 - Enabling worldwide solar PV nowcasting via machine vision and open data

Hut23 issue: https://github.com/alan-turing-institute/Hut23/issues/425

- [Sheffield Solar](https://www.solar.sheffield.ac.uk/)
- [Open Climate Fix](https://openclimatefix.org/)

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

## Data

- OpenStreetMap - [Great Britain download (Geofabrik)](https://download.geofabrik.de/europe/great-britain.html). Dan Stowell has sent a data file that includes tagged UK solar PV objects for the UK.
    - [OSM data types](https://wiki.openstreetmap.org/wiki/Elements)
    - [Solar PV tagging](https://wiki.openstreetmap.org/wiki/Tag:generator:source%3Dsolar)
    - Osmium package [pyosmium](https://github.com/osmcode/pyosmium) - `pip install osmium`
- [FiT](https://www.ofgem.gov.uk/environmental-programmes/fit/contacts-guidance-and-resources/public-reports-and-data-fit/installation-reports) - Report of installed PV (and other tech including wind). 100,000s entries.
- [REPD](https://www.gov.uk/government/publications/renewable-energy-planning-database-monthly-extract) - Official UK data from the "renewable energy planning database". Large solar farms only.
