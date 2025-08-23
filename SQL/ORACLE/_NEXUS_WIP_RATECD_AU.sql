/*************************************************************************************
**                                                                					**
** Trigger Name : _NEXUS_WIP_RATECD_AU	          									**
** Author       : Christophe Cartwright                          					**
** Date         : [release-date]													**
** Description  : When features on an account are modified for BILLING				**
**				: services, the Account info is captured and						**
**				: transferred to the outbound NEXUS_PROFILE	 table					**
**																					** 
** Inputs       : none					       										**
** Outputs      : none					 											**
**                                                            						**
** Acknowledgements: https://oracle-base.com/articles/9i/mutating-table-exceptions	**
**																					**
*************************************************************************************/

/*****************************************************************
**                                                              **
** Revision History - Please include author, date and change    **
** details:                                                     **
**                                                              **
**                                                              **
*****************************************************************/

--DROP TRIGGER _NEXUS_WIP_RATECD_AU;

CREATE OR REPLACE TRIGGER _NEXUS_WIP_RATECD_AU

AFTER			UPDATE OF column_i   
ON	 			TABLE_J
FOR EACH ROW

DECLARE

local_variable_i			VARCHAR2(128);
local_variable_j			VARCHAR2(128);
--	.......
-- 	ADD APPROPRIATE VARIABLES WHERE NEEDED
--	.......
local_variable_n 			NUMBER;
local_variable_o			VARCHAR2(128);
local_variable_r			NUMBER;
error						VARCHAR2(255);			


BEGIN

	
		--Check to See if conditions have genuinely changed (from active to disconnected / vice versa / etc)

		IF (:old.column_r <> :new.column_r) THEN

			--===========================================================================================================--
			IF (:new.column_r='+') THEN local_variable_r:=1;
			ELSIF (:new.column_r='-') THEN local_variable_r:=0;
			END IF;		


			--===========================================================================================================--	

			_NEXUS_APP_PKG.NEXUS_GET_WIPCUSTRATE_INFO(:new.column_i,:new.column_j,:new.column_k,/*.....*/local_variable_i,local_variable_j,
			/*.....*/local_variable_n);

			--===========================================================================================================--	


			_NEXUS_APP_PKG.NEXUS_GET_LOCATION(:new.column_i,:new.column_j,/*.....*/local_variable_o);

			--===========================================================================================================--	

			IF (local_variable_n = 0) THEN
	
				--Sleep for 10 ms
				sys.user_lock.sleep(10);

				_NEXUS_APP_PKG.NEXUS_PUT_ACCTINFO(:new.column_i,:new.column_j,:new.column_m,local_variable_i,local_variable_j,
				local_variable_r,/*...*/local_variable_o);

			END IF;

			--===========================================================================================================--	

		END IF;

/**********************************************************/

EXCEPTION

  		WHEN OTHERS THEN 

		------------------------------------------------------

			error:= SUBSTR(SQLERRM,1,255);

			INSERT INTO SCHEMA.NEXUS_ERROR(column_object_name,column_desired_value,/*.....*/column_date,column_error)
			VALUES('TRIGGER -> _NEXUS_WIP_RATECD_AU','<desired_value>',/*.....*/SYSDATE,error);


/**********************************************************/

END _NEXUS_WIP_RATECD_AU;
/