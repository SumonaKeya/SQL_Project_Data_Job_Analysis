-- This query retrieves the top 10 highest paying Data Analyst jobs located 'Anywhere'
-- with a non-null average yearly salary from the job_postings_fact table,
-- joining with the company_dim table to get the company name.
-- The results are ordered by average yearly salary in descending order.
-- SQL Query:


SELECT job_id, job_title, job_location,
job_schedule_type, salary_year_avg,job_posted_date,
name as company_name

FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
where job_title_short = 'Data Analyst' AND job_location = 'Anywhere' AND
salary_year_avg is not null
ORDER BY salary_year_avg DESC
LIMIT 10;