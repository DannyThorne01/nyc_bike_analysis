-- Objective: determine how many bike trips started in each census tract.
-- Spatial join of the points in the stations table and polygons in the cnesus tracts table
-- Step 1: assign each bike station to the appropriate census tract using a spatial join
--select 
--	s.station_id,
--	nyct.ogc_fid,
--	s.geom
--from
--	stations as s
--join 
--	nyct2020 as nyct
--on
--	ST_Within(s.geom, nyct.wkb_geometry);

-- Step 2:  Aggregate trip data by census tract joining stations with trip data to which census tract each trip started in

 
with station_census as (
	select 
		s.station_id,
		nyct.ogc_fid,
		s.geom
	from
		stations as s
	join 
		nyct2020 as nyct
	on
		ST_Within(s.geom, nyct.wkb_geometry)
)

select
	t.ride_id, 
	t.half_hour_starttime,
	sc.ogc_fid, 
	t.start_station_id
from
	trip_data as t
left join
	station_census as sc
on 
	t.start_station_id = sc.station_id;

	

-- Step 3: grouping and counting trips by census tract 
WITH station_census AS (
	SELECT 
	    s.station_id, 
	    nyct.ogc_fid, 
	    s.geom, 
	    nyct.wkb_geometry
	FROM 
	    stations AS s
	JOIN 
	    nyct2020 AS nyct 
	ON 
	    ST_Within(s.geom,nyct.wkb_geometry)
)
SELECT 
    sc.ogc_fid, 
    COUNT(t.ride_id) AS trip_count, 
    sc.wkb_geometry
FROM 
    trip_data AS t
LEFT JOIN 
    station_census AS sc
ON 
    t.start_station_id = sc.station_id
GROUP BY 
    sc.ogc_fid, sc.wkb_geometry
ORDER BY 
    trip_count DESC;

-- Step 4: save as table for visualization
create TABLE ct_trip_count_04_04 AS
WITH station_census AS (
	SELECT 
	    s.station_id, 
	    nyct.ogc_fid, 
	    s.geom, 
	    nyct.wkb_geometry
	FROM 
	    stations AS s
	JOIN 
	    nyct2020 AS nyct 
	ON 
	    ST_Within(s.geom,nyct.wkb_geometry)
)
SELECT 
    sc.ogc_fid, 
    COUNT(t.ride_id) AS trip_count, 
    sc.wkb_geometry
FROM 
    trip_data AS t
LEFT JOIN 
    station_census AS sc
ON 
    t.start_station_id = sc.station_id
GROUP BY 
    sc.ogc_fid, sc.wkb_geometry
ORDER BY 
    trip_count DESC;