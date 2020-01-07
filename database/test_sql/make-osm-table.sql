drop table if exists solar.osm;
create table solar.osm (
  id bigint,
  output_capacity float,
  repd_id int,
  time_created date,
  lat float,
  lon float,
  primary key (id)
);

-- SELECT
--     LTRIM(RTRIM(CASE
--         WHEN @d like '%E-%' THEN CAST(CAST(@d AS FLOAT) AS DECIMAL(18,18))
--         WHEN @d like '%E+%' THEN CAST(CAST(@d AS FLOAT) AS DECIMAL)
--         ELSE @d
--     END))
