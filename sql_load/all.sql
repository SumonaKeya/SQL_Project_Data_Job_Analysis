SELECT *
FROM skills_job_dim
LIMIT 100;

--Query to change timezone of job_posted_date to date only
SELECT 
job_title_short AS Title,
job_location AS Location,
job_posted_date::DATE AS Date
FROM job_postings_fact

---query to change timezone
SELECT 
job_title_short AS Title,
job_location AS Location,
job_posted_date At Time Zone 'UTC' At Time Zone 'EST'  AS Date
FROM job_postings_fact
LIMIT 10;

---query to Extract year and month from job_posted_date

SELECT 
job_title_short AS Title,
job_location AS Location,
job_posted_date At Time Zone 'UTC' At Time Zone 'EST'  AS Date_time,
EXTRACT(YEAR FROM job_posted_date ) AS Year,
EXTRACT(MONTH FROM job_posted_date ) AS Month
FROM job_postings_fact
LIMIT 10;

--query to aggregating count number of job postings for Data Scientist by month
SELECT 
COUNT (job_id) as job_posted_count,
EXTRACT(MONTH from job_posted_date ) AS Month
FROM job_postings_fact
WHERE job_title_short = 'Data Scientist'
GROUP BY Month
ORDER BY job_posted_count DESC;

--query to filter job postings in January
CREATE table january_jobs AS
SELECT * FROM job_postings_fact
WHERE EXTRACT (MONTH from job_posted_date ) = 1;

---query to filter job postings in February
CREATE TABLE february_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

---query to filter job postings in March
CREATE TABLE march_jobs AS
SELECT *
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date) = 3;


SELECT * FROM january_jobs;

--query to standardize job location
SELECT 
job_title_short, job_location,
case when  job_location = 'Anywhere' then 'Remote'
     when job_location = 'United States' then 'Local'
     else 'Onsite'
end as standardized_location
FROM job_postings_fact


--query to count number of Data Analyst jobs by location category
SELECT 
count(job_id) as number_of_jobs,
case when  job_location = 'Anywhere' then 'Remote'
     when job_location = 'United Kingdom' then 'Local'
     else 'Onsite'
end as location_category
FROM job_postings_fact
where job_title_short = 'Data Analyst'
GROUP BY location_category;

--query to filter job postings in April using CTE
With
april_jobs AS (
SELECT * FROM job_postings_fact
WHERE EXTRACT (MONTH from job_posted_date ) = 4)

SELECT * FROM april_jobs;

--query to get company names hiring Data Analysts
SELECT company_id,
name as company_name
FROM company_dim
where company_id IN (
    SELECT company_id
    FROM job_postings_fact
    WHERE job_title_short = 'Data Analyst'
    ORDER BY company_id
)

--query to get number of job postings by company
With company_job_count as (
Select company_id,
count(*) as total_jobs
from job_postings_fact
GROUP BY company_id
)
Select company_dim.name as company_name,
company_job_count.total_jobs
from company_dim
Left Join company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY total_jobs DESC;

--query to get top 10 skills for remote Data Analyst jobs
With remote_job_skills as (
Select 
skill_id,
count(*) as skill_count
from skills_job_dim as skills_to_job

inner Join job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id
where job_postings.job_work_from_home = True and
job_postings.job_title_short = 'Data Analyst'
GROUP BY skill_id
)
Select 
skills.skill_id,
skills as skill_name,
skill_count
from remote_job_skills
inner join skills_dim as skills on skills.skill_id = remote_job_skills.skill_id
ORDER BY skill_count DESC
LIMIT 10;



--query to combine job postings from January, February, and March
Select job_title_short, company_id, job_location
from january_jobs
UNION
Select job_title_short, company_id, job_location
from february_jobs
UNION
Select job_title_short, company_id, job_location
from march_jobs

--query to combine job postings from January and February including duplicates
Select job_title_short, company_id, job_location
from january_jobs
UNION all
Select job_title_short, company_id, job_location
from february_jobs



SELECT 
quarter_job_postings.job_title_short,
quarter_job_postings.job_location,
quarter_job_postings.job_via,
quarter_job_postings.job_posted_date::DATE,
quarter_job_postings.salary_year_avg
from(
SELECT *
from january_jobs
UNION All
Select *
from february_jobs
UNION All
Select *
from march_jobs
) as quarter_job_postings
where 
quarter_job_postings.salary_year_avg > 70000 and
quarter_job_postings.job_title_short = 'Data Analyst'
ORDER BY quarter_job_postings.salary_year_avg DESC;