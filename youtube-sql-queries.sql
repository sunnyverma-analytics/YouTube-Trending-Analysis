CREATE TABLE sheet(
    video_id TEXT,
    trending_date TEXT,
    title TEXT,
    channel_title TEXT,
    category_id TEXT,
    publish_time TEXT,
    views TEXT,
    likes TEXT,
    dislikes TEXT,
    comment_count TEXT,
    engagement_rate TEXT,
    like_rate TEXT,
    comment_rate TEXT
);

COPY sheet FROM 'D:\sheet.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM sheet;


/*====================================================
 Youtube Trending Content Analysis: SQL Business Insights
====================================================*/

/*----------------------------------------------------
 SECTION 1 : DATASET OVERVIEW
----------------------------------------------------*/
--1. How large is the trending video dataset?--
SELECT COUNT(*) AS total_videos
FROM sheet;

/*----------------------------------------------------
 SECTION 2 : AUDIENCE REACH & ENGAGEMENT
-----------------------------------------------------*/

--1.Which videos generated the highest audience reach?--
SELECT title,
       views::BIGINT AS views
FROM sheet
ORDER BY views::BIGINT DESC
LIMIT 10;

--2.Which videos received the strongest audience appreciation?--
SELECT title,
       likes::BIGINT AS likes
FROM sheet
ORDER BY likes::BIGINT DESC
LIMIT 10;

--3.Which category has the highest engagement?--
SELECT category_id,
       AVG(engagement_rate::NUMERIC) AS avg_engagement
FROM sheet
GROUP BY category_id
ORDER BY avg_engagement DESC;


--4.Which videos achieved high reach but failed to engage viewers?--
SELECT title,
       views::BIGINT,
       engagement_rate::NUMERIC
FROM sheet
WHERE views::BIGINT > 1000000
AND engagement_rate::NUMERIC < 2;

--5.Which videos achieved viral-scale reach?--
SELECT title, channel_title, views
FROM sheet
WHERE views::BIGINT > 1000000
ORDER BY views::BIGINT DESC;

--6.Which trending videos failed to generate audience discussion?--
SELECT title, channel_title, views
FROM sheet
WHERE comment_count = '0';

--7.Which videos received the highest negative audience reaction?--
SELECT title, channel_title, dislikes
FROM sheet
ORDER BY dislikes DESC
LIMIT 10;

--8.What is the overall engagement performance of trending content?-
SELECT AVG(engagement_rate::NUMERIC) AS avg_engagement_rate
FROM sheet;

--9.Which videos were most successful at driving audience interaction?--
SELECT title,
       engagement_rate
FROM sheet
ORDER BY engagement_rate DESC
LIMIT 10;

/*----------------------------------------------------
 SECTION 3: Channel Performance Analysis
-----------------------------------------------------*/

--1.Which channels generate the highest audience approval?--
SELECT channel_title, SUM(CAST(likes AS BIGINT)) AS total_likes
FROM sheet
GROUP BY channel_title
ORDER BY total_likes DESC
LIMIT 10;

--2.What is the best-performing video for each channel?--
WITH ranked_videos AS (SELECT
        channel_title,
        title,
        views::BIGINT,
        ROW_NUMBER() OVER (
            PARTITION BY channel_title
            ORDER BY views::BIGINT DESC
        ) AS rn
    FROM sheet)
SELECT
    channel_title,title,views
FROM ranked_videos
WHERE rn = 1;

--3.Which channels captured the largest share of audience attention?--
SELECT channel_title,
       SUM(CAST(views AS BIGINT)) AS total_views
FROM sheet
GROUP BY channel_title
ORDER BY total_views DESC
LIMIT 10;

--4.Which channels appeared most frequently in trending content?--
SELECT channel_title,
       COUNT(*) AS video_count
FROM sheet
GROUP BY channel_title
ORDER BY video_count DESC
LIMIT 10;

--5.Which channels dominate the trending ecosystem?--
SELECT channel_title,
       COUNT(*) AS trending_count
FROM sheet
GROUP BY channel_title
ORDER BY trending_count DESC;

--6.Which channels consistently perform well?--
SELECT channel_title,
       AVG(views::BIGINT) AS avg_views
FROM sheet
GROUP BY channel_title
HAVING COUNT(*) >= 5
ORDER BY avg_views DESC;

/*----------------------------------------------------
 SECTION 4: Category Performance Analysis
----------------------------------------------------*/

--1.Which category has the highest engagement?--
SELECT category_id,
       AVG(engagement_rate::NUMERIC) AS avg_engagement
FROM sheet
GROUP BY category_id
ORDER BY avg_engagement DESC;

--2.Which categories contribute most to total platform viewership?--
SELECT category_id,
       SUM(views::BIGINT) AS total_views
FROM sheet
GROUP BY category_id
ORDER BY total_views DESC;

--3..Which content categories contribute the most views?--
SELECT category_id,
       SUM(views::BIGINT) AS total_views
FROM sheet
GROUP BY category_id
ORDER BY total_views DESC;

--4.Which content categories attract the highest average viewership?--
SELECT
    category_id,
    COUNT(*) AS total_videos,
    AVG(views::BIGINT) AS avg_views
FROM sheet
GROUP BY category_id
ORDER BY avg_views DESC;

/*----------------------------------------------------
 SECTION 5: Advanced SQL Analysis
----------------------------------------------------*/

--1.How do videos rank based on audience reach?--
SELECT 
    title,
    channel_title,
    views,
    RANK() OVER (ORDER BY views DESC) AS rank
FROM sheet;

--2.Which videos lead their respective content categories?--
SELECT 
    title,
    category_id,
    views,
    RANK() OVER (PARTITION BY category_id ORDER BY views DESC) AS rank_in_category
FROM sheet;




