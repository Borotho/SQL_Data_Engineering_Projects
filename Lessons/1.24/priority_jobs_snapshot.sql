----CREATE TEMP TABLE 
-- Create TEMP Table
CREATE OR REPLACE TEMP TABLE src_priority_jobs AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name             AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP   AS loaded_at
FROM data_jobs.job_postings_fact AS jpf
    LEFT JOIN data_jobs.company_dim AS cd
        ON jpf.company_id = cd.company_id
    INNER JOIN jobs_mart.staging.priority_roles AS r
        ON jpf.job_title_short = r.role_name;

/*-- UPDATE statement
UPDATE my_db.priority_jobs_snapshot AS tgt
SET
    priority_lvl    = src.priority_lvl,
    updated_at  = CURRENT_TIMESTAMP          -- ← fixed
FROM src_priority_jobs AS src
WHERE tgt.job_id = src.job_id
    AND tgt.priority_lvl IS DISTINCT FROM src.priority_lvl;


----INSERT STATEMENT
INSERT OR IGNORE INTO jobs_mart.staging.priority_roles(role_id,role_name,priority_lvl)
VALUES
(1, 'Data Engineer', 1),
(2, 'Senior Data Engineer', 1),
(3, 'Software Engineer', 3)
(4, 'Data Scientist', 3);


-----DELETE STATEMENT 
DELETE FROM main.priority_jobs_snapshot AS tgt
WHERE NOT EXISTS (
    SELECT 1
    FROM src_priority_jobs AS src
    WHERE src.job_id = tgt.job_id
);*/


----MERGE INTO-----
MERGE

----FINAL-----
SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM my_db.main.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;


