--Database Exploration
--1. 1. Use this space to make note of each table in the database, the columns within each table, each column’s data type, and how the tables are connected. 
--You can write this down or draw a diagram. Whatever method helps you get an understanding of what is going on with LaborStatisticsDB.
SELECT *
FROM dbo.annual_2016

SELECT *
FROM dbo.datatype
--WHERE data_type_text LIKE '%production and nonsupervisory%'

SELECT *
FROM dbo.footnote

SELECT *
FROM dbo.industry

SELECT *
FROM dbo.january_2017

SELECT *
FROM dbo.period

SELECT *
FROM dbo.seasonal

SELECT *
FROM dbo.series
WHERE series_title LIKE '%weekly earnings of production and nonsupervisory%'

SELECT *
FROM dbo.supersector

--2. What is the datatype for women employees?
SELECT *
FROM dbo.datatype
WHERE data_type_text = 'women employees'


--3. What is the series id for  women employees in the commercial banking industry in the financial activities supersector?
SELECT *
FROM dbo.datatype
WHERE data_type_text = 'women employees'

SELECT *
FROM dbo.industry
--WHERE industry_name = 'commercial banking'

SELECT *
FROM dbo.supersector
WHERE supersector_name = 'financial activities'

SELECT series_id, series_title, i.industry_name, p.supersector_name
FROM dbo.series s 
INNER JOIN dbo.industry i ON s.industry_code = i.industry_code
INNER JOIN dbo.supersector p ON s.supersector_code = p.supersector_code
WHERE s.series_title = 'women employees'
AND i.industry_name = 'commercial banking'
AND p.supersector_name = 'financial activities'

SELECT series_id
FROM dbo.series s 
LEFT JOIN dbo.datatype d ON s.data_type_code = d.data_type_code
LEFT JOIN dbo.industry i ON s.industry_code = i.industry_code
LEFT JOIN dbo.supersector p ON s.supersector_code = p.supersector_code
WHERE d.data_type_text = 'women employees'
AND i.industry_name = 'commercial banking'
AND p.supersector_name = 'financial activities'

--Join in on the fun
--1. Join  annual_2016 with series on series_id. We only want the data in the annual_2016 table to be included in the result.
SELECT a.id, a.series_id, a.year, a.period, a.value, a.footnote_codes, a.original_file
FROM dbo.annual_2016 a 
LEFT JOIN dbo.series s ON a.series_id = s.series_id
--LEFT JOIN because it includes all values from annual_2016 even if they don't match values in series table

--2. Join series and datatype on data_type_code
SELECT *
FROM dbo.series s
INNER JOIN dbo.datatype d ON s.data_type_code = d.data_type_code
--inner join because 

--3. Join series and industry on industry_code
SELECT *
FROM dbo.series s 
INNER JOIN dbo.industry i ON s.industry_code = i.industry_code

--Aggregate Your Friends and Code some SQL

--1. How many employees were reported in 2016 in all industries? Round to the nearest whole number.  No chopping people into little bits, please.
SELECT COUNT(*) AS 'Num of all Employees'
FROM dbo.series s
LEFT JOIN dbo.annual_2016 a ON s.series_id = a.series_id
--INNER JOIN dbo.industry i ON s.industry_code = i.industry_code
WHERE s.series_title = 'All employees'

--2. How many women employees were reported in 2016 in all industries? Round to the nearest whole number. 
SELECT COUNT(*) AS 'Num of Women Employees'
FROM dbo.series s
INNER JOIN dbo.annual_2016 a ON s.series_id = a.series_id
--INNER JOIN dbo.industry i ON s.industry_code = i.industry_code
WHERE s.series_title = 'Women employees'
--AND a.year = 2016
--AND i.industry_name = *;

--3. How many production/nonsupervisory employees were reported in 2016? Round to the nearest whole number.
SELECT COUNT(*) AS 'Number of Employees'
FROM dbo.series s
LEFT JOIN dbo.annual_2016 a ON s.series_id = a.series_id
WHERE s.series_title LIKE 'production and nonsupervisory%'

