SELECT LENGTH ('Data');

SELECT LOWER ('DATA');

SELECT LEFT ('DATA',1);
SELECT RIGHT ('DATA',1);

SELECT SUBSTRING ('DATA',1,1);

SELECT CONCAT('Data', ' ','Engineer');

SELECT TRIM (' Data');

SELECT REPLACE ('Cata', 'C','D'); 

SELECT REGEXP_REPLACE('data.nerd@gmail.com', '^.*(@)', '\1');



-------
WITH title_lower AS (
    SELECT
        job_title,
        LOWER(TRIM(job_title)) AS job_title_clean
    FROM job_postings_fact
)

SELECT
    job_title,
    CASE
     WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%analyst%'   THEN 'Data Analyst'
     WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
     WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%engineer%'  THEN 'Data Engineer'
     ELSE 'Other'
    END AS job_title_category
FROM  title_lower
ORDER BY RANDOM()
LIMIT 30;


------NULL FUN------
SELECT NULLIF(10,20);
SELECT COALESCE(NULL,1,0,NULL,3);---RETURNS FIRST NONE NULL VALUE.

SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2080)
FROM
    job_postings_fact
WHERE salary_hour_avg IS NOT NULL OR salary_year_avg IS NOT NULL
LIMIT 10;