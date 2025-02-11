-- SCHEMA DESIGN SCRIPT FOR MStay DATABASE

-- 1️⃣ Creating Channel Dimension Table
CREATE TABLE ChannelDim AS
SELECT * FROM MStay.channel;

-- 2️⃣ Creating Host Dimension Table
CREATE TABLE HostDim AS
SELECT DISTINCT HOST_ID, HOST_NAME FROM MStay.host;

-- 3️⃣ Creating Booking Time Dimension Table
CREATE TABLE BookingTimeDim AS
SELECT DISTINCT TO_CHAR(Booking_Date, 'YYYYMM') AS BookingTime_ID,
    TO_CHAR(Booking_Date, 'Month') AS BookingTime_Month,
    TO_CHAR(Booking_Date, 'YYYY') AS BookingTime_Year
FROM MStay.Booking;

-- 4️⃣ Creating Fact Table for Listings
CREATE TABLE ListingFact AS
SELECT 
    TO_CHAR(listing_date, 'YYYYMM') AS ListingTime_ID,
    host_id,
    SUM(listing_price) AS total_listing_price,
    COUNT(listing_id) AS num_of_listings
FROM MStay.listing
GROUP BY host_id, TO_CHAR(listing_date, 'YYYYMM');

-- 5️⃣ Creating Fact Table for Bookings
CREATE TABLE BookingFact AS
SELECT 
    TO_CHAR(booking_date, 'YYYYMM') AS BookingTime_ID,
    SUM(booking_cost) AS total_booking_cost,
    COUNT(booking_id) AS num_of_bookings
FROM MStay.booking
GROUP BY TO_CHAR(booking_date, 'YYYYMM');

COMMIT;
