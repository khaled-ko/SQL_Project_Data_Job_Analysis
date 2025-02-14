WITH
    top_demanded_skills
AS
    (
SELECT
    skills_dim.skills,
    count (job_title_short) as demand_count
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
AND
    job_work_from_home = TRUE
AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
    )
    , 
    top_paying_skills
as
    (
SELECT
    skills_dim.skills,
    round ( avg (salary_year_avg) ) as avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
AND
    job_work_from_home = TRUE
AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
    )

SELECT
    top_demanded_skills.skills,
    demand_count,
    avg_salary
FROM
    top_demanded_skills
INNER JOIN
    top_paying_skills on top_demanded_skills.skills = top_paying_skills.skills
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT
    25

-- short way of doing it

SELECT
    skills,
    count (job_title_short) as demand_count,
    round ( avg (salary_year_avg) ) as avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
AND
    job_work_from_home = TRUE
AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT
    25