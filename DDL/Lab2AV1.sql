/* ***********************
*File: Lab2A.sql
*Author: Chris Cocuch
*
*CREATE DATABASE Lab2A
*********************** */
USE Lab2A
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sale')
	DROP TABLE SALE
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SaleDetail')
	DROP TABLE SALEDETAIL
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Title')
	DROP TABLE TITLE
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Publisher')
	DROP TABLE PUBLISHER
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Category')
	DROP TABLE CATEGORY
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME= 'AuthorTitle')
	DROP TABLE AUTHORTITLE
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME ='Author')
	DROP TABLE AUTHOR
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME ='Customer')
	DROP TABLE CUSTOMER
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME ='Employee')
	DROP TABLE Employee

CREATE TABLE Employee
(
	EmployeeNumber		int
			CONSTRAINT PK_Employee_EmployeeNumber
				PRIMARY KEY
			IDENTITY	   (300, 1)	NOT NULL,
		[SIN]		   char(9)		NOT NULL,
		LastName	varchar(30)		
			CONSTRAINT CK_Employee_LastName
				CHECK (LastName Like'_%')
									NOT NULL,
		FirstName	varchar(30)		
			CONSTRAINT CK_Employee_FirstName
				CHECK (FirstName Like '_%')
									NOT NULL,
		[Addres]	varchar(40)			NULL,
		City		varchar(30)			NULL,
		Province	   char(2)			
			CONSTRAINT DF_Employee_Province
				DEFAULT ('AB')
			CONSTRAINT CK_Employee_Province
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
			CONSTRAINT CK_Employee_PostalCode
				CHECK (PostalCode Like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]') 
										NULL,
		HomePhone	   char(10)			
			CHECK (HomePhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
										NULL,
		WorkPhone	   char(10)			
			CHECK (WorkPhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
										NULL,
		Email		varchar(40)			NULL,


	)

CREATE TABLE Customer
(
	CustomerNumber  int
		CONSTRAINT PK_Customer_CustomerRNumber
			PRIMARY KEY
		IDENTITY			(1, 1)		NOT NULL,
		LastName	varchar	(30)		
			CONSTRAINT CK_Customer_LastName
				CHECK (LastName Like '_%')
										NOT NULL,
		FirstName	varchar (30)		
			CONSTRAINT CK_Customer_FirstName
				CHECK (FirstName Like '_%') 
										NOT NULL,
		[Address]	varchar	(40)			NULL,
		City		varchar	(40)			NULL,
		Province	   char	(2)				
			CONSTRAINT DF_Customer_Province
				DEFAULT ('AB')
			CONSTRAINT CK_Customer_Province
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
			CONSTRAINT CK_Customer_PostalCode
				CHECK (PostalCode Like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
											NULL,
	HomePhone	   char(10)			
			CHECK (HomePhone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
											NULL,
)

CREATE TABLE Author
(
	AuthorCode int
		CONSTRAINT PK_Author_AuthorCode
			PRIMARY KEY
		IDENTITY		(100, 1)	NOT NULL,
	LastName		varchar (30)	
			CONSTRAINT CK_Author_LastName
				CHECK (LastName Like '_%') 
									NOT NULL,
	FirstName		varchar  (30)
			CONSTRAINT CK_Author_FirstName
				CHECK (FirstName Like '_%')
									NOT NULL,

)
CREATE TABLE AuthorTitle
(
	ISBN		char (10)
		CONSTRAINT FK_AuthorTitle_ISBN_Title_ISBN
			FOREIGN KEY REFERENCES Title(ISBN)
									
									NOT NULL,
	AuthorCode	int	
		CONSTRAINT FK_AuthorTitle_AuthorCode_Author_AuthorCode
			FOREIGN KEY REFERENCES Author(AuthorCode)
									NOT NULL,

	CONSTRAINT PK_AuthorTitle_ISBN_AuthorCode
			PRIMARY KEY (ISBN, AuthorCode)
)
CREATE TABLE Category
(
	CategoryCode int
		CONSTRAINT PK_Category_CategoryCode
			PRIMARY KEY 
		IDENTITY (1, 1)			
							   NOT NULL,
	[Description] varchar (40) 
							   NOT NULL,
)
CREATE TABLE Publisher
(
	PublisherCode int
		CONSTRAINT PK_Publisher_PublisherCode
			PRIMARY KEY
		IDENTITY		(200, 1)
								NOT NULL,
	[Name] varchar (40)
			CHECK ([Name] Like '_%')
								NOT NULL,
)
CREATE TABLE Title
(
	ISBN			char(10)		NOT NULL,
	Title			varchar (40)	NOT NULL,
	SuggestedPrice	smallmoney
		CONSTRAINT DF_Title_SuggestedPrice
			DEFAULT (0)				NOT NULL,
	NumberinStock	smallint	
		CONSTRAINT DF_Title_NumberinStock
			DEFAULT (0)			
		CONSTRAINT CK_Title_NumberinStock
			CHECK (NumberinStock >=0)
									NOT NULL,

	PublisherCode	int
		CONSTRAINT FK_Title_PublisherCode_Publisher_PublisherCode
			FOREIGN KEY REFERENCES Publisher(PublisherCode)
								NOT NULL,
	CategoryCode	int
		CONSTRAINT FK_Title_CategoryCode_Category_CategoryCode
			FOREIGN KEY REFERENCES	Category(CategoryCode)
								NOT NULL,
)
CREATE TABLE SaleDetail
(
	SaleNumber int
		CONSTRAINT FK_SaleDetail_SaleNumber_Sale_SaleNumber
			FOREIGN KEY REFERENCES Sale(SaleNumber)
								NOT NULL,
	ISBN char (10)
		CONSTRAINT FK_SaleDetail_ISBN_Title_ISBN
			FOREIGN KEY REFERENCES Title(ISBN)
								NOT NULL,
	SellingPrice	money		NOT NULL,
	Quantity		int			NOT NULL,
	Amount			money		NOT NULL,
)
CREATE TABLE Sale
(
	SaleNumber	int
		CONSTRAINT PK_Sale_SaleNumber
			PRIMARY KEY
		IDENTITY (3000, 1)
									NOT NULL,
	SaleDate	datetime
			CONSTRAINT CK_Sale_SaleDate
				CHECK (SaleDate < GETDATE ())
									NOT NULL,
	CustomerNumber	int
		CONSTRAINT FK_Sale_CustomerNumber_Customer_CustomerNumber
			FOREIGN KEY REFERENCES Customer(CustomerNumber)
									NOT NULL,
	EmployeeNumber	int
		CONSTRAINT	FK_Sale_EmployeeNumber_Employee_EmployeeNumber
			FOREIGN KEY REFERENCES	Employee(EmployeeNumber)
									NOT NULL,
	Subtotal	money
		CONSTRAINT CK_Sale_Subtotal
			CHECK (Total >= Subtotal)
									NOT NULL,
	GST			money				NOT NULL,
	Total		money				
		CONSTRAINT	CK_SALE_Total
			CHECK	(Total >=Subtotal) 
									NOT NULL,
)
ALTER TABLE Customer
	ADD WorkPhone char(10) NULL

GO

ALTER TABLE Customer
	ADD Email	  char(30)	NULL
 
 GO
 ALTER TABLE Customer
	ADD CONSTRAINT CK_Customer_Email
		CHECK (Email LIKE '[a-z][a-z][a-z%')