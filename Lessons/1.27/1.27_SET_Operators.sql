
-----UNION ALL(DPILCATES PRESEVED)----
SELECT UNNEST([1,1,1,2])----CREATE A LIST AND TURN IT INTO ROWS 
UNION ALL
SELECT UNNEST([1,1,3]);

INTERSECT----

EXCEPT ALL


DROP TABLE IF EXISTS jobs_2023;
CREATE TEMP TABLE jobs_2023 AS 
SELECT*EXCLUDE(job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date)=2023;

SELECT* FROM jobs_2023;

DROP TABLE IF EXISTS jobs_2024;
CREATE TEMP TABLE jobs_2024 AS 
SELECT*EXCLUDE(job_id, job_posted_date)
FROM job_postings_fact
WHERE EXTRACT(YEAR FROM job_posted_date)=2024;

SELECT* FROM jobs_2024;


---which unique job postings appeared in either 2023 or 2024 ?

SELECT 
    'jobs_2023' AS table_name,
    Count(*) 
FROM jobs_2023
UNION
SELECT 
    'jobs_2024' AS table_name,
    Count(*) 
FROM jobs_2024;

---which job postings appaered across both years, counting duplicates? 
SELECT 
    'jobs_2023' AS table_name,
    Count(*) 
FROM jobs_2023
UNION ALL
SELECT 
    'jobs_2024' AS table_name,
    Count(*) 
FROM jobs_2024;

--which job postings appaered 2023 not 2024 ? 

SELECT*
FROM jobs_2023
EXCEPT
SELECT * FROM jobs_2024;

---Which job postings from 2023 after subtracting matching 2024 postings, one for one ? 
SELECT*
FROM jobs_2023
EXCEPT ALL 
SELECT * FROM jobs_2024;

----which job postings appeared in both  2023 and 2024 ? 
SELECT*
FROM jobs_2023
INTERSECT 
SELECT * FROM jobs_2024;

-----Which job postings appeared in both years, preserving duplicate counts ? 
SELECT*
FROM jobs_2023
INTERSECT ALL 
SELECT * FROM jobs_2024;