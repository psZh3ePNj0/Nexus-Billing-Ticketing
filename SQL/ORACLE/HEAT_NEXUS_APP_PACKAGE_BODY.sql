/*********************************************************************
**                                                              	**
** Package Name		: _NEXUS_PKG	(PHASE I + II)					**
** Author			: Christophe Cartwright							**
** Revision Date	: <appropriate-date>							**
** details			: Groups Stored Procedures (SPs) of common  	**
**					: behavior and functionality into a package		**
**					: This package; an abstraction of the SPs		**
**					: The details are in the _NEXUS_PKG 			**
**					: package body									**
**																	**
*********************************************************************/

/*********************************************************************
**                                                              	**
** Package Name		: _NEXUS_APP_PKG	(Phase III)					**
** Author			: Christophe Cartwright							**
** Revision Date	: <appropriate-date>							**
** details			: Added Stored Procedures (SPs) 	  			**
**					: NEXUS_GET_RATECD_LIMIT,NEXUS_INS_RATECD_LIMIT,**
**					: NEXUS_UPD_CUST_RATE_SEG,NEXUS_CHK_RATECD_LIMIT**
**					: NEXUS_GET_HOUSEINFO & NEXUS_GET_CUSTSTAT to 	**
**					: the _NEXUS_PKG 								**
**																	**
*********************************************************************/

/*********************************************************************
**                                                              	**
** Package Name		: _NEXUS_APP_PKG	(Phase IV)					**
** Author			: Christophe Cartwright							**
** Revision Date	: <appropriate-date>							**
** details			: Removed Stored Procedures (SPs)		 	  	**
**					: NEXUS_GET_RATECD_LIMIT,NEXUS_INS_RATECD_LIMIT,**
**					: NEXUS_CHK_RATECD_LIMIT 						**
** 																	**
** 					: Revised SP NEXUS_PUT_ACCTINFO 				**
**					: Revised SP NEXUS_GET_RATECD_INFO				**
**					: Revised SP NEXUS_GET_WIPCUSTRATE_INFO			**
**					: Revised SP NEXUS_GET_ACCTINFO					**
**																	**
**					: Added SP NEXUS_GET_CUSTTYPE					**
**																	**
*********************************************************************/

/*********************************************************************
**                                                     				**
** Revision History -			        	    					**
** Author			: 			    								**
** Revision Date	: 				    							**
** details			: 				  								**
** 					: 					  							**
**																	**
**********************************************************************/

--DROP PACKAGE BODY _NEXUS_APP_PKG;

