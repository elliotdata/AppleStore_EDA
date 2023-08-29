/* Create the database if it doesn't exist */
CREATE DATABASE IF NOT EXISTS app_store;
USE app_store;

/* Create the AppData table */
CREATE TABLE AppData (
    id INT,
    track_name VARCHAR(255),
    size_bytes BIGINT,
    currency VARCHAR(10),
    price DECIMAL(10, 2),
    rating_count_tot INT,
    rating_count_ver INT,
    user_rating DECIMAL(3, 1),
    user_rating_ver DECIMAL(3, 1),
    ver VARCHAR(20),
    cont_rating VARCHAR(10),
    prime_genre VARCHAR(50),
    sup_devices_num INT,
    ipadSc_urls_num INT,
    lang_num INT,
    vpp_lic INT
);

/* Load data from CSV into AppData table */
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AppleStore.csv'
INTO TABLE AppData
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* View the first 20 rows of data to check if data has loaded */
SELECT *
FROM AppData
LIMIT 20;

/* The number of unique apps in the AppData table */
SELECT COUNT(DISTINCT id) AS UniqueAppID
FROM AppData;

/* Checking for missing values */
SELECT COUNT(*) AS MissingValues
FROM AppData
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

/* Exploratory Data Analysis */

/* The number of apps per genre */
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppData
GROUP BY prime_genre
ORDER BY NumApps DESC;

/* An overview of the apps' ratings by genre */
SELECT prime_genre, MIN(user_rating) AS MinRating, MAX(user_rating) AS MaxRating, AVG(user_rating) AS AvgRating
FROM AppData
GROUP BY prime_genre
ORDER BY AvgRating DESC;

/* Average rating of free apps over paid apps */
SELECT
    CASE
        WHEN price > 0 THEN 'Paid'
        ELSE 'FREE'
    END AS App_Type,
    AVG(user_rating) AS Avg_Rating
FROM AppData
GROUP BY App_Type;

/* Genres with low ratings */
SELECT prime_genre, AVG(user_rating) AS Avg_Rating
FROM AppData
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10;

/* Top-rated apps for each genre */
SELECT track_name, prime_genre, user_rating
FROM (
    SELECT prime_genre, track_name, user_rating,
           RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS GenreRank
    FROM AppData
) AS a
WHERE a.GenreRank = 1;

/* Market Insights */

/* The most popular app categories based on the number of apps */
SELECT prime_genre, COUNT(*) AS num_apps
FROM AppData
GROUP BY prime_genre
ORDER BY num_apps DESC;

/* Monetization Strategies: Revenue Market Share by Genre and Currency */
SELECT prime_genre, SUM(price) AS total_revenue, currency
FROM AppData
GROUP BY currency, prime_genre
ORDER BY total_revenue DESC;

/* Mistake Trends from Developers: Relationship between version updates and ratings */
SELECT common_mistake, AVG(user_rating) AS avg_rating, COUNT(*) AS num_apps
FROM (
    SELECT CASE
        WHEN rating_count_ver = 1 AND user_rating < 3 THEN 'Low-rated single-update'
        WHEN rating_count_ver > 1 AND user_rating < 3 THEN 'Low-rated multiple-updates'
        WHEN rating_count_ver > 1 AND user_rating >= 3 THEN 'High-rated multiple-updates'
        ELSE 'Other'
    END AS common_mistake, user_rating
    FROM AppData
) AS mistakes
GROUP BY common_mistake
ORDER BY avg_rating;

/* App Ratings and Reviews: Average User Ratings by App Version */
SELECT ver, AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY ver
ORDER BY ver;

/* Average price distribution within different genres */
SELECT prime_genre, AVG(price) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM AppData
GROUP BY prime_genre
ORDER BY avg_price DESC;

/* User rating distribution by content rating */
SELECT cont_rating, AVG(user_rating) AS avg_rating, COUNT(*) AS num_apps
FROM AppData
GROUP BY cont_rating
ORDER BY avg_rating DESC;

/* Average user rating based on the number of supported languages */
SELECT lang_num, AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY lang_num
ORDER BY lang_num;

/* User rating and app size relationship */
SELECT
    CASE
        WHEN size_bytes < 1000000 THEN 'Small (<1MB)'
        WHEN size_bytes BETWEEN 1000000 AND 50000000 THEN 'Medium (1MB-50MB)'
        ELSE 'Large (>50MB)'
    END AS size_category,
    AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY size_category;

/* Timeline of average user ratings for different app versions */
SELECT ver, AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY ver
ORDER BY ver;

/* Distribution of languages used in apps within different genres */
SELECT prime_genre, lang_num, COUNT(*) AS num_apps
FROM AppData
GROUP BY prime_genre, lang_num
ORDER BY num_apps DESC;
/* Create the database if it doesn't exist */
CREATE DATABASE IF NOT EXISTS app_store;
USE app_store;

