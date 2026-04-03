
-----CTAS--SNAP SHOT----
----SET search_path = data_jobs;

-----CREATE SCHEMA jobs_mart.staging;

CREATE OR REPLACE TABLE jobs_mart.staging.job_postings_flat AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.job_title,
    jpf.job_location,
    jpf.job_via,
    jpf.job_schedule_type,
    jpf.job_work_from_home,
    jpf.search_location,
    jpf.job_posted_date,
    jpf.job_no_degree_mention,
    jpf.job_health_insurance,
    jpf.job_country,
    jpf.salary_rate,
    jpf.salary_year_avg,
    jpf.salary_hour_avg,
    cd.name AS company_name
FROM data_jobs.job_postings_fact AS jpf
LEFT JOIN data_jobs.company_dim AS cd
    ON jpf.company_id = cd.company_id;


SELECT COUNT(*) 
FROM jobs_mart.staging.job_postings_flat 
LIMIT 10;

-----VIEW----LIVE----

CREATE OR REPLACE VIEW jobs_mart.staging.priority_jobs_flat_view AS
SELECT
    jpf.*
FROM jobs_mart.staging.job_postings_flat AS jpf
JOIN jobs_mart.staging.priority_roles AS r
    ON jpf.job_title_short = r.role_name
WHERE r.priority_lvl=1;

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM jobs_mart.staging.priority_jobs_flat_view
GROUP BY job_title_short
ORDER BY job_count DESC;

/*SELECT schema_name 
FROM information_schema.schemata;*/
----.read Lessons/1.22_DDL_DML_Pt2.sql----

------CREATE TEMP TABLE------NO SCHEMA
CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
SELECT*
FROM jobs_mart.staging.priority_jobs_flat_view
WHERE job_title_short='Senior Data Engineer';

SELECT 
    job_title_short,
    COUNT(*) AS job_count
FROM senior_jobs_flat_temp 
GROUP BY job_title_short
ORDER BY job_count DESC;

---DELETE SPECIFIC ROWS-----
----TRUNCATE----KEEPS THE SCHEMA---EMPTY THE ROWS....
-----DROP---REMOVES SCHEMA AND DATA------

SELECT COUNT(*) FROM jobs_mart.staging.job_postings_flat;
SELECT COUNT(*) FROM jobs_mart.staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

DELETE FROM jobs_mart.staging.job_postings_flat---- WHERE
WHERE job_posted_date <'2024-01-01';

SELECT COUNT(*) FROM jobs_mart.staging.job_postings_flat;
SELECT COUNT(*) FROM jobs_mart.staging.priority_jobs_flat_view;
SELECT COUNT(*) FROM senior_jobs_flat_temp;

