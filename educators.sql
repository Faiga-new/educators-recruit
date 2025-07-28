-- T-SQL implementation for the Educators Recruit business scenario
-- Drop table if it already exists
IF OBJECT_ID('dbo.Educators', 'U') IS NOT NULL
    DROP TABLE dbo.Educators;
GO

-- Create table to store educator information
CREATE TABLE dbo.Educators (
    EducatorID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Gender NVARCHAR(10) NOT NULL,
    CollegeAttended NVARCHAR(100) NOT NULL,
    DegreeTitle NVARCHAR(100) NOT NULL,
    Media NVARCHAR(50) NOT NULL,
    DateContacted DATE NOT NULL,
    SchoolPlaced NVARCHAR(100) NULL,
    DateFoundJob DATE NULL
);
GO

-- Insert sample data
INSERT INTO dbo.Educators
    (FirstName, LastName, DOB, Gender, CollegeAttended, DegreeTitle, Media, DateContacted, SchoolPlaced, DateFoundJob)
VALUES
    ('Mary', 'Lynn', '2000-09-13', 'female', 'Excelsior College', 'BA in Mathematics Education', 'magazine', '2022-05-02', 'Brooklyn High School', '2022-05-09'),
    ('Josh', 'Frank', '1998-04-23', 'male', 'Georgia State University', 'MA in Social Studies Education', 'social media site', '2022-02-12', 'Manhattan Elementary School', '2022-05-09'),
    ('Charles', 'Smith', '1994-07-09', 'male', 'Excelsior College', 'PhD in Education', 'social media site', '2021-08-07', 'New York City Day School', '2021-08-12'),
    ('Samantha', 'Brown', '1999-09-24', 'female', 'Columbia University', 'BA in English Education', 'newspaper', '2021-05-23', 'Brooklyn High School', '2021-07-30'),
    ('Howard', 'Lang', '1998-08-04', 'male', 'Georgia State University', 'MA in History Education', 'word of mouth', '2022-01-31', NULL, NULL),
    ('Sarah', 'Blanks', '1995-10-20', 'female', 'Columbia University', 'MA in Science Education', 'social media', '2020-05-23', 'New York City Day School', '2020-08-17'),
    ('Ella', 'Lewis', '2000-08-22', 'female', 'Excelsior College', 'BA in English Education', 'word of mouth', '2022-04-01', NULL, NULL),
    ('Julie', 'Goldman', '1997-03-30', 'female', 'University of Denver', 'MA in Social Studies Education', 'social media', '2020-07-14', 'Manhattan Elementary School', '2020-08-17');
GO

/*
Report 1: Number of students from each college placed in under two weeks
This considers the difference between the date contacted and the date the job was found.
*/
SELECT
    CollegeAttended,
    COUNT(*) AS PlacedWithinTwoWeeks
FROM dbo.Educators
WHERE DateFoundJob IS NOT NULL
  AND DATEDIFF(day, DateContacted, DateFoundJob) <= 14
GROUP BY CollegeAttended
ORDER BY CollegeAttended;
GO

/*
Report 2: Placement success by gender
Counts educators with a non-null job placement date by gender.
*/
SELECT
    Gender,
    COUNT(*) AS PlacedCount
FROM dbo.Educators
WHERE DateFoundJob IS NOT NULL
GROUP BY Gender;
GO

/*
Report 3a: Average number of people contacting the company per day
*/
SELECT
    AVG(ContactCount * 1.0) AS AvgContactsPerDay
FROM (
    SELECT DateContacted, COUNT(*) AS ContactCount
    FROM dbo.Educators
    GROUP BY DateContacted
) AS Daily;
GO

/*
Report 3b: Number of people who found out about us per form of media
*/
SELECT
    Media,
    COUNT(*) AS ContactCount
FROM dbo.Educators
GROUP BY Media
ORDER BY Media;
GO

/*
Report 4: Average number of people placed per day
*/
SELECT
    AVG(PlacedCount * 1.0) AS AvgPlacementsPerDay
FROM (
    SELECT DateFoundJob, COUNT(*) AS PlacedCount
    FROM dbo.Educators
    WHERE DateFoundJob IS NOT NULL
    GROUP BY DateFoundJob
) AS DailyPlacements;
GO

/*
Report 5: Number of educators placed per day per degree level (BA, MA, PhD)
*/
SELECT
    DegreeLevel,
    DateFoundJob,
    COUNT(*) AS PlacedCount
FROM (
    SELECT
        CASE
            WHEN CHARINDEX(' ', DegreeTitle) > 0 THEN LEFT(DegreeTitle, CHARINDEX(' ', DegreeTitle) - 1)
            ELSE DegreeTitle
        END AS DegreeLevel,
        DateFoundJob
    FROM dbo.Educators
    WHERE DateFoundJob IS NOT NULL
) AS t
GROUP BY DegreeLevel, DateFoundJob
ORDER BY DateFoundJob, DegreeLevel;
GO

/*
Report 6: List of educators with name, age, and degree title
*/
SELECT
    FirstName,
    LastName,
    DATEDIFF(year, DOB, GETDATE()) AS Age,
    DegreeTitle
FROM dbo.Educators
ORDER BY LastName, FirstName;
GO
