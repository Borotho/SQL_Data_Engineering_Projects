---- Left join, All rows from first table, matching rows from second table. 
"""SELECT
    jpf.*,
    cd.*
 FROM 
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
LIMIT 10;"""

---Specifying cols ----
"""SELECT
    job_id,
    jpf.company_id,
    job_title_short,
    name AS company_name,
    jpf.job_location
 FROM 
    job_postings_fact AS jpf 
LEFT JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
LIMIT 10;"""


----Right join, LESS COMMON-----
"""SELECT
    job_id,
    jpf.company_id,
    job_title_short,
    name AS company_name,
    jpf.job_location
 FROM 
    job_postings_fact AS jpf 
Right JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
LIMIT 10;"""


----Inner join, only matching tables in two tables.
"""SELECT
    job_id,
    jpf.company_id,
    job_title_short,
    name AS company_name,
    jpf.job_location
 FROM 
    job_postings_fact AS jpf 
INNER JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
LIMIT 10;"""

----Full outer join----
"""SELECT
    job_id,
    jpf.company_id,
    job_title_short,
    name AS company_name,
    jpf.job_location
 FROM 
    job_postings_fact AS jpf 
Full OUTER JOIN company_dim AS cd 
    ON jpf.company_id = cd.company_id
LIMIT 10;"""

------conecting tables, creating relationships ----
----Left join 
"""SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
LEFT JOIN skillS_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
LEFT JOIN skillS_dim AS sd 
    ON sjd.skill_id = sd.skill_id;"""


---Inner join
SELECT
    jpf.job_id,
    jpf.job_title_short,
    sjd.skill_id,
    sd.skills
FROM job_postings_fact AS jpf
INNER JOIN skillS_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skillS_dim AS sd 
    ON sjd.skill_id = sd.skill_id;