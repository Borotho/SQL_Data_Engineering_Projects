- --Attach a writable DB for your work
-- CREATE (already fixed in your screenshot)
-- Option A: use my_db
-- All three statements target my_db.main
CREATE OR REPLACE TABLE my_db.main.priority_jobs_snapshot (
    job_id              INTEGER PRIMARY KEY,
    job_title_short     VARCHAR,
    company_name        VARCHAR,
    job_posted_date     TIMESTAMP,
    salary_year_avg     DOUBLE,
    priority_lvl        INTEGER,
    updated_at          TIMESTAMP
);

INSERT OR IGNORE INTO my_db.main.priority_jobs_snapshot(
    job_id,
    job_title_short,
    company_name,
    job_posted_date,
    salary_year_avg,
    priority_lvl,
    updated_at
)
SELECT
    jpf.job_id,
    jpf.job_title_short,
    cd.name AS company_name,
    jpf.job_posted_date,
    jpf.salary_year_avg,
    r.priority_lvl,
    CURRENT_TIMESTAMP
FROM data_jobs.main.job_postings_fact AS jpf
    LEFT JOIN data_jobs.main.company_dim AS cd
        ON jpf.company_id = cd.company_id
    INNER JOIN jobs_mart.staging.priority_roles AS r
        ON jpf.job_title_short = r.role_name;

SELECT
    job_title_short,
    COUNT(*) AS job_count,
    MIN(priority_lvl) AS priority_lvl,
    MIN(updated_at) AS updated_at
FROM my_db.main.priority_jobs_snapshot
GROUP BY job_title_short
ORDER BY job_count DESC;