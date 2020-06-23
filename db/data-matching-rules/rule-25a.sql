-- Match rule 2.5a (see doc/matching.md)
\echo -n Performing match rule 2.5a...

insert into matches
select '25a', closest_pt.master_repd_id, osm.master_osm_id
from osm_repd_id_mapping LEFT JOIN osm USING (osm_id) LEFT JOIN repd_non_operational USING (repd_id)
 -- selecting matching repd IDs, and finding their distance:
 CROSS JOIN LATERAL
   (SELECT
      repd.master_repd_id,
      osm.location::geography <-> repd.location::geography as distance_meters
      FROM repd
      WHERE repd.repd_id=osm_repd_id_mapping.repd_id
        -- Not matches already found:
	AND not exists (
	    select
	    from matches
	    where matches.master_repd_id = repd_non_operational.master_repd_id
	    or matches.master_osm_id = osm.master_osm_id
	  )
-- Only the single nearest-neighbour:
ORDER BY osm.location::geography <-> repd.location::geography
    LIMIT 1) AS closest_pt;
