# NHS Number Validation Function

This function takes a UK NHS Number as an input variable and checks to see if that NHS Number is or isn't valid. 

This uses the Modulus 11 algorithm which is mandatory for checking the NHS Number.

https://www.datadictionary.nhs.uk/attributes/nhs_number.html

### Why did you create this? 

After a discussion with one of our clients, we got to talking about NHS Numbers and how they are validated. We did some research and it got us interested so we decided to create a T-SQL function that can validate an NHS Number automatically.

### Functions in views

Remember, [don't use scalar functions in views](https://www.richinsql.com/2021/08/functions-in-views-are-bad/), performance will tank, this function is a decent proof of concept as to how you can validate the NHS Number in your own projects if required.

## Using The Function

It is possible to get dummy NHS Numbers from [here](http://danielbayley.uk/nhs-number/) which you can use for testing this function.

Once you have added the NHS Number to your database of choice, you can use it like this

### Manually passing a value

`SELECT [dbo].[fnNHSValidation_svf]('6043153327')`

### Passing a value from an existing table

`SELECT [dbo].[fnNHSValidation_svf](NHSNumber) FROM Patients`
