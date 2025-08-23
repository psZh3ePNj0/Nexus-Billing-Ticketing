/*****************************************************************
**                                                             	**
** Procedure Name: _NEXUS_CHILD_PROFILE	(Release X)  			**
** Author       : Christophe Cartwright                       	**
** Date         : <SANITIZED: use your desired date>           	**
** Description  : Inserts or Updates a Profile from the 		**
**		: billing application for a Child (Commercial only)		**
**		: sub-profile. Services include Cable, Data and voice	**
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


DROP PROCEDURE _NEXUS_CHILD_PROFILE
GO


CREATE PROCEDURE _NEXUS_CHILD_PROFILE

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

@Output_Temp	integer,
@Output			integer,

@Seq			integer,
@Count			integer

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

SET @Results = <desired_value>


---------------------------------------------------------------------

--Set Child Profile LastName to a Unique LastName
SET @Local_Variable_of_Varchar_Type = <desired_value>

---------------------------------------------------------------------


BEGIN
	
	SET @Count = (select count(<desired_value>) 
			from <schema-user>.<ticketing_services_config_table> 
			where <criterion_1> = <desired_value>
			AND <criterion_2>= <desired_value>
			--......
			AND <criterion_n>= <desired_value>)


	--------------------------------------------------------------------------------------


			---Determine Account Island-----

	EXEC _NEXUS_GET_ACC_ISLAND @<desired_value> ,/*......*/,@<desired_value>,@Output = @Output_Temp OUTPUT
 

	---------------------------------------------------------------------


		-- For Commercial Accounts (sub accounts leveraged ONLY for Commercial Accounts currently) which exist in Billing, 
		-- but have yet to call into the Ticketing Support Desk to create a child profile, 
		-- Create a child profile in ticketing system

	IF (@Count = 0) AND (<criterion_1> ='Commercial') AND (<criterion_2>='Child') AND /*...*/  AND (<criterion_n> = <desired_value>)
		BEGIN 

			SET @Seq = (SELECT MAX(seq) FROM <schema-user>.<ticketing_profile_child_table>)
			SET @Seq = @Seq + 1	
			
					
			INSERT INTO <schema-user>.<ticketing_profile_child_table>
					(Column_PK,
					--....
					Column_i,
					Column_i+1,
					Column_FK_To_Parent,
					--....
					Column_n)


			VALUES 	(@Seq,
					--..
					<criterion_1>,
					<criterion_2>,
					FK_VALUE,
					--...
					<desired_value>)


			-------------------------------------------------------------------------------------------------

			-- Place Incoming Service from Billing into the Ticketing Services Config Table, so that the Profile  
			-- Service Sections Can validate and dynamically be filled in.	

			EXEC _NEXUS_PROFILE_SERVICES <desired_value>,/*......*/ ,<desired_value>,@Output = @Output_Temp OUTPUT

			-------------------------------------------------------------------------------------------------

			SET @Results = @Output_Temp
			
		END


	----------------------------------------------------------------------------------------------------------------
	--============================================================================================================--
	----------------------------------------------------------------------------------------------------------------


	IF (@Count >= 1) AND (<criterion_1>='Commercial') AND (<criterion_2>='Child') AND /*...*/ AND (<criterion_n> = <desired_value>)
		BEGIN 
			
			-- Update the Commercial Child Profile (Accounts Section and Service Section)
			--NOTE: we don't update Column_1 with NEXUS adapter as this contains unique identifier

			UPDATE <schema-user>.<ticketing_profile_child_table>
			SET Column_2 = <desired_value>,
				--....
				Column_i=<criterion_1>,
				Column_i+1 = <criterion_2>,
				--.....
				Column_n = <desired_value>
			WHERE 	Column_1 = <criterion_pk>
			--...
			AND		Column_i=<criterion_1>
			AND		Column_i+1 = <criterion_2>
			--....
			AND		Column_n = <criterion_n>


			-------------------------------------------------------------------------------------------------

			-- Place Incoming Service from Billing into the Ticketing Services Config Table, so that the Profile  
			-- Service Sections Can validate and dynamically be filled in.	

			EXEC _NEXUS_PROFILE_SERVICES <desired_value>,/*......*/,<desired_value>,@Output = @Output_Temp OUTPUT
			-------------------------------------------------------------------------------------------------

			SET @Results = @Output_Temp
				
			
		END



	---------------------------------------------------------------------


END

SELECT @Results

RETURN
GO


/**********************************************************/