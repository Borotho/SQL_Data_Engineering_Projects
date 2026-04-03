------batch-----continuous processing -------
-------Merge statement-----

------priorit table load ----
CREATE OR REPLACE TABLE staging.priority_roles(
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR,
    priority_lvl INTEGER
);

INSERT OR IGNORE INTO jobs_mart.staging.priority_roles(role_id,role_name,priority_lvl)
VALUES
(1, 'Data Engineer', 1),
(2, 'Senior Data Engineer', 1),
(3, 'Software Engineer', 3);

SELECT*FROM jobs_mart.staging.priority_roles;