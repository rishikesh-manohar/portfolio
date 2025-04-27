--RETRIVE ALL SUCCESSFUL RECORDS --
SELECT * FROM OLA 
WHERE BOOKING_STATUS='SUCCESS';

---Find the Average Ride Distance for Each Vehicle Type---
SELECT Vehicle_Type,AVG(Ride_Distance) AS AVERAGE_RIDE_DISTANCE FROM OLA 
GROUP BY Vehicle_Type
ORDER BY AVERAGE_RIDE_DISTANCE DESC;

---List the Top 5 Customers Who Booked the Highest Number of Rides---
SELECT CUSTOMER_ID,COUNT(BOOKING_ID) AS NUMBER_OF_BOOKING FROM OLA 
GROUP BY CUSTOMER_ID
ORDER BY NUMBER_OF_BOOKING DESC
LIMIT 5 ;

--Get the Number of Rides Cancelled by Drivers Due to Personal and Car-Related Issues--
SELECT COUNT(*) FROM OLA 
WHERE Canceled_Rides_by_Driver='Personal & Car related issue';

--Find the Maximum and Minimum Driver Ratings for Prime Sedan Bookings--
SELECT Vehicle_Type,MAX(Driver_Ratings) AS MAXIMUM_RATING ,MIN(Driver_Ratings) AS MINIMUM_RATINS FROM OLA 
WHERE Vehicle_Type='Prime Sedan';
--Find the Average Customer Rating Per Vehicle Type--
SELECT Vehicle_Type,ROUND(AVG(Driver_Ratings),2) AS AVERAGE_RATINS FROM OLA 
GROUP BY Vehicle_Type
ORDER BY AVERAGE_RATINS;
--Calculate the Total Booking Value of Rides Completed Successfully--
SELECT SUM(BOOKING_VALUE) AS TOTAL_BOOKING FROM OLA 
WHERE BOOKING_STATUS='SUCCESS';
--List All Incomplete Rides Along with the Reason--
SELECT BOOKING_ID,INCOMPLETE_RIDES_REASON FROM OLA
WHERE INCOMPLETE_RIDES='YES';
