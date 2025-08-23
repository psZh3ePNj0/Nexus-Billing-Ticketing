/*****************************************************************
**                                                              **
** Procedure Name: _NEXUS_GET_ACC_ISLAND	(Release X)         **
** Author        : Christophe Cartwright                        **
** Date         : <SANITIZED: use your desired date>           	**
** Description  : Determine the Correct Island for the Profile  **
**																**
** Inputs        : <SANITIZED: use your desired-inputs>, ex:	**
**				@Input_Variable_of_Varchar_Type,				**
**				@Input_Variable_of_Integer_Type					**
**																**
** Outputs       : @OUTPUT										**
**                                                              **
*****************************************************************/


/*****************************************************************
**                                                              **
** Revision History - Please include author, date and change    **
** details:                                                     **
**                                                              **
**                                                              **
*****************************************************************/


DROP PROCEDURE _NEXUS_GET_ACC_ISLAND
GO


CREATE PROCEDURE _NEXUS_GET_ACC_ISLAND


/*************Input Procedure Declarations***********************/

@Input_Variable_of_Varchar_Type			varchar(128),
@Input_Variable_of_Integer_Type			integer,
@OUTPUT		varchar(128) OUTPUT

WITH ENCRYPTION

AS


----------------------------------------

BEGIN

		---Determine Account Island-----

	IF (Input_Variable_of_Integer_Type= <desired_value>) 
		BEGIN
			SET @OUTPUT = <desired_value>
		END

	--.....
	--.....

	ELSE IF (Input_Variable_of_Integer_Type= <desired_value>)
		BEGIN
			SET @OUTPUT = <desired_value>
		END


	ELSE
		BEGIN
			SET @OUTPUT = <desired_value>
		END


END

	-----------------------------------------------------

RETURN
GO

