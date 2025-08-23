/*****************************************************************
**                                                             	**
** Procedure Name: _NEXUS_PARENT_PROFILE	(Release X)  		**
** Author       : Christophe Cartwright                       	**
** Date         : <SANITIZED: use your desired date>           	**
** Description  : Inserts or Updates a Profile from the 		**
**		: billing application for a Parent (Res / Comm)			**
**		: profile. Services include Cable, Data and voice		**
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


DROP PROCEDURE HEAT_NEXUS_PARENT_PROFILE
GO


CREATE PROCEDURE HEAT_NEXUS_PARENT_PROFILE

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


BEGIN
	
	SET @Count = (select count(<desired_value>) 
			from <schema-user>.<ticketing_profile_parent_table> 
			where <criterion_1> = <desired_value>
			AND <criterion_2>= <desired_value>
			--...... 
			AND <criterion_n>= <desired_value>)


	---------------------------------------------------------------------

			---Determine Account Island-----

	EXEC _NEXUS_GET_ACC_ISLAND @<desired_value> ,/*......*/,@<desired_value>,@Output = @Output_Temp OUTPUT
 

	---------------------------------------------------------------------

		-- For Accounts [Residential or Commercial) which exist in Billing, but have yet to call into the Ticketing Support Desk 
		-- to create a parent profile, Create a parent profile in ticketing system


	IF (@Count =0) AND (<criterion_1> ='Commercial' OR  <criterion_1>='Residential') AND (<criterion_2>='Parent')  AND ... AND (<criterion_n> = <desired_value>)

		BEGIN 

			INSERT INTO <schema-user>.<ticketing_profile_parent_table>
					(Column_PK,
					--....
					Column_i,
					Column_i+1,
					Column_UNIQUE_KEY_To_Child,
					--....
					Column_n)


			VALUES 	(<PK_desired_value>,
					--....
					<criterion_1>,
					<criterion_2>,
					<UNIQUE_KEY_VALUE_IF_APPLICABLE>,
					--....
					<desired_value>)


			-------------------------------------------------------------------------------------------------

			-- Place Incoming Service from Billing into the Ticketing Services Config Table, so that the Profile  
			-- Service Sections Can validate and dynamically be filled in.	

			EXEC _NEXUS_PROFILE_SERVICES <desired_value>,/*......*/,<desired_value>,@Output = @Output_Temp OUTPUT

			-------------------------------------------------------------------------------------------------

			SET @Results = @Output_Temp
			
		END


	----------------------------------------------------------------------------------------------------------------
	--============================================================================================================--
	----------------------------------------------------------------------------------------------------------------


	-- For Accounts which exist in BILLING and TICKETING and need updating, and <criterion_1> is known

	IF (@Count >=1) AND (<criterion_1> ='Commercial' OR  <criterion_1>='Residential') AND (<criterion_2>='Parent')  AND ... AND (<criterion_n> = <desired_value>)

		BEGIN 

			-- Update the Commercial Child Profile (Accounts Section and Service Section)
			--NOTE: we don't update Column_1 with NEXUS adapter as this contains unique identifier

			UPDATE <schema-user>.<ticketing_profile_parent_table>
			SET Column_2 = <desired_value>,
				--....
				Column_i=<criterion_1>,
				Column_i+1 = <criterion_2>,
				--.....
				Column_n = <desired_value>
			WHERE 	Column_1 = <desired_value>
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

	----------------------------------------------------------------------------------------------------------------
	--============================================================================================================--
	----------------------------------------------------------------------------------------------------------------
	

END

SELECT @Results

RETURN
GO


/**********************************************************/