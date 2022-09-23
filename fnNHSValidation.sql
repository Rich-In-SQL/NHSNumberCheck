CREATE FUNCTION fnNHSValidation_svf (@NHSNumber varchar(11))

RETURNS BIT

/* ----------------------------------------------------------------------------------------------------------------------- 

-- NHS Number Validility Checker

-- Created By: Rich In SQL
-- Created Date: 23/09/2022

-- https://www.datadictionary.nhs.uk/attributes/nhs_number.html
-- The NHS NUMBER is 10 numeric digits in length. The tenth digit is a check digit used to confirm its validity. 
-- The check digit is validated using the Modulus 11 algorithm and the use of this algorithm is mandatory. 
-- There are 5 steps in the validation of the check digit:
-- Step 1 Multiply each of the first nine digits by a weighting factor
-- Step 2 Add the results of each multiplication together. 
-- Step 3 Divide the total by 11 and establish the remainder. 
-- Step 4 Subtract the remainder from 11 to give the check digit. 
-- If the result is 11 then a check digit of 0 is used. If the result is 10 then the NHS NUMBER is invalid and not used. 
-- Step 5 Check the remainder matches the check digit. If it does not, the NHS NUMBER is invalid. 

-- Version history can be found in GitHub

----------------------------------------------------------------------------------------------------------------------- */

AS

BEGIN

	DECLARE 
		@NHSLength INT,
		@CheckDigit INT,
		@Calculation INT,
		@ValidNumber BIT,
		@NumericCheck BIT

	/* Replace any spaces in the NHS Number */
	SET @NHSNumber = REPLACE(@NHSNumber,' ','')

	/*Make sure that the NHS Number is actually numeric */
	IF @NHSNumber NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' SET @NumericCheck = 0 ELSE SET @NumericCheck = 1

	/* Only calculate is the NHS Number is numberic, otherwise set to invalid */
	IF (@NumericCheck = 1)
	BEGIN

	/* Get the length of the NHS Number */
	SET @NHSLength = LEN(@NHSNumber)

	/* 
	Get each value at it's corrosponding position
	Multiply each of the first nine digits by a weighting factor and add them together 
	*/
	SET @Calculation = 
	(
		(SUBSTRING(@NHSNumber,1,1) * 10.0) + 
		(SUBSTRING(@NHSNumber,2,1) * 9.0) + 
		(SUBSTRING(@NHSNumber,3,1) * 8.0) + 
		(SUBSTRING(@NHSNumber,4,1) * 7.0) + 
		(SUBSTRING(@NHSNumber,5,1) * 6.0) +
		(SUBSTRING(@NHSNumber,6,1) * 5.0) +
		(SUBSTRING(@NHSNumber,7,1) * 4.0) +
		(SUBSTRING(@NHSNumber,8,1) * 3.0) +
		(SUBSTRING(@NHSNumber,9,1) * 2.0)
	)

	SET @CheckDigit = SUBSTRING(@NHSNumber,10,1)

	/* Divide the total by 11 and establish the remainder */
	SET @Calculation = 11 - (@Calculation % 11)

	/* If the NHS Number is 10 digits long and the calculation matches the 10th digit it is valid */
	IF (@NHSLength = 10 AND @Calculation = @CheckDigit)

	/* NHS Number is valid*/
	SET @ValidNumber = 1 

	/* NHS Number is invalid */
	ELSE SET @ValidNumber = 0

	END

	ELSE 

	BEGIN
		/* NHS Number is invalid */
		SET @ValidNumber = 0
	END

	/* Return the validity to the user */
	RETURN @ValidNumber

END