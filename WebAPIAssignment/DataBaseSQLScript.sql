--Create database AssignmentBank
CREATE DATABASE AssignmentBank; 
GO

--Create Table BankCard
CREATE TABLE [dbo].[BankCard] (
    [Id]     INT          IDENTITY (1, 1) NOT NULL,
    [CardNo] VARCHAR (16) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

--Insert dummy data to test
INSERT INTO BankCard VALUES ('4111222233334444')
INSERT INTO BankCard VALUES ('5111222233334444')
INSERT INTO BankCard VALUES ('341122223333444')
INSERT INTO BankCard VALUES ('371122223333444')
INSERT INTO BankCard VALUES ('3528222233334444')
INSERT INTO BankCard VALUES ('3589222233334444')
INSERT INTO BankCard VALUES ('3588222233334444')
INSERT INTO BankCard VALUES ('1111222233334444')
GO

--Create stored procedure usp_ValidateBankCard
CREATE PROCEDURE [dbo].[usp_ValidateBankCard]
	@CardNumber varchar(16),
	@ExpiryDate varchar(6),
	@Result varchar(20) OUTPUT,
	@CardType varchar(10) OUTPUT
AS

	DECLARE @CardNoLengh INT = LEN(@CardNumber), @ExpiryYear INT = RIGHT(@ExpiryDate,4)

	SELECT @Result = 'Invalid', @CardType = 'Unknown'

	--Does not exist in Database
	IF NOT EXISTS(SELECT CardNo FROM BankCard WHERE CardNo=@CardNumber)
	  SET @Result = 'Does not exist'

	--Amex
	ELSE IF @CardNoLengh = 15
	BEGIN 
	    IF (LEFT(@CardNumber, 2) = '34' OR LEFT(@CardNumber, 2) = '37')
		SELECT @Result = 'Valid', @CardType = 'Amex'
	END

	ELSE IF @CardNoLengh = 16
	BEGIN 
	--Visa
	IF (LEFT(@CardNumber, 1) = '4')
	  BEGIN
		--Validate Leap Year
		IF ((@ExpiryYear % 4 = 0 AND @ExpiryYear % 100 != 0) OR @ExpiryYear % 400 = 0)
		  SELECT @Result = 'Valid', @CardType = 'Visa'
	  END
	
	--Master
	ELSE IF (LEFT(@CardNumber, 1) = '5')
	   --Validate Prime Year
		DECLARE @i INT = 2, @IsPrimeYear BIT = 1
		WHILE (@i<@ExpiryYear)
		BEGIN
			if(@ExpiryYear % @i = 0)
			BEGIN
				SET @IsPrimeYear = 0
				BREAK
			END
			SET @i += 1
		END
		
		IF @IsPrimeYear = 1
		  SELECT @Result = 'Valid', @CardType = 'Master'

	ELSE IF (CAST(LEFT(@CardNumber, 4) AS INT) >= 3528 AND CAST(LEFT(@CardNumber, 4) AS INT) <= 3589 )
		SELECT @Result = 'Valid', @CardType = 'JCB'
	END