---subquery---
SELECT *
FROM(
   SELECT*
   FROM job_postings_fact 
   WHERE salary_hour_avg IS NOT NULL
        OR salary_year_avg IS NOT NULL
)
LIMIT 10;


----CTE----SIMPLE -
WITH valid_salaries AS (
    SELECT*
   FROM job_postings_fact 
   WHERE salary_hour_avg IS NOT NULL
        OR salary_year_avg IS NOT NULL
)
----display---
SELECT *
FROM valid_salaries;

-- Show each job's salary next to the overall market median:
SELECT
    job_title_short,
    salary_year_avg,
    (SELECT ROUND(MEDIAN(salary_year_avg), 2)
     FROM job_postings_fact
     WHERE salary_year_avg IS NOT NULL) AS market_median
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL;

-- Stage only jobs that are remote before aggregating:
SELECT
    job_title_short,
    ROUND(MEDIAN(salary_year_avg), 2) AS median_salary
FROM (
    SELECT job_title_short, salary_year_avg
    FROM job_postings_fact
    WHERE job_work_from_home = TRUE
      AND salary_year_avg IS NOT NULL
) AS remote_jobs
GROUP BY job_title_short
ORDER BY median_salary DESC;

-- Keep only job titles whose median salary is above the overall median:
SELECT
    job_title_short,
    ROUND(MEDIAN(salary_year_avg), 2) AS avg_salary
FROM job_postings_fact
WHERE salary_year_avg IS NOT NULL
GROUP BY job_title_short
HAVING MEDIAN(salary_year_avg) > (
    SELECT MEDIAN(salary_year_avg)
    FROM job_postings_fact
    WHERE salary_year_avg IS NOT NULL
)
ORDER BY avg_salary DESC;

------CTEs----  WITH THEN AS ----
-----ONLY-----
 WITH title_median AS(
    SELECT
        job_title_short,
        job_work_from_home,
        MEDIAN (salary_year_avg) ::INT AS market_median_salary----CAST AS INTERGER
    FROM job_postings_fact
    WHERE job_country= 'South Africa'
    GROUP BY 
    job_title_short,
    job_work_from_home
 )

 SELECT
    r.job_title_short,
    r.market_median_salary AS remote_median_salary, 
    o.market_median_salary AS onsite_median_salary,
    (r.market_median_salary-o.market_median_salary) AS remote_premium
FROM title_median AS r
INNER JOIN title_median AS o
    ON r.job_title_short=o.job_title_short
WHERE 
    r.job_work_from_home=TRUE
    AND o.job_work_from_home=FALSE
ORDER BY remote_premium DESC;


-----subquery---WHERESEXISTS------
-----SOURCE----TARGET---TABLE---
SELECT *
FROM range(3) AS src(key);

SELECT *
FROM range(2) AS tgt(key);



SELECT *
FROM range(3) AS src(key)
WHERE EXISTS(
    SELECT 1
    FROM range(2) AS tgt(key)
    WHERE tgt.key=src.key
);


SELECT *
FROM job_postings_fact
ORDER BY
 job_id
LIMIT 10;

SELECT *
FROM skills_job_dim
ORDER BY
 job_id
LIMIT 40;

SELECT *
FROM job_postings_fact AS tgt
WHERE NOT EXISTS(
    SELECT 1
    FROM skills_job_dim AS src
    WHERE tgt.jOb_id=src.job_id
)
ORDER BY
 job_id;