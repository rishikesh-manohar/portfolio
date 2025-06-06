-- "SQL Analysis: Employee Performance Review " --
-- This analysis focuses on evaluating employee performance across departments based on reviewer assessments. Key metrics such as average scores, risk flags, 
-- promotion readiness, and department-level insights are derived by aggregating and filtering the data

-- Total Number of Employees --
SELECT COUNT(DISTINCT Emp_Code) AS TOTAL_NUMBER_OF_EMPLOYEES 
FROM SQL_EMPLOYEE_EVA_DATA;

-- NUMBER OF EMPLOYEES PER COMPANY GROUP --
SELECT Group_Company_Name,COUNT(DISTINCT Emp_Code) AS NUMBER_OF_EMPLOYEES 
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Group_Company_Name
ORDER BY NUMBER_OF_EMPLOYEES DESC;

-- Number of Departments per company --
SELECT Group_Company_Name,COUNT(DISTINCT Dept_code) AS NUMBER_OF_DEPARTMENTS 
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Group_Company_Name
ORDER BY NUMBER_OF_DEPARTMENTS ASC;

-- Departments in company--
SELECT DISTINCT (Dept_code) AS departments ,Group_Company_Name 
FROM SQL_EMPLOYEE_EVA_DATA
ORDER BY departments ,Group_Company_Name ASC;

-- number of employees per departments--
select  Dept_code,count(Distinct Emp_Code) as number_of_employees
from SQL_EMPLOYEE_EVA_DATA
group by  Dept_code
order by number_of_employees desc;

-- Overall Average Score --
SELECT ROUND(AVG(Average_score),2) AS OVERALL_AVERAGE_SCORE
FROM SQL_EMPLOYEE_EVA_DATA;

-- Employee Distribution Across Departments --
SELECT Dept_code,COUNT(DISTINCT Emp_Code) AS NUMBER_EMPLOYEE
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Dept_code
ORDER BY NUMBER_EMPLOYEE DESC;

-- Average score by Question (company wide benchmarking) --
-- Identify which assessment areas (question_id) score the highest or lowest --
SELECT Questions_Id,ROUND(AVG(Average_score),2) AS AVG_SCORE
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Questions_Id
ORDER BY AVG_SCORE DESC;

-- Percentage of Employee Ready for promotion --
SELECT ROUND(SUM(CASE WHEN Questions_Id=8 AND Average_score>=4 THEN 1 ELSE 0 END)/
COUNT(DISTINCT Emp_Code)* 100, 2) AS PROMOTION_READY_PERCENTAGE
FROM SQL_EMPLOYEE_EVA_DATA;

-- Reviewer agreement score --
-- How often both reviewers gave the same response --
SELECT COUNT(*) AS TOTAL_RESPONSES ,
SUM(CASE WHEN R1_Response = R2_Response THEN 1 ELSE 0 END ) AS MUTUAL_RESPONSE,
ROUND(SUM(CASE WHEN R1_Response = R2_Response THEN 1 ELSE 0 END )/
COUNT(*)*100, 2) AS MUTUAL_RESPONSE_PERCENTAGE
FROM SQL_EMPLOYEE_EVA_DATA;
-- Avg score trend per department --
-- Track how the departments are performning on average --
SELECT Dept_code,ROUND(AVG(Average_score),2) AS AVERAGE_SCORE 
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Dept_code
ORDER BY AVERAGE_SCORE DESC;
-- Top Performing employees --
SELECT Emp_Code,ROUND(AVG(Average_score),2) AS AVERAGE_SCORE
FROM SQL_EMPLOYEE_EVA_DATA
WHERE AVERAGE_SCORE>=4
GROUP BY Emp_Code
order by AVERAGE_SCORE desc;
-- Bottom Performig Employees --
SELECT Emp_Code,ROUND(AVG(Average_score),2) AS AVERAGE_SCORE
FROM SQL_EMPLOYEE_EVA_DATA
WHERE AVERAGE_SCORE<=3.5
GROUP BY Emp_Code
order by AVERAGE_SCORE asc;
-- Sentiment-Like Scoring Band (Manual Banding) --
-- Score Bands that mimics sentiment (Positive,Neutral,Negative) --
SELECT CASE 
    WHEN Average_score >= 4 THEN 'Positive'
    WHEN Average_score BETWEEN 3 AND 3.99 THEN 'Neutral'
    ELSE 'Negative'
  END AS Sentiment_Category,
  COUNT(*) AS Num_Responses,ROUND(COUNT(*) / (SELECT COUNT(*) FROM SQL_EMPLOYEE_EVA_DATA) * 100, 2) AS Percentage
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Sentiment_Category;
 -- Most Critical Questions (Low score rate per question) --
 -- which question get most low scores --
 SELECT Questions_Id, 
       COUNT(CASE WHEN Average_score < 2.5 THEN 1 END) AS Low_Score_Count,
       ROUND(COUNT(CASE WHEN Average_score < 2.5 THEN 1 END) / COUNT(*) * 100, 2) AS Low_Score_Percentage
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Questions_Id
ORDER BY Low_Score_Percentage DESC;
-- Promotion Readiness(Question=8) by Designation level --
SELECT 
  Designation_Code, 
  COUNT(DISTINCT Emp_Code) AS Total_Emp,
  COUNT(DISTINCT CASE WHEN Questions_Id = 8 AND Average_score >= 4 THEN Emp_Code END) AS Promotion_Ready,
  ROUND(COUNT(DISTINCT CASE WHEN Questions_Id = 8 AND Average_score >= 4 THEN Emp_Code END) / 
    COUNT(DISTINCT Emp_Code) * 100, 2
  ) AS Promotion_Readiness_Percentage
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Designation_Code
order by Promotion_Readiness_Percentage desc;
-- Performance Risk heatmap --
-- focus on question_id = 7 ehre high score means high risk --
SELECT Dept_Code, Questions_Id,
  COUNT(DISTINCT CASE WHEN Average_score >= 4 THEN Emp_Code END) AS At_Risk_Employees
