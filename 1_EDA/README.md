# Data Engineering Job Market Analysis

An SQL-based analysis of the remote data engineering job market, exploring which skills offer the best combination of demand, salary, and career value. Built using DuckDB against a dataset of real job postings.

![Project Overview](1_EDA\images\Workflow.png)

> Data Engineering Job Postings (via MotherDuck / DuckDB OLAP engine) → 3 SQL analytics scripts → insights on top demanded, highest paying, and most optimal skills.

---

## Project Goals

- Identify the most in-demand skills for remote data engineer roles
- Uncover which skills command the highest median salaries
- Surface the most *optimal* skills — those that balance both demand and pay
- Provide actionable, data-backed guidance for skill development priorities

---

## Database Schema

![Data Warehouse Schema](1_EDA\images\1_2_Data_Warehouse.png)

The warehouse follows a star schema. `job_postings_fact` is the central fact table, joined to `company_dim` via `company_id`, and to `skills_dim` via the bridge table `skills_job_dim`. All queries in this project join across `job_postings_fact`, `skills_job_dim`, and `skills_dim` using `INNER JOIN` on `job_id` and `skill_id`.

---

## Queries

### Query 1 — Most In-Demand Skills

Counts job postings per skill for remote Data Engineer roles to identify what the market requires most.

```sql
SELECT
    sd.skills,
    COUNT(*) AS demand_count
FROM job_postings_fact    AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id   = sjd.job_id
INNER JOIN skills_dim     AS sd  ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short        = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 10;
```

**Results:**

| Skill       | Demand Count |
|-------------|--------------|
| sql         | 29,221       |
| python      | 28,776       |
| aws         | 17,823       |
| azure       | 14,143       |
| spark       | 12,799       |
| airflow     | 9,996        |
| snowflake   | 8,639        |
| databricks  | 8,183        |
| java        | 7,267        |
| gcp         | 6,446        |

---

### Query 2 — Highest-Paying Skills

Calculates the median salary per skill for remote Data Engineer roles with specified salaries. Median is used over average to resist distortion from outlier compensation packages.

```sql
SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg)) AS median_salary,
    COUNT(*)                           AS skill_count
FROM job_postings_fact    AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id   = sjd.job_id
INNER JOIN skills_dim     AS sd  ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short        = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg    IS NOT NULL
GROUP BY sd.skills
HAVING COUNT(*) >= 100
ORDER BY median_salary DESC
LIMIT 25;
```

> The `HAVING COUNT(*) >= 100` threshold filters out niche skills with too few postings to produce a reliable median.

**Top 10 results:**

| Skill      | Median Salary |
|------------|---------------|
| rust       | $210,000      |
| terraform  | $184,000      |
| golang     | $184,000      |
| spring     | $175,500      |
| neo4j      | $170,000      |
| gdpr       | $169,616      |
| graphql    | $167,500      |
| mongo      | $162,250      |
| fastapi    | $157,500      |
| bitbucket  | $155,000      |

---

### Query 3 — Most Optimal Skills

Combines demand and salary into a single score using a natural log transformation. This prevents high-volume skills (e.g. SQL with 29k postings) from drowning out well-paid but moderately common skills (e.g. Terraform with 193 postings).

**Scoring formula:**

```
optimal_score = LN(demand_count) × median_salary / 1,000,000
```

```sql
SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg))                     AS median_salary,
    COUNT(*)                                               AS demand_count,
    ROUND(
        (LN(COUNT(*)) * MEDIAN(jpf.salary_year_avg)) / 1000000.0
    , 2)                                                   AS optimal_score,
    ROUND(LN(COUNT(*)), 1)                                 AS ln_demand_count
FROM job_postings_fact    AS jpf
INNER JOIN skills_job_dim AS sjd ON jpf.job_id   = sjd.job_id
INNER JOIN skills_dim     AS sd  ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short        = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg    IS NOT NULL
GROUP BY sd.skills
HAVING COUNT(*) >= 100
ORDER BY optimal_score DESC
LIMIT 25;
```

**Top results:**

| Skill       | Median Salary | Demand Count | Optimal Score |
|-------------|---------------|--------------|---------------|
| terraform   | $184,000      | 193          | 0.96          |
| python      | $135,000      | 1,100+       | 0.94          |
| sql         | $130,000      | 1,100+       | 0.91          |
| aws         | $137,000      | 783          | 0.90          |
| spark       | $140,000      | 503          | 0.88          |
| airflow     | $150,000      | 386          | 0.88          |
| kafka       | $145,000      | 292          | 0.85          |
| kubernetes  | $150,500      | 202          | 0.83          |

---

## Key Findings

### SQL and Python are the bedrock
With nearly 29,000 postings each, SQL and Python are required at roughly double the rate of any other skill. They are non-negotiable for remote data engineering roles.

### Cloud platforms are table stakes
AWS (~18k postings), Azure (~14k), and GCP (~6.4k) collectively dominate the middle tier of demand. Fluency in at least one major cloud provider is expected in the majority of remote roles.

### Terraform is the hidden gem
Terraform tops the optimal score ranking — commanding a $184k median salary while appearing in nearly 200 postings. It offers the best return on learning investment of any skill with sufficient market presence.

### Orchestration and big data tools are growing
Airflow (9,996 postings, $150k median) and Spark (12,799 postings, $140k median) appear in both the demand and salary top tiers. These are strong secondary skills after the cloud/SQL/Python foundation.

### High-salary outliers need context
Skills like Rust ($210k) and Golang ($184k) lead the raw salary rankings but appear in far fewer postings. They reward specialisation but offer a narrower job market.

---

## Methodology Notes

- All salary analysis filters for `salary_year_avg IS NOT NULL` to ensure COUNT and MEDIAN operate on the same population
- `MEDIAN` is preferred over `AVG` throughout to reduce distortion from extreme compensation packages
- The `HAVING COUNT(*) >= 100` threshold is applied to salary queries to ensure statistical reliability
- The `LN()` transformation in the optimal score dampens the outsized influence of ultra-high-demand skills, surfacing well-compensated skills that might otherwise be buried

---

## Tools Used

- **DuckDB** — SQL engine
- **SQL** — all analysis
- Dataset: job postings fact table with skills dimension tables

## SQL Skills Demonstrated
Query Design & Optimization
Complex Joins: Multi-table INNER JOIN operations across job_postings_fact, skills_job_dim, and skills_dim
Aggregations: COUNT(), MEDIAN(), ROUND() for statistical analysis
Filtering: Boolean logic with WHERE clauses and multiple conditions (job_title_short, job_work_from_home, salary_year_avg IS NOT NULL)
Sorting & Limiting: ORDER BY with DESC and LIMIT for top-N analysis

## Data Analysis Techniques
Grouping: GROUP BY for categorical analysis by skill
Mathematical Functions: LN() for natural logarithm transformation to normalize demand metrics
Calculated Metrics: Derived optimal score combining log-transformed demand with median salary
HAVING Clause: Filtering aggregated results (skills with >= 100 postings)
NULL Handling: Proper filtering of incomplete records (salary_year_avg IS NOT NULL)