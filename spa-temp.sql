-- business goal: optimize van routes for replenishing bike stations
-- task: create a buffer of 1 kilometers around the top 3 bike stations where most of the trips started from, 
---- and perform a spatial join to analyze which nearby stations fall within a 1 km radius for easy servicing
-- hint: use ST_Buffer() and ST_Intersects() functions from PostGIS

-- Step 1: Identify top 3 stations where most trips started from
--select start_station_id, count(*) as total_trips
--from public.trip_data td 
--group by start_station_id 
--order by total_trips desc 
--limit 5;

-- Step 2: Create buffers around top 3 stations
--with top_stations as 
--(
--	select station_id, geom
--	from public.stations s 
--	WHERE station_id IN (select start_station_id 
--						from public.trip_data td 
--						group by start_station_id
--						order by count(*) desc
--						limit 5)
--)	
--SELECT station_id, ST_Buffer(geom, 1000) AS buffer_geom
--FROM top_stations;

-- Step 3: Perform spatial join
--with top_station_buffers as (
--	select station_id, ST_Buffer(geom, 1000) as buffer_geom
--	from public.stations s 
--	where station_id in (	select start_station_id
--							from public.trip_data td
--							group by start_station_id
--							order by count(*) desc
--							limit 3)
--)
--select s.station_id, tsb.station_id as top_station_id
--from public.stations s 
--join top_station_buffers as tsb
--on ST_Intersects(s.geom, tsb.buffer_geom)
--order by top_station_id


--WITH top_station_buffers AS (
--    SELECT station_id, ST_Buffer(geom, 1000) AS buffer_geom
--    FROM public.stations
--    WHERE station_id IN (SELECT start_station_id
--                         FROM public.trip_data
--                         GROUP BY start_station_id
--                         ORDER BY COUNT(*) DESC
--                         LIMIT 3)
--)
--SELECT s.station_id, tsb.station_id AS top_station_id
--FROM public.stations s
--JOIN top_station_buffers tsb
--ON ST_Intersects(s.geom, tsb.buffer_geom)
--ORDER BY top_station_id;

-- goal: group trip data by both ttemporal and spatial dimensions 
-- task: create a new table named spatio_temporal_visualization_05_01 that includes 
--       total trip count by census tract and half hour intervals
-- HINT: ST_Within(), JOIN, GROUP BY

create TABLE spatio_temporal_visualization as (
	select 
		half_hour_starttime,
		nyct2020.ogc_fid as cencus_tract_id,
		nyct2020.wkb_geometry  as census_geom,
		count(trip_data.ride_id) as trip_count
	from public.trip_data
	join public.stations on trip_data.start_station_id  = stations.station_id 
	join public.nyct2020 on ST_Within(stations.geom, nyct2020.wkb_geometry)
	group by half_hour_starttime, cencus_tract_id
	order by half_hour_starttime, cencus_tract_id
	
		
)

