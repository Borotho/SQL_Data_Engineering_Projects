--Describe
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'job_postings_fact';-----Use Describe on duck db

----Cast operator---- SAME AS ::
SELECT CAST (123 AS INTEGER);

SELECT
    CAST(jOB_id AS VARCHAR) || '-' || CAST(company_id AS VARCHAR), --"more" unique identifier 
    CAST(job_work_from_home AS INT) AS job_work_from_home, --from boolean to numeric value
    CAST(job_posted_date AS DATE) AS job_posted_date, ----from temestamp to date only
    CAST(salary_year_avg AS DECIMAL (10,0)) AS salary_year_avg ---from double to no decimal places
FROM 
    job_postings_fact

WHERE salary_year_avg IS NOT NULL
LIMIT 10;

