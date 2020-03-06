/* 
** Solar PV database creation and data ingest
** March 2020
** Authors: Ed Chalstery and James Geddes
**
** Prerequisites:
**   i. A database named "hut23-425" is assumed to exist on the local PostgreSQL server
**
** These psql files:
**   1. Create database tables (deleting them if they exist already)
**   2. Break out the REPD tags from the OSM dataset
**   3. Deduplicate certain tables
**
** See `doc/database.md` for details
*/

-- Preliminaries

alter database "hut23-425" set datestyle to "DMY"; -- to match FIT and REPD data files
create schema if not exists raw;
create extension if not exists postgis;

-- 1. Create tables and load data

\input osm.sql
\input repd.sql
\input fit.sql
\input mv.sql

-- 2. Preliminary matching

\input match-osm-repd.sql

-- 3. Deduplicate

\input dedup-osm.sql



