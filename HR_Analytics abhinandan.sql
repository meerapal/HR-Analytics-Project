CREATE DATABASE HR;

USE HR;

CREATE TABLE HR_1 (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20)
);

desc HR_1;


CREATE TABLE HR_2 (
    EmployeeID INT PRIMARY KEY,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

desc HR_2 ;


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_1.csv"
INTO TABLE HR_1 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_2.csv"
INTO TABLE HR_2 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM HR_1 ;
SELECT * FROM HR_2 ;

#Below Lines will be deleted in final sql file                                                                            
#To Add New Column for Attrition_COUNT                                                                                                                                                    
                                                                             
ALTER TABLE hr_1
ADD Attrition_COUNT INT;

UPDATE hr_1
SET Attrition_COUNT = CASE
    WHEN Attrition = 'Yes' THEN 1
    WHEN Attrition = 'No' THEN 0
    ELSE NULL
    END;         
    

/*KPI1:
Average Attrition rate for all Departments.*/

CREATE VIEW KPI1 AS
	SELECT 
			Department,
			ROUND((AVG((Attrition_Count)/(EmployeeCount))*100),2) as Avg_Attrition_Rate
	FROM 
			hr_1
	GROUP BY 
			Department
	ORDER BY 
			Avg_Attrition_Rate DESC;
            
	 
	#USING VIEWS FOR KPI 1
     SELECT * FROM KPI1;
     
     
     
      /*KPI2:
     Average Hourly rate of Male Research Scientist.*/
     
    CREATE VIEW KPI2 AS 
    SELECT 
			JobRole,
			Gender,
			ROUND(AVG(HourlyRate),2) as Avg_HourlyRate
	FROM
			hr_1
	WHERE
			Gender = "Male" AND JobRole = 'Research Scientist';
    

            
	#USING VIEWS FOR KPI 2
	SELECT * FROM KPI2;
    
    
    
     /*KPI3:
     Attrition rate Vs Monthly income stats.*/
     
     
     CREATE VIEW KPI3 AS
     SELECT 
			hr_1.Attrition,
			ROUND(AVG(hr_2.MonthlyIncome),2) AS Avg_MonthlyIncome,
			MIN(hr_2.MonthlyIncome) AS Min_MonthlyIncome,
			MAX(hr_2.MonthlyIncome) AS Max_MonthlyIncome,
            SUM(hr_2.monthlyincome) as Total_MonthlyIncome
	FROM 
			hr_1
	JOIN
			hr_2 ON hr_2.`EmployeeID` = hr_1.EmployeeNumber
	GROUP BY
			Attrition;


     
     #USING VIEWS For KPI 3
     SELECT * FROM KPI3;
     
     
     /*KPI4:
     Average working years for each Department.*/
     
     CREATE VIEW KPI4 AS
     SELECT
			hr_1.Department,
			ROUND(AVG(hr_2.TotalWorkingYears),2) AS Avg_Working_Years
	 FROM
			hr_1
	 INNER JOIN
			hr_2 ON hr_2.`EmployeeID` = hr_1.EmployeeNumber
	 GROUP BY
			Department
	 ORDER BY 
			Department;
     
     
     #USING VIEWS FOR KPI 4
     SELECT * FROM KPI4;

     
     
     
     /*KPI5:
     Job Role Vs Work life balance.*/
     
    CREATE VIEW KPI5 AS
	SELECT
			hr_1.JobRole,
			SUM(CASE WHEN hr_2.WorkLifeBalance = 4 THEN 1 ELSE 0 END) AS Excellent,
			SUM(CASE WHEN hr_2.WorkLifeBalance = 3 THEN 1 ELSE 0 END) AS Good,
			SUM(CASE WHEN hr_2.WorkLifeBalance = 2 THEN 1 ELSE 0 END) AS Average,
			SUM(CASE WHEN hr_2.WorkLifeBalance = 1 THEN 1 ELSE 0 END) AS Poor
	FROM
			hr_1
	INNER JOIN
			hr_2 ON hr_2.`EmployeeID` = hr_1.EmployeeNumber
	GROUP BY
			JobRole
	ORDER BY
			JobRole;




    #USING VIEWS FOR KPI 5
    SELECT * FROM KPI5;
  
  
  
    /*KPI6:
     Attrition rate Vs Year since last promotion relation.*/
     
     CREATE VIEW KPI6 AS
     SELECT 
			hr_2.YearsSinceLastPromotion,
            ROUND((SUM(Attrition_Count)/SUM(EmployeeCount))*100,2) AS AttritionRate            
	 FROM
			hr_1
	 JOIN
			hr_2 ON hr_2.`EmployeeID` = hr_1.EmployeeNumber
	 GROUP BY 
			1
	 ORDER BY 
			1;
	
       
      #USING VIEWS FOR KPI 6
      SELECT * FROM KPI6;
     

     
     #---------------------------------------------------------------------------Thank You------------------------------------------------------------------------------------------------    
																	        /* P288 GROUP 4*/
