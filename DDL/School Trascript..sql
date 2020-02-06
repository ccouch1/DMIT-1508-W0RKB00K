/* ***********************
* File: SchoolTrannscript.sql
* Author: Chris Couch
*
* CREATE DATABASE SchoolTranscript
*********************** */
USE SchoolTranscript
GO
/*== Drop Statements ==*/ -- Drop Statements are Very Important
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'StudentCourses')
    DROP TABLE StudentCourses
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Courses')
    DROP TABLE Courses
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Students')
    DROP TABLE Students
/*== Create Tables ==*/
CREATE TABLE Students
(
    StudentID       int        
        CONSTRAINT PK_Student_StudentID
            PRIMARY KEY         
		IDENTITY (200262912, 1)			NOT NULL,
    GiveName        varchar(50)			NOT NULL,
-- % is a wildcard for zero or more characters  (letter, digit or other character)
-- _ is a wildcard for a sing character (letter, didgi or other character)
-- [] are used to represent a range or set of characters that are allowed
    Surname         varchar(50) 
		CONSTRAINT CK_Student_Surname
			CHECK (Surname LIKE '__%')		 --LIKE allows us to do a "pattern-match" of values
--			CHECK (Surname LIKE '[a-z][a-z%')-- two letters plus any other characters
		--							\1/\1/
		--	Postitive match for 'Fred'
		--	Postitive match for 'Wu'
		--	Negative match for 'F'
		--	Negative match for '2udor'
										NOT NULL, 
    DateOfBirth     datetime			
		CONSTRAINT CK_Students_DateOfBirth
			CHECK (DateOfBirth < GETDATE())
										NOT NULL,
    Enrolled        bit         
        CONSTRAINT DF_Students_Enrolled
            DEFAULT (1)					NOT NULL,
)
-- smallest string can be 0 you can have an empty string but not a NULL one
CREATE TABLE Courses
(  
    Number      varchar(10)      
        CONSTRAINT PK_Courses_Number
            PRIMARY KEY          NOT NULL,
    [Name]      varchar(50)      NOT NULL,
    Credits     decimal(3, 1)    
		CONSTRAINT CK_Courses_Credits 
			CHECK (Credits > 0 AND Credits <= 6)
								 NOT NULL,
    [Hours]     tinyint       
		 CONSTRAINT CK_Courses_Hours
			 CHECK ([Hours] BETWEEN 15 AND 180) --BETWEEN operator is inclusive
--			 CHECK ([Hours] >= 15 AND [Hours] <= 180)--   
								NOT NULL,
    Active      bit              
        CONSTRAINT DF_Courses_Active
            DEFAULT (1)          NOT NULL,
    Cost        money
		CONSTRAINT Cost
			CHECK (Cost >= 0)
								 NOT NULL
)
--Check is the Equivalent of a C# IF statement 
CREATE TABLE StudentCourses
(
    StudentID       int           
        CONSTRAINT FK_StudentCourses_StudentID_Students_StudentID
            FOREIGN KEY REFERENCES Students(StudentID)
                                   NOT NULL,
    CourseNumber    varchar(10)  
        CONSTRAINT FK_StudentCourses_CourseNumber_Courses_Number
            FOREIGN KEY REFERENCES Courses(Number)
                                   NOT NULL,
    [Year]          tinyint        NOT NULL,
    Term            char(3)        NOT NULL,
    FinalMark       tinyint            NULL,
    [Status]        char(1)        
		CONSTRAINT CK_StudentCourses_Status
			CHECK ([Status] = 'E' OR
				   [Status] = 'C' OR
				   [Status] = 'W')
--			CHECK ([Status] IN ('E', 'C', 'W'))
									NOT NULL,
    --Table-level contraint for composite keys
    CONSTRAINT PK_StudentCourses_StudentID_CourseNumber
        PRIMARY KEY (StudentID, CourseNumber),
	--Table-level CONSTRAINT Involving more than one Column
	CONSTRAINT CK_StudentCourses_FinalMark_Status
		CHECK (([Status] = 'C' AND FinalMark IS NOT NULL)
				OR
				([Status] IN ('E', 'W') AND FinalMark IS NULL)) 
)


/*---- Indexes ----*/
-- For All Foreign Keys
CREATE NONCLUSTERED INDEX IX_StudentCourses_StudentID
		ON StudentCourses (StudentID)

CREATE NONCLUSTERED INDEX IX_StudentCourses_CourseNumber
		ON StudentCourses (CourseNumber)

-- For other Columns Where Searching/Sorting Might Be Important
CREATE NONCLUSTERED INDEX IX_Students_Surname
		ON Students (Surname)
--ALTER TABLES allow you to modify Tables with out Dropping them and losing whatever data maybe in the Table
/* ------ ALTER TABLE Statements ------*/
ALTER TABLE Students
	ADD PostalCode char(6) NULL 
	-- Adding this as a Nullable columm, Becasue students already exist,
	--and we don't have postal codes for those students.
GO -- I have to break the above code as a Seperate Batch from teh Following Code because I if I don't it has not created the column yet

-- 2) Make sure the PostalCode follows the Correct Pattern A#A#A#
ALTER TABLE Students
	ADD CONSTRAINT CK_Students_PostalCode
		CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
		-- Match for T4R1H2 :	  T	   4	R	 1	  H	   2
