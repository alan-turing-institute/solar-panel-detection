# Directory structure

NOTE: The subdirectories `as_received` and `raw` should be set up to be symbolic
links to those directories on the shared drive.

`as_received`

: Datasets precisely in the form in which we originally got them, unchanged in
  content or format, whether text or binary, open or proprietary.

`raw`

: Data that has been manually edited, at least to change the format to one that
  we can use programmatically (if required) but also there may a small number of
  edits to the data that do not seem to be generalisable, or we can't work out
  how to automate, or are not likely to re-occur next time we download the data.

`processed`

: Datasets that have been programmatically modified (typically from `raw`). Note
  that the `processed` directory is _local_, it is like a “compiled code”
  directory: not under version control but neither on the shared drive.


# Notes on the data sources

## Feed-in Tariff (FiT)

Latest data taken from: https://www.ofgem.gov.uk/publications-and-updates/feed-tariff-installation-report-30-september-2019

There are hundreds of thousands of entries. Geolocation is imprecise (it's only given as postcode districts and/or LSOA districts).

Includes wind and other tech as well as solar. Make sure to filter on Technology=Photovoltaic.

## Renewable Energy Planning Database (REPD)

https://www.gov.uk/government/publications/renewable-energy-planning-database-monthly-extract

Official UK data from the "renewable energy planning database". This only has
the larger solar farms (approx 1000) and geolocations are imprecise (mainly
unreliable street addresses). However it includes useful metadata - capacity,
install date, etc.

Note: the majority of REPD solar farms (approx 900) have already been entered into OSM.

## Open Streetmap

OSM: OpenStreetMap solar PV objects for the UK. Approx 120,000 small-scale PV and 900 solar farms. The data is in OSM's pbf format, and it's extracted from OSM database as of 2019-11-17. It's structured data. Also included an XML version.
