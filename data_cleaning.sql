-- DATA CLEANING SCRIPT FOR MStay DATABASE

-- 1️⃣ Removing Duplicates from Booking Table
SELECT BOOKING_ID, COUNT(*)
FROM MStay.booking
GROUP BY BOOKING_ID
HAVING COUNT(*) > 1;

DELETE FROM MStay.booking
WHERE BOOKING_ID IN (
    SELECT BOOKING_ID FROM MStay.booking
    GROUP BY BOOKING_ID
    HAVING COUNT(*) > 1
);

-- 2️⃣ Removing Duplicates from Host Table
SELECT HOST_ID, COUNT(*)
FROM MStay.host
GROUP BY HOST_ID
HAVING COUNT(*) > 1;

DELETE FROM MStay.host
WHERE HOST_ID IN (
    SELECT HOST_ID FROM MStay.host
    GROUP BY HOST_ID
    HAVING COUNT(*) > 1
);

-- 3️⃣ Handling Constraint Violations
-- Removing Orphan Bookings with Invalid Guest IDs
DELETE FROM MStay.booking
WHERE guest_id NOT IN (SELECT guest_id FROM MStay.guest);

-- Removing Listings with Invalid Property IDs
DELETE FROM MStay.listing
WHERE prop_id NOT IN (SELECT prop_id FROM MStay.property);

-- 4️⃣ Handling NULL Values
UPDATE MStay.host
SET HOST_LOCATION = 'Unknown'
WHERE HOST_LOCATION IS NULL;

UPDATE MStay.review
SET REVIEW_COMMENT = 'No Comment'
WHERE REVIEW_COMMENT IS NULL;

-- 5️⃣ Fixing Negative Prices
UPDATE MStay.listing
SET listing_price = ABS(listing_price)
WHERE listing_price < 0;

COMMIT;