--4. In January 2017, what is the average weekly hours worked by production and nonsupervisory employees across all industries?
SELECT COUNT(*) AS 'Avg Weekly Hours'
FROM dbo.january_2017 j 
INNER JOIN dbo.series s ON j.series_id = s.series_id
INNER JOIN dbo.industry i ON s.industry_code = i.industry_code
WHERE s.series_title = 'Average weekly hours of production and nonsupervisory employees'


SELECT s.series_id, s.series_title, i.industry_name, j.year, j.value, s.data_type_code, COUNT(DISTINCT s.series_title)
FROM dbo.january_2017 j 
INNER JOIN dbo.series s ON j.series_id = s.series_id
INNER JOIN dbo.industry i ON s.industry_code = i.industry_code
WHERE s.series_title = 'Average weekly hours of production and nonsupervisory employees'
GROUP BY s.series_id, s.series_title, i.industry_name, j.year, j.value, s.data_type_code

--5. What is the total weekly payroll for production and nonsupervisory employees across all industries in January 2017? Round to the nearest penny, please.
SELECT COUNT(*)
FROM dbo.january_2017 j 
INNER JOIN dbo.series s ON j.series_id = s.series_id
WHERE s.series_title = 'Aggregate weekly payrolls of production and nonsupervisory employees'

--6. In January 2017, which industry was the average weekly hours worked by production and nonsupervisory employees the highest? Which industry was the lowest?
SELECT i.industry_name, COUNT(*) AS 'NumEmployees' --MAX(COUNT(s.series_title))
FROM dbo.industry i  
INNER JOIN dbo.series s ON i.industry_code = s.industry_code
INNER JOIN dbo.january_2017 j ON j.series_id = s.series_id
WHERE s.series_title = 'Average weekly hours of production and nonsupervisory employees'
GROUP BY i.industry_name

SELECT COUNT(s.series_title) AS 'NumEmployees' --MAX(COUNT(s.series_title))
FROM dbo.industry i  
INNER JOIN dbo.series s ON i.industry_code = s.industry_code
INNER JOIN dbo.january_2017 j ON j.series_id = s.series_id
WHERE s.series_title = 'Average weekly hours of production and nonsupervisory employees'
AND i.industry_name = 'chemicals'
GROUP BY i.industry_name

--7. In January 2021(2017), which industry was the total weekly payroll for production and nonsupervisory employees the highest? Which industry was the lowest?
SELECT i.industry_name, COUNT(*)
FROM dbo.january_2017 j 
INNER JOIN dbo.series s ON j.series_id = s.series_id
INNER JOIN dbo.industry i ON s.industry_code = i.industry_code
WHERE s.series_title = 'Aggregate weekly payrolls of production and nonsupervisory employees'
GROUP BY i.industry_name

--Subqueries, Unions, Derived Tables, Oh My!
--1. Write a query that returns the series_id, industry_code, industry_name, and value from the january_2017 table but only if that value is greater than 
--the average value for annual_2016 of data_type_code 82.
SELECT s.series_id, i.industry_code, i.industry_name, j.value
FROM dbo.january_2017 j 
INNER JOIN dbo.series s ON j.series_id = s.series_id
INNER JOIN dbo.industry i ON i.industry_code = s.industry_code
WHERE j.value > 
    (SELECT AVG(a.value)
     FROM dbo.annual_2016 a
     INNER JOIN dbo.series s ON a.series_id = s.series_id
     WHERE s.data_type_code = 82);

--2. Create a Union table comparing average weekly earnings  of production and nonsupervisory employees between annual_16 and january_17 using the data type 30.  
--Round to the nearest penny.  You should have a column for the average earnings and a column for the year, and the period.
SELECT COUNT(*) AS 'AverageEarnings', a.year, a.period
FROM dbo.annual_2016 a 
INNER JOIN dbo.series s ON s.series_id = a.series_id
WHERE s.series_title LIKE '%weekly earnings of production and nonsupervisory%'
AND s.data_type_code = 30
GROUP BY a.year, a.period
UNION
SELECT COUNT(*), j.year, j.period
FROM dbo.january_2017 j  
INNER JOIN dbo.series s ON s.series_id = j.series_id
WHERE s.series_title LIKE '%weekly earnings of production and nonsupervisory%'
AND s.data_type_code = 30
GROUP BY j.year, j.period
ORDER BY AverageEarnings