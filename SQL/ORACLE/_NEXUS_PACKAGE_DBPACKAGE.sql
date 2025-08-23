--CREATE OR REPLACE PACKAGE _NEXUS_CRS_PKG
--AS
--	type ridArray is table of rowid index by binary_integer;
--	newVals ridArray;
--	empty   ridArray;
--END;
--/



--DROP PACKAGE _NEXUS_CRS_PKG;

-----------------------------------------------------------------------------

--CREATE OR REPLACE PACKAGE _NEXUS_WIP_PKG
--AS
--	type ridArray is table of rowid index by binary_integer;
--	newVals ridArray;
--	empty   ridArray;
--END;
--/


--DROP PACKAGE _NEXUS_WIP_PKG;


-----------------------------------------------------------------------------

--DROP PACKAGE _NEXUS_CUSTINFO_CURSOR_PKG;


CREATE OR REPLACE PACKAGE _NEXUS_CUSTINFO_CURSOR_PKG
AS
	TYPE CURSORTYPE IS REF CURSOR;
END;
/


-----------------------------------------------------------------------------


