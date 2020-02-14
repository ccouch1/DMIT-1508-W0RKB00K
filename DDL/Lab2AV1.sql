/* ***********************
*File: Lab2A.sql
*Author: Chris Cocuch
*
*CREATE DATABASE Lab2A
*********************** */
USE Lab2A
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SALE')
	DROP TABLE SALE
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SALEDETAIL')
	DROP TABLE SALEDETAIL
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TITLE')
	DROP TABLE TITLE
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PUBLSIHER')
	DROP TABLE PUBLISHER
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CATEGORY')
	DROP TABLE CATEGORY
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME= 'AUTHORTITLE')
	DROP TABLE AUTHORTITLE
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME ='AUTHOR')
	DROP TABLE AUTHOR
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME ='CUSTOMER')
	DROP TABLE CUSTOMER
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME ='EMPLOYEE')
	DROP TABLE EMPLOYEE

CREATE TABLE EMPLOYEE
(
	EMPLOYEENUMBER		int
			CONSTRAINT PK_EMPLOYEE_EMPLOYEENUMBER
				PRIMARY KEY
			IDENTITY	   (300, 1)	NOT NULL,
		[SIN]		   char(9)		NOT NULL,
		LastName	varchar(30)		
			CONSTRAINT CK_EMPLOYEE_LastName
				CHECK (LastName Like'_%')
									NOT NULL,
		FirstName	varchar(30)		
			CONSTRAINT CK_EMPLOYEE_FirstName
				CHECK (FirstName Like '_%')
									NOT NULL,
		[Addres]	varchar(40)			NULL,
		City		varchar(30)			NULL,
		Province	   char(2)			
			CONSTRAINT DF_EMPLOYEE_Province
				DEFAULT ('AB')
			CONSTRAINT CK_EMPLOYEE_Province
				CHECK (Province = 'BC' OR
					   Province = 'AB' OR
					   Province = 'SK' OR
					   Province = 'MB' OR
					   Province = 'ON' OR
					   Province = 'QC' OR
					   Province = 'NL' OR
					   Province = 'NS' OR
					   Province = 'PE' OR
					   Province = 'NB' OR
					   Province = 'NU' OR
					   Province = 'NT' OR
					   Province = 'YT')
										NULL,
		PostalCode	   char(6)			
			CONSTRAINT CK_EMPLOYEE_PostalCode
				CHECK (PostalCode Like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]') 
										NULL,
		HomePhone	   char(10)			NULL,
		WorkPhone	   char(10)			NULL,
		Email		varchar(40)			NULL,


	)

CREATE TABLE CUSTOMER
(
	CUSTOMERNUMBER  int
		CONSTRAINT PK_CUSTOMER_CUSTOMERNUMBER
			PRIMARY KEY
		IDENTITY			(1, 1)		NOT NULL,
		LastName	varchar	(30)		
			CONSTRAINT CK_CUSTOMER_LastName
				CHECK (LastName Like '_%')
										NOT NULL,
		FirstName	varchar (30)		
			CONSTRAINT CK_CUSTOMER_FirstName
				CHECK (FirstName Like '_%') 
										NOT NULL,
		[Address]	varchar	(40)			NULL,
		City		varchar	(40)			NULL,
		Province	   char	(2)				
			CONSTRAINT DF_CUSTOMER_Province
				DEFAULT ('AB')
			CONSTRAINT CK_CUSTOMER_Province
				CHECK	(Province ='BC' OR
						 Province ='AB' OR
						 Province ='SK' OR
						 Province ='MB' OR
						 Province ='ON' OR
						 Province ='QC' OR
						 Province ='NL' OR
						 Province ='NS' OR
						 Province ='PE' OR
						 Province ='NB' OR
						 Province ='NU' OR
						 Province ='NT' OR
						 Province ='YT')
											NULL,
	PostalCode		char(6)
			CONSTRAINT CK_CUSTOMER_PostalCode
				CHECK (PostalCode Like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
											NULL,
	HomePhone		char(10)				NULL,
)

CREATE TABLE AUTHOR
(
	AUTHORCODE int
		CONSTRAINT PK_AUTHOR_AUTHORCODE
			PRIMARY KEY
		IDENTITY		(100, 1)	NOT NULL,
	LastName		varchar (30)	
			CONSTRAINT CK_AUTHOR_LastName
				CHECK (LastName Like '_%') 
									NOT NULL,
	FirstName		varchar  (30)
			CONSTRAINT CK_AUTHOR_FirstName
				CHECK (FirstName Like '_%')
									NOT NULL,

)
CREATE TABLE AUTHORTITLE
(

)
CREATE TABLE CATEGORY
(
)
CREATE TABLE PUBLISHER
(
)
CREATE TABLE TITLE
(
)
CREATE TABLE SALEDETAIL
(
)
CREATE TABLE SALE
(
)
