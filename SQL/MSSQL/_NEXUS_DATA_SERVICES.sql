/*****************************************************************
**                                                             	**
** Procedure Name: _NEXUS_DATA_SERVICES	(Release X)  			**
** Author       : Christophe Cartwright                       	**
** Date         : <SANITIZED: use your desired date>           	**
** Description   : Updates | Creates Customer Data Service 		**
**		 		 : Section										**
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


DROP PROCEDURE _NEXUS_DATA_SERVICES
GO


CREATE PROCEDURE _NEXUS_DATA_SERVICES


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

@Data_Count		integer,
@Output_Temp1 		integer


SET @Output_Temp1= <desired_value>

----------------------------------------------------------------------------------------------
-- Determine if row exists for incoming DATA Service
----------------------------------------------------------------------------------------------

SET @Data_Count = (SELECT count(*) 
			FROM <schema-user>.<ticketing_data_services_table> 
			WHERE <criterion_1> = <desired_value>
			AND <criterion_2>= <desired_value>
			--...... 
			AND <criterion_n>= <desired_value>)



---------------------------------------------------------------------------------------------------

	--Case Values

		-- Case 1 : If no rows exist for incoming DATA Service and status is active, create service
		-- Case 2 : If no rows exist for incoming DATA Service and status is inactive, safely exit
		-- Case 3 : If rows exist for incoming DATA Service and status is inactive, remove service 
		-- Case 4 : If rows exist for incoming DATA Service and status is active, safely exit


----------------------------------------------------------------------------------------------
-- Case 1: If no rows exist for incoming DATA Service and status is active, create service
----------------------------------------------------------------------------------------------

IF(@Data_Count=0) AND (@Input_Variable_of_Varchar_Type=<desired_active_value>)
BEGIN

	INSERT INTO <schema-user>.<ticketing_data_services_table> 	
					Column_PK,
					--....
					Column_n)

			VALUES 	(<PK_desired_value>,
					--....
					<desired_value>)

	Set @Output_Temp1 = <successful_exit_value>
	SELECT @Output_Temp1
	RETURN

END



----------------------------------------------------------------------------------------------
-- Case 2: If no rows exist for incoming DATA Service and status is inactive, safely exit
----------------------------------------------------------------------------------------------


IF(@Data_Count=0) AND (@Input_Variable_of_Varchar_Type=<desired_inactive_value>)

BEGIN
	Set @Output_Temp1 = <successful_exit_value>
	SELECT @Output_Temp1
	RETURN

END




----------------------------------------------------------------------------------------------
-- Case 3: If rows exist for incoming DATA Service and status is inactive, remove service
----------------------------------------------------------------------------------------------

IF(@Data_Count>=1) AND (@Input_Variable_of_Varchar_Type=<desired_inactive_value>)

BEGIN

	DELETE 	FROM <schema-user>.<ticketing_data_services_table>
	WHERE 	Column_1 = <desired_value>
	AND		Column_2 = <desired_value>
			--....
	AND		Column_n = <criterion_n>

	Set @Output_Temp1 = <successful_exit_value>
	SELECT @Output_Temp1
	RETURN

END



----------------------------------------------------------------------------------------------
-- Case 4 : If rows exist for incoming DATA Service and status is active, safely exit
----------------------------------------------------------------------------------------------

IF(@Data_Count>=1) AND (@Input_Variable_of_Varchar_Type=<desired_active_value>)
BEGIN
	Set @Output_Temp1 = <successful_exit_value>
	SELECT @Output_Temp1
	RETURN

END



----------------------------------------------------------------------------------------------

SELECT @Output_Temp1

RETURN
GO

/**********************************************************/


			
