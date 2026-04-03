
SELECT[1,2,3];
SELECT['PYTHON','SQL','R'] AS skills_array;



SELECT 'python' AS skill
UNION ALL
SELECT 'sql'
UNION ALL 
SELECT 'r';

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL 
    SELECT 'r'
)
SELECT ARRAY_AGG (skill) AS skills_array
FROM skills;



WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
)
SELECT
    skills[1] AS first_skill,
    skills[2] AS second_skill,
    skills[3] AS third_skill
FROM skills_array;


WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;
```

**What it does:**

**`skill_table` CTE** builds this:

| skills | types |
|---|---|
| python | programming |
| sql | query_language |
| r | programming |

**`STRUCT_PACK`** (DuckDB-specific) packs each row's columns into a named struct:
```
{'skill': 'python', 'type': 'programming'}
{'skill': 'sql',    'type': 'query_language'}
{'skill': 'r',      'type': 'programming'}



-- Array of Structs
SELECT [
  { skill: 'python', type: 'programming' },
  { skill: 'sql', type: 'query_language' }
] AS skills_array_of_structs;




WITH skill_table AS (
    SELECT 'python' AS skills, 'programming' AS types
    UNION ALL
    SELECT 'sql', 'query_language'
    UNION ALL
    SELECT 'r', 'programming'
)
SELECT
    ARRAY_AGG(
        STRUCT_PACK(
            skill := skills,
            type := types
        )
    )
FROM skill_table;




CREATE OR REPLACE TEMP TABLE job_skills_array AS 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY ALL;


SELECT
    sd.skills,
    COUNT(jpf.job_id)                           AS job_count,
    ROUND(MEDIAN(jpf.salary_year_avg), 2)       AS median_salary
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
WHERE jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY median_salary DESC;


-- From the perspective of a Data Analyst, analyze the median salary per skill

WITH skills AS (
    SELECT 'python' AS skill
    UNION ALL
    SELECT 'sql'
    UNION ALL
    SELECT 'r'
), skills_array AS (
    SELECT ARRAY_AGG(skill) AS skills
    FROM skills
)
SELECT
    UNNEST(skills)
FROM skills_array;


SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    UNNEST(skills_array) AS skill
FROM job_skills_array
LIMIT 20;

WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_array) AS skill
    FROM job_skills_array
)
SELECT
    skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC;
```

This is the **complete median salary per skill pipeline** — everything from the previous steps combined:
```
job_skills_array          flat_skills (CTE)            Final result
(array per job)    →      (one row per skill)    →      (median per skill)

job_id | skills_array       job_id | skill              skill  | median_salary
1      | [python, sql]  →   1      | python         →   python | 95000
                            1      | sql                sql    | 88000