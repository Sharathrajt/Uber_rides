SELECT * FROM rides;

SHOW COLUMNS FROM rides;

SET SQL_SAFE_UPDATES = 0;
		
        
        --- DATA CLEANING---
        
        
UPDATE rides SET `Request date` = REPLACE(`Request date`, '/', '-');

UPDATE rides SET `Request date` = STR_TO_DATE(`Request date`,'%d-%m-%Y');

ALTER TABLE rides MODIFY COLUMN `Request date` DATE;

UPDATE rides SET `Drop date` = REPLACE (`Drop date`, '/', '-');

UPDATE rides 
SET `Drop date` = CASE 
    WHEN `Drop date` = 'NA' THEN NULL
    ELSE STR_TO_DATE(`Drop date`, '%d-%m-%Y')
END;

ALTER TABLE rides MODIFY COLUMN `Drop date` DATE;

UPDATE rides 
SET `Drop time` = CASE 
    WHEN `Drop time` = 'NA' THEN NULL
    ELSE STR_TO_DATE(`Drop time`, '%H:%i:%s')
END;

ALTER TABLE rides MODIFY COLUMN `Drop time` TIME;

UPDATE rides 
SET `Driver id` = CASE 
    WHEN `Driver id` = 'NA' THEN NULL
    ELSE `Driver id`
END;
		
        
        --- DATA VALIDATION ---
        
SELECT Status, COUNT(`Pickup point`) as pick_up_point, COUNT(`Driver id`) as driver_id,  
COUNT(`Request time`) as Req_time, COUNT(`Drop time`) as Drop_time
FROM rides
GROUP BY Status;

/*
When ride was cancelled or cars weren't available there was no drop data, as expected.

When trip status is 'completed' all columns have same count. That's expected too.

So, we can make a reasonable assumption that there are no missing data in this dataset and 
we can now move to analysis
*/

		--- ADDING NECESSARY COLUMNS ---


ALTER TABLE rides ADD COLUMN `Request hour`INT;
UPDATE rides SET `Request hour` = HOUR(`Request time`);

ALTER TABLE rides ADD COLUMN `Request day` TEXT;
UPDATE rides SET `Request day` = DAYNAME(`Request date`);

ALTER TABLE rides ADD COLUMN `time of day` TEXT;

UPDATE rides SET 
`time of day` = CASE WHEN `Request hour` IN (0,1,2,3) THEN 'Late night'
WHEN `Request hour` IN (4,5,6,7) THEN 'Early morning'
WHEN `Request hour` IN (8,9,10,11) THEN 'Morning'
WHEN `Request hour` IN (12,13,14,15) THEN 'Mid day'
WHEN `Request hour` IN (16,17,18,19) THEN 'Evening'
WHEN `Request hour` IN (20,21,22,23) THEN 'Night'
END;

		--- ANALYSIS ---
-- CUSTOMER BOOKING ANALYSIS

SELECT `Pickup point`,`time of day`, COUNT(*)
FROM rides
GROUP BY `Pickup point`, `time of day`;
/*
Most of the pickups encountered at daytime is from city suggesting more people 
travel to the airport in day hours.
The pickups from Airport at evening hours are more and it suggests most people land in evening hours
*/

-- FINDING DRIVERS WITH HIGH CANCELLATION RATES

WITH cte_1 AS(
SELECT `Driver id`, COUNT(`Driver id`) AS cancelled_count
FROM rides
WHERE Status = 'Cancelled'
GROUP BY `Driver id`
),

cte_2 AS(
SELECT `Driver id`, COUNT(`Driver id`) AS completed_count
FROM rides
WHERE Status = 'Trip Completed'
GROUP BY `Driver id`
)

SELECT c.`Driver id`, 
c.cancelled_count AS trips_cancelled, IFNULL(tc.completed_count,0) AS trips_completed, 
ROUND((c.cancelled_count/(c.cancelled_count+IFNULL(tc.completed_count,0))),2) * 100 AS cancellation_rate
FROM cte_1 as c
LEFT JOIN cte_2 tc 
ON c.`Driver id` = tc.`Driver id`
HAVING cancellation_rate > 50
ORDER BY cancellation_rate DESC;

/*These driver performance is poor and appropriate actions must be taken*/

-- ROOT CAUSE ANALYSIS

SELECT Status, `Pickup point`,`time of day`, COUNT(*) AS Count
FROM rides
WHERE Status != 'Trip Completed'
GROUP BY Status, `Pickup point`,`time of day`;

SELECT `time of day`, COUNT(*) AS Count
FROM rides
WHERE Status != 'Trip Completed'
GROUP BY `time of day`;

/* Observations
Cancellations:

Cancellations are significantly higher in the City compared to the Airport.
The early morning and morning times have the highest cancellation rates in the City.
No Cars Available:

The Airport has a significantly higher number of instances where no cars are available compared to the City.
The evening and night times have the highest instances of "No Cars Available" at the Airport.
*/

/*
Suggestions and Way forward:
(1) Optimize driver allocation and incentives by increasing driver availability during peak times 
(early morning and morning for the City, evening and night for the Airport)
 through dynamic scheduling and offering incentives.
 
 (2) Enhance customer communication and experience by informing customers about 
 high-demand times to encourage pre-booking, utilizing notifications and reminders to manage expectations, 
 and collecting and analyzing customer feedback to continuously improve service quality.
*/

