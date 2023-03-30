# Cycclistic-case-study
Final Project from Google Data Analytics Professional Certificate

-- After importing .csv file to sqlite/db browser, I named the database as tripdata and 
-- proceed to cleaning data by checking every column for null values using command line:

SELECT ()
FROM tripdata
WHERE () is NOT NULL

-- provide column name inside parenthesis to return column with values
-- ride_id, rideable_type, member_casual, started_at, ended_at all have complete values

-- columns start_lat, start_lng, end_lat, end_lng, start_station_id, end_station_id, end_station_name will not be included 
-- as I will only use start_station_name for the location of the station where the bike is rented. 

-- I also checked if all values of ended_at column are greater than values of started_at column by using command line:

SELECT started_at, ended_at
FROM tripdata
WHERE started_at > ended_at

-- this command will return data, meaning some of start time is greater than end time which would 
-- cause a negative trip duration later on our data manipulation. We will address this when we create our temp table


-- now that we are done cleaning our data, we will proceed to data manipulation/creating temp table 


CREATE TEMPORARY TABLE tripdata_Processed as  -- we will start with this command line and tripdata_Processed will be the name of our temp table
SELECT 
	ride_id,
	rideable_type,
	member_casual,							  -- we will be including these columns to our temp table. As for my problem 
	start_station_name,						  -- with the started_at and ended_at colums, they will be adressed at the where clause 
	started_at,
	ended_at,
	CASE strftime('%m', started_at)			  -- in this line, I will be using strftime('%m', started_at) so that it will return the number 
	WHEN '01' THEN '11Jan'					  -- of month. 01-12 will be returned so we need to use CASE to replace it with month name. Then
	WHEN '02' THEN '12Feb'					  -- we will name the column as Month.
	WHEN '03' THEN '01Mar'					  -- Month of March is named as 01Mar because it is the first month of my dataset from Mar 2022 - Feb 2023
	WHEN '04' THEN '02Apr'
	WHEN '05' THEN '03May'
	WHEN '06' THEN '04Jun'
	WHEN '07' THEN '05Jul'
	WHEN '08' THEN '06Aug'
	WHEN '09' THEN '07Sep'
	WHEN '10' THEN '08Oct'
	WHEN '11' THEN '09Nov'
	ELSE '10Dec' END as Month,
	case strftime('%w', started_at) 		  -- same idea as the month column but here we will be getting day of the week and we will name the 
	WHEN '0' then '01Sun'					  -- columns as Day_Borrowed and Day_Returned
	WHEN '1' THEN '02Mon'
	WHEN '2' THEN '03Tue'
	WHEN '3' THEN '04Wed'
	WHEN '4' THEN '05Thu'
	WHEN '5' THEN '06Fri'
	ELSE '07Sat' END as Day_Borrowed,
	case strftime('%w', ended_at) 
	WHEN '0' then '01Sun'
	WHEN '1' THEN '02Mon'
	WHEN '2' THEN '03Tue'
	WHEN '3' THEN '04Wed'
	WHEN '4' THEN '05Thu'
	WHEN '5' THEN '06Fri'
	ELSE '07Sat' END as Day_Returned,
	substr(started_at, 12, 2) as Hour_Borrowed,			-- I will be using this line to get what hour of the day the bike is borrowed. This will return 0-23 values corresponding to every hour of the day. I labeled this column as Hour_Borrowed
	round((julianday(ended_at)-julianday(started_at))*1440,2) as Trip_Duration		-- In this lineI will be subtracting date/time of started_at 
												-- to ended_at column, the value returned will be in days so 
												-- i need to multiply it to 1440 to convert it to minutes. I 
												-- also limit it to two decimal places
												-- I named the column as Trip_Duration
																					


-- After creating the temp table, we will run command line:

SELECT *
FROM tripdata_Processed

-- Then we will save it as .csv file by clicking save results view in the execute SQL menu
-- after saving, I will import the .csv to tableau to create data visualization.
