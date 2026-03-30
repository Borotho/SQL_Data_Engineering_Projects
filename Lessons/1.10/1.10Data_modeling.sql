"""SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    Company_id
FROM
    job_postings_fact
LIMIT 10;"""

"""SELECT
    *
FROM
    Company_dim
WHERE
    name IN ('Facebook','Meta');"""




"""SELECT
    *
FROM skills_dim
LIMIT 5;"""


"""SELECT*
FROM information_schema.tables
WHERE table_catalog = 'data_jobs';"""

PRAGMA show_tables_expanded;---check tables

DESCRIBE job_postings_fact; ---describing tables
