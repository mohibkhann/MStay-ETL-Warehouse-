# MStay-ETL-Warehouse-

# MStay Data Warehousing Project

## **Overview**
This repository contains the **MStay Data Warehousing Project**, designed to optimize and analyze a structured relational database system for an **accommodation booking platform**. The project focuses on **data exploration, cleaning, schema design, and analytical insights** using **SQL**.

---
## **Project Structure**

📂 `data_cleaning.sql` – SQL scripts for **removing duplicates, handling NULL values, and fixing foreign key violations**.  
📂 `schema_design.sql` – SQL scripts for **star schema creation and granularity optimization**.  
📂 `data_analysis.sql` – SQL queries for **analytical insights, including seasonal trends, booking behavior, and pricing analysis**.  
📂 `README.md` – Documentation of the entire process.  

---
## **1. Data Exploration & Cleaning**

### **1.1 Data Exploration**
We begin by exploring the 11 tables in the `MStay` database:

```sql
SELECT COUNT(*) FROM MStay.booking;
SELECT COUNT(*) FROM MStay.guest;
SELECT COUNT(*) FROM MStay.listing;
SELECT COUNT(*) FROM MStay.review;
```
Findings:
- The **booking table** contains 5002 records.
- The **listing table** has 4936 records.
- The **review table** holds 4870 reviews.

### **1.2 Handling Duplicate Records**
Example: The `booking` table had duplicate primary keys.

```sql
SELECT BOOKING_ID, COUNT(*) FROM MStay.booking GROUP BY BOOKING_ID HAVING COUNT(*) > 1;
DELETE FROM MStay.booking WHERE BOOKING_ID IN (SELECT BOOKING_ID FROM MStay.booking GROUP BY BOOKING_ID HAVING COUNT(*) > 1);
```

### **1.3 Fixing Constraint Violations**
Example: Some `host_id` values in `host_verification` did not exist in `host`.

```sql
DELETE FROM MStay.host_verification WHERE host_id NOT IN (SELECT host_id FROM MStay.host);
```

### **1.4 Handling NULL Values**
Example: Filling missing `review_comment` values with default text:

```sql
UPDATE MStay.review SET review_comment = 'No Comment' WHERE review_comment IS NULL;
```

---
## **2. Star Schema Design**

To optimize data retrieval and analysis, we designed a **Star Schema** with the following:

### **Fact Tables:**
- **`BookingFact`** – Stores summarized booking details.
- **`ListingFact`** – Captures listing attributes over time.
- **`ReviewFact`** – Aggregates review-related data.

### **Dimension Tables:**
- **`BookingTimeDim`** – Stores booking timestamps.
- **`ListingPriceDim`** – Categorizes price ranges.
- **`HostDim`** – Holds unique host details.

Example Schema:
```sql
CREATE TABLE BookingFact AS
SELECT
    TO_CHAR(booking_date, 'YYYYMM') AS BookingTime_ID,
    booking_cost,
    booking_duration,
    COUNT(booking_id) AS num_of_bookings
FROM MStay.booking
GROUP BY TO_CHAR(booking_date, 'YYYYMM'), booking_cost, booking_duration;
```

---
## **3. Data Analysis Queries**

### **3.1 Seasonal Trends in Listings**
```sql
SELECT Season_Description, COUNT(*) AS Listings FROM ListingFact
JOIN ListingSeasonDim ON ListingFact.season_id = ListingSeasonDim.Season_ID
GROUP BY Season_Description;
```
**Insight:** Summer has the highest number of listings, indicating peak travel seasons.

### **3.2 Average Booking Cost Per Year**
```sql
SELECT BookingTime_Year, AVG(booking_cost) AS Avg_Booking_Cost FROM BookingFact
JOIN BookingTimeDim ON BookingFact.BookingTime_ID = BookingTimeDim.BookingTime_ID
GROUP BY BookingTime_Year ORDER BY BookingTime_Year;
```
**Insight:** Booking costs increased post-pandemic due to rising demand.

### **3.3 Which Listing Type is Most Popular?**
```sql
SELECT Type_Description, COUNT(*) AS Total_Bookings FROM BookingFact
JOIN ListingTypeDim ON BookingFact.type_id = ListingTypeDim.type_id
GROUP BY Type_Description;
```
**Insight:** Entire homes are the most booked accommodation type.

---
## **4. Running the Project**

### **Step 1: Clone the Repository**
```bash
git clone https://github.com/mohibkhann/MStay-Data-Warehousing.git
cd MStay-Data-Warehousing
```

### **Step 2: Execute SQL Scripts**
- **Run Data Cleaning:**
```sql
SOURCE data_cleaning.sql;
```
- **Create Star Schema:**
```sql
SOURCE schema_design.sql;
```
- **Run Data Analysis Queries:**
```sql
SOURCE data_analysis.sql;
```

---
## **Conclusion**
This project demonstrates a structured approach to **data cleaning, warehousing, and analytics** for a real-world **accommodation booking system**. It applies best practices in **database optimization and business intelligence.**


---
**Author:** Mohib Ali Khan   
**Year:** 2024  



