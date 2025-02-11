-- DATA ANALYSIS SCRIPT FOR MStay DATABASE

-- 1️⃣ How many long-term listings are on Facebook?
SELECT SUM(L.num_of_listings) AS num_of_listings
FROM ListingFact L
JOIN HostChannelBridge H ON L.host_id = H.host_id
JOIN ChannelDim C ON H.channel_id = C.channel_id
WHERE UPPER(C.channel_name) = 'FACEBOOK';

-- 2️⃣ How many listings were added in June 2015?
SELECT SUM(num_of_listings) AS num_of_listings
FROM ListingFact
WHERE ListingTime_ID = '201506';

-- 3️⃣ What is the average booking cost per year?
SELECT BookingTime_Year, 
       SUM(total_booking_cost) / SUM(num_of_bookings) AS avg_booking_cost
FROM BookingFact
JOIN BookingTimeDim ON BookingFact.BookingTime_ID = BookingTimeDim.BookingTime_ID
GROUP BY BookingTime_Year
ORDER BY BookingTime_Year;

-- 4️⃣ Which season had the most expensive listings?
SELECT Season_Description, 
       SUM(num_of_listings) AS num_of_expensive_listings
FROM ListingFact
JOIN ListingSeasonDim ON ListingFact.Season_ID = ListingSeasonDim.Season_ID
WHERE ListingFact.price_range_id = 3
GROUP BY Season_Description
ORDER BY num_of_expensive_listings DESC;

-- 5️⃣ How many bookings were made in April 2014?
SELECT SUM(num_of_bookings) AS num_of_bookings
FROM BookingFact
WHERE BookingTime_ID = '201404';

COMMIT;