FROM SQL_EMPLOYEE_EVA_DATA
WHERE Questions_Id = 7
GROUP BY Dept_Code, Questions_Id;
 -- Employee Improvement Index --
SELECT Emp_Code,COUNT(*) AS Low_Score_Questions
FROM SQL_EMPLOYEE_EVA_DATA
WHERE Average_score < 3
GROUP BY Emp_Code
HAVING COUNT(*) >= 3;
-- Unmutual (Disagreement) feedback percentage --
SELECT ROUND(SUM(CASE WHEN R1_score != R2_score THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Unmutual_Response_Percentage
FROM SQL_EMPLOYEE_EVA_DATA;
-- Review Count Distribution Per Department --
SELECT Dept_Code, COUNT(DISTINCT Emp_Code) AS Unique_Employees_Reviewed,
  COUNT(*) AS Total_Review_Records
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Dept_Code
ORDER BY Total_Review_Records DESC;
-- High Performnce but not Promotion Ready --
SELECT Emp_Code, ROUND(AVG(Average_score), 2) AS Avg_Score,
  MAX(CASE WHEN Questions_Id = 8 THEN R1_Response END) AS R1_Promotion,
  MAX(CASE WHEN Questions_Id = 8 THEN R2_Response END) AS R2_Promotion
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Emp_Code
HAVING Avg_Score >= 4 AND (R1_Promotion = 'No' OR R2_Promotion = 'No');
-- Most Disagreed Questions --
SELECT Questions_Id,Question,
  COUNT(*) AS Total_Responses,
  SUM(CASE WHEN R1_score != R2_score THEN 1 ELSE 0 END) AS Disagreements,
  ROUND(SUM(CASE WHEN R1_score != R2_score THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Disagreement_Percentage
FROM SQL_EMPLOYEE_EVA_DATA
GROUP BY Questions_Id, Question
ORDER BY Disagreement_Percentage DESC
LIMIT 3;
-- Promotion Readiness Rate --
SELECT 
  COUNT(DISTINCT CASE WHEN Questions_Id = 8 AND Average_score >= 4 THEN Emp_Code END) AS Ready_For_Promotion,
  COUNT(DISTINCT Emp_Code) AS Total_Employees,
  ROUND(COUNT(DISTINCT CASE WHEN Questions_Id = 8 AND Average_score >= 4 THEN Emp_Code END) * 100.0 / COUNT(DISTINCT Emp_Code), 2) AS Promotion_Readiness_Percentage
FROM SQL_EMPLOYEE_EVA_DATA;
-- employee at risk --
SELECT 
  COUNT(DISTINCT CASE WHEN Questions_Id = 7 AND Average_score >= 4 THEN Emp_Code END) AS At_Risk_Employees,
  COUNT(DISTINCT Emp_Code) AS Total_Employees,
  ROUND(COUNT(DISTINCT CASE WHEN Questions_Id = 7 AND Average_score >= 4 THEN Emp_Code END) * 100.0 / COUNT(DISTINCT Emp_Code), 2) AS At_Risk_Percentage
FROM SQL_EMPLOYEE_EVA_DATA;
-- Neutral Feedback rate --
SELECT 
  ROUND(SUM(CASE WHEN Average_score = 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Neutral_Feedback_Percentage
FROM SQL_EMPLOYEE_EVA_DATA;












 
