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

--DROP PACKAGE _NEXUS_PKG;

CREATE OR REPLACE PACKAGE _NEXUS_APP_PKG
AS


	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_GET_PROFILE_COUNT(out_variable_k OUT NUMBER);

	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_GET_RATECD_INFO(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									in_variable_k IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									out_variable_i OUT VARCHAR2,
									out_variable_j OUT VARCHAR2,
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT NUMBER);

	-------------------------------------------------------------------------------------------------


	PROCEDURE NEXUS_GET_WIPCUSTRATE_INFO(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									in_variable_k IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									out_variable_i OUT VARCHAR2,
									out_variable_j OUT VARCHAR2,
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT NUMBER);

	-------------------------------------------------------------------------------------------------
	
	PROCEDURE NEXUS_GET_CUST_OUTLET(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									in_variable_k IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT VARCHAR2);

	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_GET_CUSTTYPE(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT VARCHAR2);

	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_GET_RELATION(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								in_variable_k IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								out_variable_i OUT VARCHAR2,
								out_variable_j OUT VARCHAR2,
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT NUMBER);


	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_GET_LOCATION(in_variable_i IN VARCHAR2,
									in_variable_j IN VARCHAR2,
									/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
									/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
									out_variable_k OUT VARCHAR2);

	-------------------------------------------------------------------------------------------------


	PROCEDURE NEXUS_GET_CUSTINFO(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								out_variable_i OUT VARCHAR2,
								out_variable_j OUT VARCHAR2,
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_l OUT VARCHAR2,
								out_variable_k OUT NUMBER);


	-------------------------------------------------------------------------------------------------
	
	PROCEDURE NEXUS_GET_CUSTSTAT(in_variable_i IN VARCHAR2,
								in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT VARCHAR2);

	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_GET_HOUSEINFO(in_variable_i IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT VARCHAR2);

	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_DROP_ACCTINFO(in_variable_i IN NUMBER,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT NUMBER);

	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_GET_ACCTINFO(out_variable_i OUT VARCHAR2,
								/*..<ADD_OUT_VARIABLES_AS_NEEDED.....*/
								out_variable_k OUT NUMBER);

	-------------------------------------------------------------------------------------------------

	PROCEDURE NEXUS_PUT_ACCTINFO(in_variable_i IN VARCHAR2,in_variable_j IN VARCHAR2,
								/*..<ADD_IN_VARIABLES_AS_NEEDED.....*/
								in_variable_z IN NUMBER);

	-------------------------------------------------------------------------------------------------

END _NEXUS_APP_PKG;
/