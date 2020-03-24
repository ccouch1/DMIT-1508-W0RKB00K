--  Stored Procedures (Sprocs)
-- Demonstrate using Transactions in a Stored Procedure

-- What is a Transaction?
-- A transaction is typicallly needed when we do two or more of an Insert/Update/Delete
-- A transcation must succeed or fail as a group
-- How do we start a Transaction?
-- BEGIN TRANSACTION
--	the BEGIN TRANSACTION only needs to be stated once
-- TO MAKE A TRANSACTION SUCCEED WE USE THE STATEMENT COMMIT TRANSACTION
--	the COMMIT TRANSACTION should only be used once
-- TO MAKE A TRANSACTION FAIL WE USE THE STATEMENT ROLLBACK TRANSACTION
--	We will have one ROLLBACK TRANSACTION for every INSERT/UPDATE/DELETE

USE [A01-School]
GO

/*
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'SprocName')
    DROP PROCEDURE SprocName
GO
CREATE PROCEDURE SprocName
    -- Parameters here
AS
    -- Body of procedure here
RETURN
GO
*/


-- 1.B. create a stored procedure called DissolveClub that wil accept a club id as its parameter. Ensure that the club exists before attempting to dissolve the club you are to dissolve the club by first removing all the memebers of the club and then removing the club itself.
--	-- Delete of rows in the activity table
-- -- delete of row in the club table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DissolveClub')
	DROP PROCEDURE DissolveClub
GO
CREATE PROCEDURE DissolveClub
	--Parameters here
	@ClubId		varchar(10)
AS
	IF @ClubId IS NULL
	Begin
		RAISERROR('ClubId is required', 16, 1)
	END
	BEGIN
		IF NOT EXISTS(SELECT ClubId FROM Club WHERE ClubId = @ClubId)
		BEGIN
			RAISERROR ('That Club Does NOT exist', 16, 1)
		END
		ELSE
		BEGIN 
				-- Transaction:
				BEGIN TRANSACTION--- Starts the transaction- everything is temporary
				--1) Remove members of teh club (from Activity)
				DELETE FROM Activity WHERE ClubId - @ClubId
			
				IF @@ERROR <> 0 -- THEN THERE'S A PROBLEM WITHT EH DELETE NO NEED TO CHECK @@FROMCOUNT
				BEGIN 
					ROLLBACK TRANSACTION --ENDING/UNDOING ANY TEMPORARY DML STATEMENTS
					RAISERROR('Unable to Remove memebers from the club', 16,1)
				END
				ELSE
				BEGIN
					--2) REMOVE THE CLUB
					DELETE FROM Club WHERE ClubId - @ClubId


					COMMIT TRANSACTION -- FINALIZE ALL THE TEMPORARY DML STATEMENTS
				END
			END
		END
	END 
RETURN
GO

-- Test my stored procedure
-- SLEECT * FROM Club
-- SELECT * FROM Activity
EXEC DissolveClub 'CSS'
EXEC DissolveClub 'NASA1'
EXEC DissolveClub 'MMA?'