CREATE OR REPLACE PACKAGE BODY _NEXUS_APP_PKG
AS

	--####################################################################################################--

	/********************************************************************
	* Author: 	Christophe Cartwright: DBA								*
	* Date:		<appropriate-date>										*
	*																	*
	* Procedure:	NEXUS_GET_PROFILE_COUNT	 (Phase I)					*
	* Description:  Determine row count in Nexus_Profile Table			*
	* Input:	<SANITIZED: use your desired-inputs>					*
	* Output:	Row Total (number)										*
	*																	*
	********************************************************************/

	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/

	PROCEDURE NEXUS_GET_PROFILE_COUNT(out_variable_k OUT NUMBER) IS

	error		varchar2(255);

	BEGIN
		SELECT 	COUNT(*)
		INTO	out_variable_k
		FROM 	schema1.nexus_profile;


	---------------------

	
	EXCEPTION

  		WHEN OTHERS THEN 

			
			error:= SUBSTR(SQLERRM,1,255);
			out_variable_k:=-1;

			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('PROCEDURE -> NEXUS_GET_PROFILE_COUNT','<desired_value>',/*.....*/SYSDATE,error);
	
		-----------------------------------------------

	END NEXUS_GET_PROFILE_COUNT;


	--####################################################################################################--


	/*****************************************************************
	**                                                              **
	** Procedure Name: NEXUS_GET_RATECD_INFO  (Phase I)             **
	** Author        : Christophe Cartwright                        **
	** Date          : <appropriate-date>	                        **
	** Description   : Extracts Service Type from					**
	**               : table schema1.NEXUS_RATECODES    			**
	** Inputs        : <SANITIZED: use your desired-inputs>			**
	** Outputs       : <SANITIZED: use your desired-outputs>		**
	**                                                              **
	*****************************************************************/


	/*****************************************************************
	**                                                         		**
	** Revision History - NEXUS_GET_RATECD_INFO (Phase IV)	        **
	** Author			: Christophe Cartwright						**
	** Revision Date	: <appropriate-date>						** 
	** details			: Customer type now enforced elsewhere. 	**
	** 					: Code here no longer needed and removed	**
	**					: 											**
	******************************************************************/


	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/


	PROCEDURE NEXUS_GET_RATECD_INFO(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									in_variable_k IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									out_variable_i OUT VARCHAR2,
									out_variable_j OUT VARCHAR2,
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT NUMBER) IS


	error		VARCHAR2(255);

	BEGIN

	---------------------------------------------------------------------------------------

	
		SELECT COUNT(DISTINCT(column_i))
		INTO out_variable_k 
		FROM schema1.NEXUS_RATECODES
		WHERE column_k = in_variable_k;


			-----------------------------------------------


			IF(out_variable_k = 1)
			THEN	
				SELECT column_i,column_j/*...*/
				INTO out_variable_i,out_variable_j/*...*/ 
				FROM schema1.NEXUS_RATECODES
				WHERE column_k = in_variable_k;
			
				out_variable_k := -1;

				-----------------

			ELSE
				out_variable_i:='<desired_value>';
				out_variable_j:='<desired_value>';
				/*.....*/
				out_variable_k := -2;

				-----------------

			END IF;

		
		-------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------



	EXCEPTION
  		WHEN OTHERS THEN
			out_variable_i:='<desired_value>';
			/*.....*/
			out_variable_j:='<desired_value>';
			out_variable_k := -2;
	

			error:= SUBSTR(SQLERRM,1,255);

			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('PROCEDURE -> NEXUS_GET_RATECD_INFO','<desired_value>',/*.....*/SYSDATE,error);
	
		-----------------------------------------------

	
	END NEXUS_GET_RATECD_INFO;
	

	--####################################################################################################--


	/*****************************************************************
	**                                                              **
	** Procedure Name: NEXUS_GET_WIPCUSTRATE_INFO  (Phase I)        **
	** Author        : Christophe Cartwright                        **
	** Date          : <appropriate-date>	                        **
	** Description   : Extracts Service Type from					**
	**               : table schema1.NEXUS_RATECODES    			**
	** Inputs        : <SANITIZED: use your desired-inputs>			**
	** Outputs       : <SANITIZED: use your desired-outputs>		**
	**                                                              **
	*****************************************************************/


	/*****************************************************************
	**                                                         		**
	** Revision History - NEXUS_GET_WIPCUSTRATE_INFO (Phase IV)	    **
	** Author			: Christophe Cartwright						**
	** Revision Date	: <appropriate-date>						** 
	** details			: Customer type now enforced elsewhere. 	**
	** 					: Code here no longer needed and removed	**
	**					: 											**
	******************************************************************/


	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/

	PROCEDURE NEXUS_GET_WIPCUSTRATE_INFO(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									in_variable_k IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									out_variable_i OUT VARCHAR2,
									out_variable_j OUT VARCHAR2,
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT NUMBER) IS



	error		VARCHAR2(255);


	BEGIN

	---------------------------------------------------------------------------------------

	
		SELECT COUNT(DISTINCT(column_i))
		INTO out_variable_k 
		FROM schema1.NEXUS_RATECODES
		WHERE column_k = in_variable_k;


			-----------------------------------------------


			IF(out_variable_k = 1)
			THEN	
				SELECT column_i,column_j/*...*/
				INTO out_variable_i,out_variable_j/*...*/ 
				FROM schema1.NEXUS_RATECODES
				WHERE column_k = in_variable_k;
			
				out_variable_k := -1;

				-----------------

			ELSE
				out_variable_i:='<desired_value>';
				out_variable_j:='<desired_value>';
				/*.....*/
				out_variable_k := -2;

				-----------------

			END IF;

		
		-------------------------------------------------------------------------------------------------------
		-------------------------------------------------------------------------------------------------------



	EXCEPTION
  		WHEN OTHERS THEN
			out_variable_i:='<desired_value>';
			out_variable_j:='<desired_value>';
			/*.....*/
			out_variable_k := -2;
	

			error:= SUBSTR(SQLERRM,1,255);

			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('PROCEDURE -> NEXUS_GET_WIPCUSTRATE_INFO','<desired_value>',/*.....*/SYSDATE,error);
	
		-----------------------------------------------

	
	END NEXUS_GET_WIPCUSTRATE_INFO;
	


	--####################################################################################################--

	/************************************************************************
	* Author: 	Christophe Cartwright										*
	* Date:		<appropriate-date>											*
	*																		*
	* ProcedureName:NEXUS_GET_CUST_OUTLET	(Phase II)						*
	* Description: 	Customer Equip Info extracts for  Profile				*
	*																		*
	************************************************************************/


	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/

	PROCEDURE NEXUS_GET_CUST_OUTLET(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									in_variable_k IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT VARCHAR2) IS
		 

	-- Declare Variables and Cursors

	lc_count 	NUMBER;
	error		varchar2(255);

	BEGIN

		-------------------------------------

		SELECT 	COUNT(column_n)
		INTO 	lc_count
		FROM 	schema1.table_i
		WHERE	column_i = in_variable_i
		AND 	column_j = in_variable_j
		/*............*/
		AND 	column_k = in_variable_k;

		-------------------------------------

		IF (lc_count=0) THEN
			out_variable_k:='<desired_value>';
	
		ELSIF (lc_count>=1) THEN	
			SELECT 		MAX(column_n)
			INTO 		out_variable_k
			FROM 		schema1.table_i
			WHERE		column_i = in_variable_i
			AND 		column_j = in_variable_j
			/*............*/
			AND 		column_k = in_variable_k;

		END IF;


	/**********************************************************/

	EXCEPTION
  		WHEN OTHERS THEN
		out_variable_k:='<desired_value>';

		error:= SUBSTR(SQLERRM,1,255);

		INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
		VALUES('PROCEDURE -> NEXUS_GET_CUST_OUTLET','<desired_value>',/*.....*/SYSDATE,error);
		
	/**********************************************************/

	END NEXUS_GET_CUST_OUTLET;



	--####################################################################################################--



	/************************************************************************
	* Author: 	Christophe Cartwright										*
	* Date:		<appropriate-date>											*
	*																		*
	* ProcedureName:NEXUS_GET_CUSTTYPE	(Phase IV)							*
	* Description: 	SP obtains Customer Type		 						*
	*																		*
	* Revision:																*
	* History																*
	*																		*
	************************************************************************/

	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/

	PROCEDURE NEXUS_GET_CUSTTYPE(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT VARCHAR2) IS
		 
	-- Declare Variables and Cursors

	lc_count 		NUMBER;
	lc_variable_k	VARCHAR2(128);
	error			VARCHAR2(255);

	BEGIN

		-------------------------------------

		SELECT 	COUNT(column_i)
		INTO 	lc_count
		FROM 	schema1.table_i
		WHERE	column_i=in_variable_i
		AND 	column_j = in_variable_j;

		-------------------------------------

		IF (lc_count=1) THEN

		/**********************************************************/
	
			SELECT 		column_k
			INTO 		lc_variable_k
			FROM 		schema1.table_i
			WHERE		column_i=in_variable_i
			AND 		column_j = in_variable_j;

			-------------------------------------

			IF lc_variable_k = '<some_value1>' THEN out_variable_k:='Residential';

			ELSIF lc_variable_k ='<some_value2>' THEN out_variable_k:='Commercial';

			/* ........ADD ELSIF CASES IF APPROPRIATE .....*/

			ELSE out_variable_k:='<desired_value>';

			END IF;

			-------------------------------------


		/**********************************************************/

		ELSIF (lc_count<>1) THEN
			out_variable_k:='<desired_value>';
	

		/**********************************************************/

		END IF;


	/**********************************************************/

	EXCEPTION
  		WHEN OTHERS THEN
		out_variable_k:='<desired_value>';

		error:= SUBSTR(SQLERRM,1,255);

		INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
		VALUES('PROCEDURE -> NEXUS_GET_CUSTTYPE','<desired_value>',/*.....*/SYSDATE,error);

	/**********************************************************/

	END NEXUS_GET_CUSTTYPE;



	--####################################################################################################--


	/************************************************************************
	* Author: 	Christophe Cartwright										*
	* Date:		<appropriate-date>											*
	*																		*
	* Procedure		:NEXUS_GET_RELATION	(Phase I)							*
	* Description	:Determine Relation (Parent Account or Child Subsidiary)*
	*				:for  Profile /  Child Profile							*
	** Inputs        : <SANITIZED: use your desired-inputs>					*
	** Outputs       : <SANITIZED: use your desired-outputs>				*
	*																		*
	************************************************************************/

	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/

	PROCEDURE NEXUS_GET_RELATION(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								in_variable_k IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								out_variable_i OUT VARCHAR2,
								out_variable_j OUT VARCHAR2,
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT NUMBER) IS



	lc_variable_i 		VARCHAR2(128):=in_variable_i||in_variable_j;
	lc_variable_j 		VARCHAR2(128);
	lc_variable_l 		VARCHAR2(128);
	/*..<ADD LOCAL VARIABLES AS NEEEDED....*/
	lc_variable_k		NUMBER:=0;

	lc_count		NUMBER;
	error			varchar2(255);

	BEGIN

		/**********************************************************/

			--<<Locations Test>>--

		SELECT 	COUNT(column_l)
		INTO 	lc_variable_k
		FROM 	schema1.NEXUS_LOCATION_CHILD_ACCOUNTS
		WHERE	column_k=in_variable_k
		AND		column_i=lc_variable_i;
		

		--Test to see if Location is a Child Site Location

		IF (lc_variable_k >= 1)
		THEN
			out_variable_i:='Child';
			out_variable_j:=lc_variable_i;
			/*.......*/
			out_variable_k:=99;

			/*********************/


		ELSE 
		
			--<<Complex Test - If the Locations Test above Fails, Get the Customers Complex Number
		
			SELECT 	column_i
			INTO 	lc_variable_j
			FROM 	schema1.table_i
			WHERE	column_i = in_variable_i
			AND		column_j = in_variable_j;
	

			/**********************************************************/

			IF (lc_variable_j <> '<some_value>') AND (trim(lc_variable_j) IS NOT NULL)
			THEN
				SELECT 	MAX(column_l)
				INTO 	lc_variable_l
				FROM 	schema1.table_j
				WHERE	column_j = lc_variable_j;
	
			ELSE 
				out_variable_i:='Parent';
				out_variable_j:=lc_variable_i;
				/*..........*/
				out_variable_k:=-1;
			END IF;	


			---------------------------------------------------
	
			IF (lc_variable_l IS NOT NULL) AND (lc_variable_l<>in_variable_i)
			THEN
				out_variable_i:='Child';
				out_variable_j:=lc_variable_i;
				/*..........*/
				out_variable_k:=-1;

			ELSE 
				out_variable_i:='Parent';
				out_variable_j:=lc_variable_i;
				/*..........*/
				out_variable_k:=-1;
			END IF;	


 		END IF;



	/**********************************************************/
	EXCEPTION
  		WHEN OTHERS THEN
			out_variable_i:='Parent';
			out_variable_j:=lc_variable_i;
			/*..........*/
			out_variable_k:=-2;

			error:= SUBSTR(SQLERRM,1,255);

			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('PROCEDURE -> NEXUS_GET_RELATION','<desired_value>',/*.....*/SYSDATE,error);


	/**********************************************************/

	END NEXUS_GET_RELATION;
	

	--####################################################################################################--

	/*****************************************************************
	**                                                              **
	** Procedure Name: NEXUS_GET_LOCATION  (Phase I)                **
	** Author        : Christophe Cartwright                        **
	** Date          : <appropriate-date>                        	**
	** Description   : Extracts outlet location for account			**
	** Inputs        : <SANITIZED: use your desired-inputs>			**
	** Outputs       : <SANITIZED: use your desired-outputs>		**
	*																**
	*****************************************************************/

	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/

	PROCEDURE NEXUS_GET_LOCATION(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT VARCHAR2) IS

	
	error			varchar2(255);

	BEGIN

		-----------------------------------------------

		SELECT 	column_k
		INTO 	out_variable_k
		FROM 	schema1.table_i
		WHERE	column_i = in_variable_i
		/* .........*/
		AND 	column_j = in_variable_j;

		-----------------------------------------------

	EXCEPTION

		WHEN NO_DATA_FOUND THEN
			out_variable_k:='<desired_value>';
			return;

	  	WHEN OTHERS THEN
			out_variable_k:='<desired_value>';

			error:= SUBSTR(SQLERRM,1,255);
			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('PROCEDURE -> NEXUS_GET_LOCATION','<desired_value>',/*.....*/SYSDATE,error);

		-----------------------------------------------

	END NEXUS_GET_LOCATION;


	--####################################################################################################--



	/************************************************************************
	* Author: 	Christophe Cartwright:										*
	* Date:		<appropriate-date>											*
	*																		*
	* Procedure:	NEXUS_GET_CUSTINFO (Phase I)							*
	* Description:  Customer Core Account Info extracts for  Profile		*
	** Inputs        : <SANITIZED: use your desired-inputs>					*
	** Outputs       : <SANITIZED: use your desired-outputs>				*
	*																		*
	* Revision:	<revision-date>,Christophe Cartwright						*
	* History	Revised NEXUS_GET_CUSTINFO to include dual status 			*
	*			(Phase II)													*
	*																		*
	************************************************************************/

	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/


	PROCEDURE NEXUS_GET_CUSTINFO(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								out_variable_i OUT VARCHAR2,
								out_variable_j OUT VARCHAR2,
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_l OUT VARCHAR2,
								out_variable_k OUT NUMBER) IS


	error			varchar2(255);


	BEGIN	
		
		SELECT 	DISTINCT(i.column_i),i.column_j,/*...*/j.column_l,COUNT(i.column_i)
		INTO 	out_variable_i,out_variable_j,/*...*/,out_variable_l,out_variable_k
		FROM 	schema1.table_i i, schema1.table_j j, schema1.table_k k,schema1.table_l l
		WHERE	i.column_i = in_variable_i
		AND		i.column_j = in_variable_j
		AND		i.column_i = j.column_i
		AND		i.column_j = j.column_j
		AND		i.column_i = l.column_i
		AND		i.column_j = l.column_j
		AND 	i.column_k = k.column_k
		GROUP BY i.column_i,i.column_j,/*...*/j.column_l;


	/**********************************************************/

	EXCEPTION
  		WHEN OTHERS THEN

		out_variable_i:='<desired_value>';
		out_variable_j:='<desired_value>';
		out_variable_l:='<desired_value>';
		/*.....*/
		out_variable_k:=-1;

		error:= SUBSTR(SQLERRM,1,255);

		INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
		VALUES('PROCEDURE -> NEXUS_GET_CUSTINFO','<desired_value>',/*.....*/SYSDATE,error);

		
	/**********************************************************/

	END NEXUS_GET_CUSTINFO;


	--####################################################################################################--


	/************************************************************************
	* Author: 	Christophe Cartwright										*
	* Date:		<appropriate-date>											*
	*																		*
	* Procedure		:	NEXUS_GET_CUSTSTAT (Phase I)						*
	* Description	:  Obtains the customer account status					*
	*																		*
	* Inputs        : <SANITIZED: use your desired-inputs>					*
	* Outputs       : <SANITIZED: use your desired-outputs>					*
	*																		*
	************************************************************************/

	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/


	PROCEDURE NEXUS_GET_CUSTSTAT(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT VARCHAR2) IS


	ln_variable_i 	NUMBER;
	error			varchar2(255);

	BEGIN

		SELECT 	column_n
		INTO	ln_variable_i
		FROM 	schema1.table_i
		WHERE	column_i = in_variable_i
		/*....*/
		AND		column_j = in_variable_j;


		--Determine Account Status--

			IF ln_variable_i = '<some_value>' THEN out_variable_k:='<desired_value>';
				
			ELSIF ln_variable_i = '<some_value>' THEN out_variable_k:='<desired_value>';

			/*...........*/
		
			END IF;

	/**********************************************************/

	EXCEPTION
  		WHEN OTHERS THEN

		out_variable_k:='<desired_value>';
		error:= SUBSTR(SQLERRM,1,255);

		INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
		VALUES('PROCEDURE -> NEXUS_GET_CUSTSTAT','<desired_value>',/*.....*/SYSDATE,error);

		
	/**********************************************************/

	END NEXUS_GET_CUSTSTAT;


	--####################################################################################################--

	
	/************************************************************
	* Author: 	Christophe Cartwright:							*
	* Date:		<appropriate-date>								*
	*															*
	* Procedure:	NEXUS_GET_HOUSEINFO (Phase I)				*
	* Description:  House Stat Account Info extracts for		* 
	*				Ticketing Profile							*
	*															*
	* Inputs        : <SANITIZED: use your desired-inputs>		*
	* Outputs       : <SANITIZED: use your desired-outputs>		*
	*															*
	************************************************************/

	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/


	PROCEDURE NEXUS_GET_HOUSEINFO(in_variable_i IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT VARCHAR2) IS

	-- Declare Variables 
	ln_variable_l 	NUMBER;
	error			varchar2(255);


	BEGIN

		SELECT 	MAX(column_l)
		INTO 	ln_variable_l
		FROM 	schema1.table_i
		WHERE	column_i = in_variable_i;
	
		-----------------------------------------------------------------

			IF(ln_variable_l=-1) THEN 
				out_variable_k:='<desired_value>';
				RETURN;


			ELSIF(ln_variable_l=-2) THEN 
				out_variable_k:='<desired_value>';
				RETURN;

			/* ...... */
		
			END IF;	



	/**********************************************************/

	EXCEPTION
  		WHEN OTHERS THEN

			out_variable_k:='<desired_value>';

			error:= SUBSTR(SQLERRM,1,255);

			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('PROCEDURE -> NEXUS_GET_HOUSEINFO','<desired_value>',/*.....*/SYSDATE,error);

		
	/**********************************************************/

	END NEXUS_GET_HOUSEINFO;


	--####################################################################################################--



	/*************************************************************************
	**																		**
	** Procedure Name: NEXUS_DROP_ACCTINFO	(Phase I)		    			**
	** Author	: Christophe Cartwright										**
	** Revision Date: <appropriate_date>									** 
	** details	: Removes Account info from the NEXUS_PROFILE table  		**
	**																		**
	** Inputs        : <SANITIZED: use your desired-inputs>					**
	** Outputs       : <SANITIZED: use your desired-outputs>				**
	**																		**
	*************************************************************************/


	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/


	PROCEDURE NEXUS_DROP_ACCTINFO(in_variable_i IN NUMBER,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT NUMBER) IS


	in_count 		NUMBER;
	error			varchar2(255);
	-------------------------------------------------------------------------

	BEGIN

		DELETE 
		FROM 	schema1.NEXUS_PROFILE
		WHERE	column_i = in_variable_i;	
		-------------------------------------
		COMMIT;
		-------------------------------------

		SELECT 	COUNT(column_i)
		INTO	in_count
		FROM	schema1.NEXUS_PROFILE
		WHERE	column_i = in_variable_i;

		-------------------------------------

		IF in_count=0 THEN
			out_variable_k:=-1;

		-------------------------------------

		ELSIF in_count>=1 THEN
			out_variable_k:=-2;

		END IF;


	/**********************************************************/
	EXCEPTION
  		WHEN OTHERS THEN out_result:=-2;

		error:= SUBSTR(SQLERRM,1,255);

		INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
		VALUES('PROCEDURE -> NEXUS_DROP_ACCTINFO','<desired_value>',/*.....*/SYSDATE,error);


	/**********************************************************/

	END NEXUS_DROP_ACCTINFO;

	--####################################################################################################--


	/*************************************************************************
	**                                                              		**
	** Procedure Name	: NEXUS_GET_ACCTINFO (Phase I)						**
	** Author			: Christophe Cartwright								**
	** Revision Date	: <appropriate_date>								** 
	** details			: Obtains Account info for the _PROFILE 			**
	**																		**
	** Inputs        : <SANITIZED: use your desired-inputs>					**
	** Outputs       : <SANITIZED: use your desired-outputs>				**
	**																		**
	*************************************************************************/


	/*********************************************************************************
	**                                                         						**
	** Revision History - NEXUS_GET_ACCTINFO (Phase IV)	        					**
	** Author			: Christophe Cartwright										**
	** Revision Date	: 22nd Sept 2009											** 
	** details			: Added CustSLA Field. This will assist in consolidating	**
	** 					: RateCode entries (type, sla) into a single system 		**
	**					: (BILLING)													**
	**																				**
	*********************************************************************************/


	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/


	PROCEDURE NEXUS_GET_ACCTINFO (out_variable_i OUT VARCHAR2,
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT NUMBER) IS


				
	-- Declare Variables 

	cursorx 		NUMBER;
	error			varchar2(255);


	CURSOR 		cur_get_accounts IS
	SELECT 		column_i,column_j,/*....*/column_k
	FROM		schema1.NEXUS_PROFILE
	WHERE		column_i IN (SELECT MIN(column_i) FROM schema1.NEXUS_PROFILE WHERE column_l ='<desired_value>')
	GROUP BY 	column_i,column_j,/*....*/column_k;

	-------------------------------------------------------------------------

	BEGIN

		--Set Output Parameter values to Values never used in BILLING
 
		out_variable_i:=-1;
		out_variable_j:='<desired_value>';
		/* .... */
		out_variable_k:=-1;

	
	------------------------------------------

		OPEN cur_get_accounts;
		LOOP
			FETCH 	cur_get_accounts 
			INTO 	out_variable_i,out_variable_j,/*....*/out_variable_k;

			EXIT WHEN cur_get_accounts%NOTFOUND;


			------------------------------------------
			-- Update Nexus Profile row, so that next fetch only grabs new rows

			UPDATE 	schema1.NEXUS_PROFILE
			SET		column_l='<desired_value>'
			WHERE	column_i=out_variable_i;
			------------------------------------------
			COMMIT;	
			------------------------------------------


		END LOOP;

		CLOSE cur_get_accounts;


	/*********************************************/

	EXCEPTION
		WHEN OTHERS THEN
			out_variable_i:=-1;
			out_variable_j:='<desired_value>';
			/* .... */
			out_variable_k:=-1;

			error:= SUBSTR(SQLERRM,1,255);

			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('PROCEDURE -> NEXUS_GET_ACCTINFO','<desired_value>',/*.....*/SYSDATE,error);


	/*********************************************/
	
	END NEXUS_GET_ACCTINFO;



	--####################################################################################################--

	
	/*********************************************************************
	**																	**
	** Procedure	: NEXUS_PUT_ACCTINFO (Phase I)		        		**
	** Author		: Christophe Cartwright								**
	** Revision Date: <appropriate_date>								** 
	** Details		: Revised GetStatus SP to pull additional fields	**
	** 				: for the NEXUS Profile								**
	**																	**
	** Inputs        : <SANITIZED: use your desired-inputs>				**
	** Outputs       : <SANITIZED: use your desired-outputs>			**
	**																	**
	*********************************************************************/


	/*****************************************************************
	**                                                              **
	** Revision History - 											**
	**																**
	** Procedure	: NEXUS_PUT_ACCTINFO (Phase III)	        	**
	** Author		: Christophe Cartwright							**
	** Revision Date: <appropriate_date>							** 
	** Details		: Revised NEXUS_PUT_ACCTINFO to include more	**
	** 				: Status (Active, Dual, Disc, etc). Added		**
	**				: Code Class and Type to further distinguish 	**
	** 				: between Commercial vrs Residential and Cable,	**
	**				: Data and voice Services						**
	**																**
	*****************************************************************/


	/*****************************************************************
	**                                                              **
	** Revision History - 											**
	**																**
	** Procedure	: NEXUS_PUT_ACCTINFO (Phase IV)		        	**
	** Author		: Christophe Cartwright							**
	** Revision Date: <appropriate_date>							** 
	** Details		: Revised NEXUS_PUT_ACCTINFO to incorporate		**
	** 				: Customer SLAs (from their service). Obtaining	**
	**				: Customer Type (Residential, Commercial, etc)	**
	** 				: also revised in new SP (NEXUS_GET_CUSTTYPE)	**
	**																**
	*****************************************************************/


	/*****************************************************************
	**                                              				**
	** Revision History - 					        				**
	** Author		: 												**
	** Revision Date: 												**
	** details		: 												**
	** 				: 												**
	*****************************************************************/



	PROCEDURE NEXUS_PUT_ACCTINFO (in_variable_i IN VARCHAR2,in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								in_variable_z IN NUMBER) IS

	-------------------------------------------------------------------------


	-- Declare Local Variables and Cursors

	local_variable_i 		VARCHAR2(128);
	local_variable_j 		VARCHAR2(128);
	local_variable_k 		NUMBER;
	local_variable_l 		VARCHAR2(128);	
	local_variable_m 		VARCHAR2(128);
	local_variable_n 		VARCHAR2(128);
	local_variable_o 		VARCHAR2(128);
	/* ..... */
	local_variable_u 		VARCHAR2(128);
	local_variable_v 		VARCHAR2(128);	
	local_variable_w 		VARCHAR2(128);
	local_variable_x 		VARCHAR2(128);
	local_variable_y		VARCHAR2(128);
	local_variable_z		NUMBER;

	error			varchar2(255);

	BEGIN


		----------------------------------------------------------------------------------------------------

			-- Get the Core Account Info for a Customer by calling the Stored Procedure NEXUS_GET_ACCTINFO

	
		_NEXUS_APP_PKG.NEXUS_GET_CUSTINFO(in_variable_i,in_variable_j,/*...*/local_variable_i,local_variable_j,
											/*...*/local_variable_n,local_variable_z);


		----------------------------------------------------------------------------------------------------

		_NEXUS_APP_PKG.NEXUS_GET_CUSTSTAT(in_variable_i,in_variable_j,/*...*/local_variable_y);

		----------------------------------------------------------------------------------------------------

				--Check to See the House Status -> 

		_NEXUS_APP_PKG.NEXUS_GET_HOUSEINFO(in_variable_i,/*...*/local_variable_x);


			IF(local_variable_x='<desired_value>') AND (LENGTH(local_variable_n)=6) THEN 
				local_variable_x:='<new_desired_value>';
			END IF;

		----------------------------------------------------------------------------------------------------

			-- Get the Equip for a Customer by calling the Stored Procedure NEXUS_GET_CUST_OUTLET

		_NEXUS_APP_PKG.NEXUS_GET_CUST_OUTLET(in_variable_i,in_variable_j,/*...*/local_variable_w);
		
		----------------------------------------------------------------------------------------------------

			-- Get the Customer Type by calling the Stored Procedure NEXUS_GET_CUSTTYPE

		_NEXUS_APP_PKG.NEXUS_GET_CUSTTYPE(in_variable_i,in_variable_j,/*...*/local_variable_v);
		
		----------------------------------------------------------------------------------------------------

		-- Get the Relation Of an account by calling the Stored Procedure NEXUS_GET_RELATION


								-----Residential TYPES => Parent in Ticketing System

		IF (local_variable_v = 'Residential') 
		THEN 
			local_variable_u:='Parent';
			local_variable_o:='<desired_value>'; 	
		END IF;

								----Commercial TYPES => Parent / Child (local_variable_u)

		IF (local_variable_v = 'Commercial')
		THEN
			_NEXUS_APP_PKG.NEXUS_GET_RELATION(local_variable_i,local_variable_j,in_variable_z,
										/*...*/local_variable_u,local_variable_o,/*...*/local_variable_k);

		END IF;

		----------------------------------------------------------------------------------------------------

		IF (out_variable_u = 'Child') AND (local_variable_k=99)
		THEN
			local_variable_l:=in_variable_z;
		END IF;

		----------------------------------------------------------------------------------------------------

			--Enter COllected info into NEXUS_PROFILE table
 
		IF (local_variable_z = 1)
		THEN

			local_variable_m:= local_variable_i || local_variable_j;

		--------------------------------------

			INSERT INTO schema1.NEXUS_PROFILE 
        	   		(column_a,
					column_b,
					column_c,
					column_d,
					column_e,
					/*....*/
					column_i,
					column_j,
					column_k,
					column_l,
					/*...*/
					column_z
					)

    			VALUES
				(schema1.NEXUS_PROFILE_SEQ.NEXTVAL,
				local_variable_m,
				local_variable_v,
				local_variable_y,
				local_variable_l,
            	/*....*/            	
				local_variable_w,
				local_variable_u,
				local_variable_o,
				local_variable_x,
				/*....*/
				'<desired_value>');

		-----------------------------------------------

  		END IF;

		-----------------------------------------------

	EXCEPTION
  		WHEN OTHERS THEN

		error:= SUBSTR(SQLERRM,1,255);

		INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
		VALUES('PROCEDURE -> NEXUS_PUT_ACCTINFO','<desired_value>',/*.....*/SYSDATE,error);


	END NEXUS_PUT_ACCTINFO;


	--####################################################################################################--

END _NEXUS_APP_PKG;
/