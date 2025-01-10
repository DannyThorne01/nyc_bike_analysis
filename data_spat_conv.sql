-- hint 1: the projection we would like to use for our project is UTM zone 18N (EPSG: 32618)
-- hint 2: working with projection ST_Transform() and ST_SetSRID - https://postgis.net/documentation/tips/st-set-or-transform/
-- Goal: transform census tract boundary files with UTM 18N projection
-- Currently our geometry is multipolygon type consisting of LatLong coordinates. The coordinate system for 
-- for this is WGS84 and has SRID 4326. Because we want to perform spatial calculations we need reproject our data
alter table nyct2020
alter column wkb_geometry type geometry(MultiPolygon, 32618)
using ST_Transform(ST_SetSRID(wkb_geometry,4326),32618);


-- hint 1: the spatial reference id for WGS84 latitude and longitude is 4326
-- hint 2: the projection we would like to use for our project is UTM zone 18N (EPSG: 32618)
-- hint 3: working with projection ST_Transform() and ST_SetSRID - https://postgis.net/documentation/tips/st-set-or-transform/
-- Goal: turn stations table into geospatial data format and set the correct projection

-- Step 1: Add a new geometry column to the bike_stations table
alter table public.stations
add column geom geometry(Point, 4326);

-- Step 2: Populate the new geom column using lat and lon columns
update public.stations
set geom = st_setsrid(st_makepoint(station_lon, station_lat) , 4326);

-- Step 3: Transform the geometry to UTM Zone 18N projection (EPSG: 32618)
alter table public.stations
alter column geom type geometry(Point, 32618)
using ST_Transform(geom, 32618)


--ALTER TABLE  public.stations
--DROP COLUMN geom;

 --we can also hypothetically find the srid that we're working with 

