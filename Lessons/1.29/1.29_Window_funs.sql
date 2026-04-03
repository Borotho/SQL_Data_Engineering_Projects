-----important for aggg-----

-----Count rows- aggregation only 

SELECT
    COUNT(*)
FROM 
    job_postings_fact;


----Count rows-window function--- 

SELECT
    job_id,
    COUNT(*) OVER ()---WINDOW FUN
FROM 
    job_postings_fact


------PARTITION BY -----
SELECT
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER (
        PARTITION BY job_title_short,company_id
    ) AS avg_hourly_by_title
FROM job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY
    RANDOM()
LIMIT 10;


SELECT
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER (
        ORDER BY job_posted_date
    ) AS rank_hourly_salary_by_title
FROM job_postings_fact
WHERE
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg,
    job_posted_date
LIMIT 10;

-----navigation-----
SELECT 
    job_id,
    company_id,                          -- missing comma added
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS previous_posting_salary,        -- missing comma added
    salary_year_avg - LAG(salary_year_avg) OVER (
        PARTITION BY company_id
        ORDER BY job_posted_date
    ) AS salary_change                   -- trailing comma removed
FROM 
    job_postings_fact
WHERE salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;  