/* Create the AppData table */
CREATE TABLE AppData (
    id INT,
    track_name VARCHAR(255),
    size_bytes BIGINT,
    currency VARCHAR(10),
    price DECIMAL(10, 2),
    rating_count_tot INT,
    rating_count_ver INT,
    user_rating DECIMAL(3, 1),
    user_rating_ver DECIMAL(3, 1),
    ver VARCHAR(20),
    cont_rating VARCHAR(10),
    prime_genre VARCHAR(50),
    sup_devices_num INT,
    ipadSc_urls_num INT,
    lang_num INT,
    vpp_lic INT
);

/* Load data from CSV into AppData table */
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AppleStore.csv'
INTO TABLE AppData
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

/* View the first 20 rows of data to check if data has loaded */
SELECT *
FROM AppData
LIMIT 20;

/* The number of unique apps in the AppData table */
SELECT COUNT(DISTINCT id) AS UniqueAppID
FROM AppData;

/* Checking for missing values */
SELECT COUNT(*) AS MissingValues
FROM AppData
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;

/* Exploratory Data Analysis */

/* The number of apps per genre */
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppData
GROUP BY prime_genre
ORDER BY NumApps DESC;

/* An overview of the apps' ratings by genre */
SELECT prime_genre, MIN(user_rating) AS MinRating, MAX(user_rating) AS MaxRating, AVG(user_rating) AS AvgRating
FROM AppData
GROUP BY prime_genre
ORDER BY AvgRating DESC;

/* Average rating of free apps over paid apps */
SELECT
    CASE
        WHEN price > 0 THEN 'Paid'
        ELSE 'FREE'
    END AS App_Type,
    AVG(user_rating) AS Avg_Rating
FROM AppData
GROUP BY App_Type;

/* Genres with low ratings */
SELECT prime_genre, AVG(user_rating) AS Avg_Rating
FROM AppData
GROUP BY prime_genre
ORDER BY Avg_Rating ASC
LIMIT 10;

/* Top-rated apps for each genre */
SELECT track_name, prime_genre, user_rating
FROM (
    SELECT prime_genre, track_name, user_rating,
           RANK() OVER (PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS GenreRank
    FROM AppData
) AS a
WHERE a.GenreRank = 1;

/* Market Insights */

/* The most popular app categories based on the number of apps */
SELECT prime_genre, COUNT(*) AS num_apps
FROM AppData
GROUP BY prime_genre
ORDER BY num_apps DESC;

/* Monetization Strategies: Revenue Market Share by Genre and Currency */
SELECT prime_genre, SUM(price) AS total_revenue, currency
FROM AppData
GROUP BY currency, prime_genre
ORDER BY total_revenue DESC;

/* Mistake Trends from Developers: Relationship between version updates and ratings */
SELECT common_mistake, AVG(user_rating) AS avg_rating, COUNT(*) AS num_apps
FROM (
    SELECT CASE
        WHEN rating_count_ver = 1 AND user_rating < 3 THEN 'Low-rated single-update'
        WHEN rating_count_ver > 1 AND user_rating < 3 THEN 'Low-rated multiple-updates'
        WHEN rating_count_ver > 1 AND user_rating >= 3 THEN 'High-rated multiple-updates'
        ELSE 'Other'
    END AS common_mistake, user_rating
    FROM AppData
) AS mistakes
GROUP BY common_mistake
ORDER BY avg_rating;

/* App Ratings and Reviews: Average User Ratings by App Version */
SELECT ver, AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY ver
ORDER BY ver;

/* Average price distribution within different genres */
SELECT prime_genre, AVG(price) AS avg_price, MIN(price) AS min_price, MAX(price) AS max_price
FROM AppData
GROUP BY prime_genre
ORDER BY avg_price DESC;

/* User rating distribution by content rating */
SELECT cont_rating, AVG(user_rating) AS avg_rating, COUNT(*) AS num_apps
FROM AppData
GROUP BY cont_rating
ORDER BY avg_rating DESC;

/* Average user rating based on the number of supported languages */
SELECT lang_num, AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY lang_num
ORDER BY lang_num;

/* User rating and app size relationship */
SELECT
    CASE
        WHEN size_bytes < 1000000 THEN 'Small (<1MB)'
        WHEN size_bytes BETWEEN 1000000 AND 50000000 THEN 'Medium (1MB-50MB)'
        ELSE 'Large (>50MB)'
    END AS size_category,
    AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY size_category;

/* Timeline of average user ratings for different app versions */
SELECT ver, AVG(user_rating) AS avg_rating
FROM AppData
GROUP BY ver
ORDER BY ver;

/* Distribution of languages used in apps within different genres */
SELECT prime_genre, lang_num, COUNT(*) AS num_apps
FROM AppData
GROUP BY prime_genre, lang_num
ORDER BY num_apps DESC;
