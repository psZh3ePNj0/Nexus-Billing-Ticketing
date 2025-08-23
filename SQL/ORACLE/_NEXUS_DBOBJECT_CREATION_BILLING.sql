

--create tablespace <desired_table_tablespace_name>
--datafile '<desired_path>/<desired_table_datafile_name>.dbf' size 32M autoextend on
--online
--permanent
--EXTENT MANAGEMENT LOCAL 
--SEGMENT SPACE MANAGEMENT AUTO
--/


--create tablespace <desired_index_tablespace_name>
--datafile '<desired_path>/<desired_index_datafile_name>.dbf' size 32M autoextend on
--online
--permanent
--EXTENT MANAGEMENT LOCAL 
--SEGMENT SPACE MANAGEMENT AUTO
--/


--------------------------------------------------------------------------------------------


DROP TABLE SCHEMA1.NEXUS_PROFILE;

CREATE TABLE SCHEMA1.NEXUS_PROFILE 
(COLUMN_I NUMBER(22) NOT NULL,
COLUMN_J VARCHAR2(128) NOT NULL,
/*.......*/
COLUMN_K VARCHAR2(128) DEFAULT 'PARENT',
COLUMN_L CHAR(1) DEFAULT 'N')
STORAGE (INITIAL 2048K NEXT 1024K MINEXTENTS 2 MAXEXTENTS 64) 
TABLESPACE "<desired_table_tablespace_name>"
/

CREATE INDEX SCHEMA1.NEXUS_PROFILE_PK
    ON SCHEMA_NAME.NEXUS_PROFILE(COLUMN_I)
TABLESPACE <desired_index_tablespace_name> PCTFREE 0 INITRANS 2 MAXTRANS 255 
STORAGE( INITIAL 81920 MINEXTENTS 1 MAXEXTENTS 2147483645 )
PARALLEL( DEGREE 1 )
LOGGING 
/

--DROP SEQUENCE NEXUS_PROFILE_SEQ;

--WITHIN SCHEMA1
CREATE SEQUENCE NEXUS_PROFILE_SEQ
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    NOMINVALUE
    NOCYCLE
    CACHE 20
    NOORDER
/


------------------------------------------------------------------------------------
--
--Remember to use the user_sleep function in Oracle. Have your DBA the SQL Script below
-- for the appropriate schemauser. Done For Test, vetted, then performed in PROD
--
@ORACLE_HOME/rdbms/admin/userlock.sql;
--
-----------------------------------------------------------------------------------


ALTER USER SCHEMA1 QUOTA UNLIMITED ON <desired_table_tablespace_name>;
ALTER USER SCHEMA1 QUOTA UNLIMITED ON <desired_index_tablespace_name>;

ALTER USER SCHEMA2 QUOTA UNLIMITED ON <desired_table_tablespace_name>;
ALTER USER SCHEMA2 QUOTA UNLIMITED ON <desired_index_tablespace_name>;

--------------------------------------------------------------------------------------------

--DROP TABLE SCHEMA1.NEXUS_RATECODES;

CREATE TABLE SCHEMA1.NEXUS_RATECODES
(COLUMN_I NUMBER(22) NOT NULL,
COLUMN_J VARCHAR2(128) NOT NULL,
/*.......*/
COLUMN_DATE DATE DEFAULT SYSDATE,
CONSTRAINT NEXUS_RATECODES_PK PRIMARY KEY (COLUMN_I) USING INDEX TABLESPACE <desired_index_tablespace_name>)
STORAGE (INITIAL 1024K NEXT 512K MINEXTENTS 2 MAXEXTENTS 64) 
TABLESPACE "<desired_table_tablespace_name>"
/

--------------------------------------------------------------------------------

--DROP TABLE SCHEMA1.NEXUS_ERROR;

CREATE TABLE SCHEMA1.NEXUS_ERROR 
(COLUMN_I VARCHAR2(128) NOT NULL,
COLUMN_J VARCHAR2(128) NOT NULL,
/*.......*/
ERROR_DATE		DATE NOT NULL,
ERROR_MESSAGE		VARCHAR2(255) NOT NULL)
STORAGE (INITIAL 512K NEXT 512K MINEXTENTS 2 MAXEXTENTS 64) 
TABLESPACE "<desired_table_tablespace_name>"
/

--------------------------------------------------------------------------------


--DROP TABLE SCHEMA1.NEXUS_LOCATION_CHILD_ACCOUNTS;

CREATE TABLE SCHEMA1.NEXUS_LOCATION_CHILD_ACCOUNTS
(COMPANY_NAME VARCHAR2(20) NOT NULL,
ACCOUNTID VARCHAR2(10) NOT NULL)
STORAGE (INITIAL 1024K NEXT 512K MINEXTENTS 2 MAXEXTENTS 64) 
TABLESPACE "<desired_table_tablespace_name>"
/


--------------------------------------------------------------------------------------------

