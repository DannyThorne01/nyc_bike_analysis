--##-- Use public.stations to answer the following questions.--##--
-- Question 1: How many stations does BigApple BikeShare company have? 
select count(*) as station_count
from public.stations ;
--##-- Use public.trip_data to answer the following questions.--##--
-- Question 2: How many trips were taken on September 17th? 
select count(*) as trip_count
from public.trip_data
where start_time::date = '2024-09-17';
-- Question 3: What percentage of bike trips used an e-bike?
select ( count(case when bike_type = 'ebike' then 1 end) * 100.0/ count(*)) as bike_percent
from public.trip_data

-- Question 4: which bike station had the most starting trips on that day? 
select start_station_id, count(ride_id) as trip_count
from public.trip_data td 
group by start_station_id 
order by trip_count desc
limit 1

-- Question 5: What’s the average length of a bike trip?
select avg(end_time::timestamp - start_time::timestamp) as avg_trip_duration
from public.trip_data td 

-- Goal: understand the bike usage throughout the day.
-- Task: determine the times when the most bike trips start, 
----     listing these times in descending order from the busiest to the least busy, 
----     along with the corresponding bike trip counts. 
-- Hint: GROUP_BY(), ORDER_BY()

select half_hour_starttime, count(*) as trip_count
from public.trip_data td 
group by half_hour_starttime 
order by trip_count desc

-- Add a new column in trip_data to store the half-hour interval
alter table public.trip_data
add column half_hour_starttime TIMESTAMP;
-- Update the new column with half-hour intervals based on start_time

update trip_data 
set half_hour_starttime  = date_trunc('hour', start_time::timestamp ) + 
interval '30 minutes' * FLOOR(EXTRACT(MINUTE FROM start_time::timestamp) / 30);


