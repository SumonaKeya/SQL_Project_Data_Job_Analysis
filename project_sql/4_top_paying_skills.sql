-- This query identifies the top 25 highest paying skills for Data Analyst roles that offer remote work options.

SELECT skills,
Round(Avg(salary_year_avg),0) As avg_salary
from job_postings_fact
INNER JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short='Data Analyst' and 
salary_year_avg IS NOT NULL AND
job_work_from_home = TRUE
GROUP BY skills
ORDER BY avg_salary DESC
limit 25;

/* 
Big Data & Cloud Dominance: Skills like PySpark, Databricks, GCP, and Kubernetes show high salaries, highlighting strong demand for data engineering and cloud expertise.

Data Science & Machine Learning Edge: Libraries and tools such as Pandas, NumPy, Scikit-learn, and DataRobot are well-compensated, reflecting the premium on predictive analytics and AI capabilities.

DevOps & Collaboration Tools Matter: Tools like GitLab, Bitbucket, Jenkins, and Atlassian suggest that analysts who can manage workflows, CI/CD, and collaboration pipelines earn more.*/