/*****************************************************************
**                                                             	**
** Procedure Name: _NEXUS_PROFILE_SERVICES	(Release X)  		**
** Author       : Christophe Cartwright                       	**
** Date         : <SANITIZED: use your desired date>           	**
** Description  : Invokes one of the SPs (Cable/  Data/ Voice)	**
**		 : Service SPs based on Parameters from Parent/			**
**		 : Child Profile call									**
**																**
** Inputs        : <SANITIZED: use your desired-inputs>, ex:	**
**				@Input_Variable_of_Varchar_Type,				**
**				@Input_Variable_of_Integer_Type					**
**																**
** Outputs       : @Results										**
**                                                              **
*****************************************************************/



/*****************************************************************
**                                                              **
** Revision History - Please include author, date and change    **
** details:                                                     **
**                                                              **
**                                                              **
*****************************************************************/


DROP PROCEDURE _NEXUS_PROFILE_SERVICES
GO


CREATE PROCEDURE _NEXUS_PROFILE_SERVICES


/*************Input Procedure Declarations***********************/

@Input_Variable_of_Varchar_Type			varchar(128),
@Input_Variable_of_Integer_Type			integer,
@Results		integer OUTPUT


WITH ENCRYPTION

AS

---------Local Procedure Variable Declarations-------------------

DECLARE

@Local_Variable_of_Varchar_Type			varchar(128),
@Local_Variable_of_Integer_Type			integer,

@Output_Temp1 		integer,
@Output_Temp2 		integer


---------------------------------------------------------------------
--
--	NOTE to READER: 
--	<desired_value>	would  be: 	
--					@Local_Variable_of_Varchar_Type,
--					@Input_Variable_of_Varchar_Type,
--					constant , constant variable, unique_generated_value,
--					etc...
--
---------------------------------------------------------------------



----------------------------------------------------------------------------------------------
-- Determine which Service SP to call based on Service Type (Cable | Data | Voice)
----------------------------------------------------------------------------------------------


--Cable Services

IF(@Local_Variable_of_Varchar_Type='Cable') 
BEGIN
	EXEC _NEXUS_CABLE_SERVICES @<desired_value> ,/*......*/,@<desired_value>,@Output_Temp1 = @Output_Temp2 OUTPUT

	Set @Output=@Output_Temp2
	SELECT @Output
	RETURN
END


----------------------------------------------------------------------------------------------


--Data Services

IF(@Local_Variable_of_Varchar_Type='Data') 
BEGIN
	EXEC _NEXUS_DATA_SERVICES @<desired_value> ,/*......*/,@<desired_value>,@Output_Temp1 = @Output_Temp2 OUTPUT

	Set @Output=@Output_Temp2
	SELECT @Output
	RETURN
END

----------------------------------------------------------------------------------------------


--Voice Services

IF(@Local_Variable_of_Varchar_Type='Voice') 
BEGIN
	EXEC _NEXUS_VOICE_SERVICES @<desired_value> ,/*......*/,@<desired_value>,@Output_Temp1 = @Output_Temp2 OUTPUT

	Set @Output=@Output_Temp2
	SELECT @Output
	RETURN
END


----------------------------------------------------------------------------------------------


SELECT @Output

RETURN
GO

/**********************************************************/
