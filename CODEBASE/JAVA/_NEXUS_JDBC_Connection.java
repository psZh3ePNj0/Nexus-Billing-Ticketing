/*********************************************************************************************
**                                                              							**
** Class Name		: _JDBC_Connection, version 1.0			       							**
**																							**
** Author        	: Christophe Cartwright                    								**
**																							**
** Position			: IT Developer															**
**																							**
** Release Date    	: <release_date>		                       							**
**																							**
** Description: 	Declares and Instantiates the JDBC connections for the					**
**					thread connections to the TICKETING  and BILLING DataBases.				**
**					Also it contains the non-default port that the modules					** 
**					establishes a socket connection on. This file							**
**					should be kept secured 													**
**					:																		**
** Dependencies		: none																	**
**					:																		**
** Inputs        	: none																	**
**					:																		**
** Outputs       	: none																	**
**                                                              							**
*********************************************************************************************/

/*********************************************************************************************
**                                                              							**
** Revision History - Please include author, date and change    							**
** details:                                                    								**
**                                                              							**
**                                                              							**
**                                                              							**
**                                                              							**
*********************************************************************************************/


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

/** Packages **/
package com.example1.myhost.nexus;

/** Imports **/
import java.io.*;
import java.util.*;
import java.text.*;

public class _NEXUS_JDBC_Connection{

	protected static String JDBC_Connection1 = "jdbc:oracle:thin:@//myhost.example1.com:<port>/<my-service>";
	protected static String UserName1 = "<desired-schema-name>";
	protected static String Password1 = "<desired-strong-password>";

	protected static String JDBC_Connection2 = "jdbc:jtds:sqlserver://myhost.example1.com:<port>";
	protected static String UserName2 = "<desired-schema-name>";
	protected static String Password2 = "<desired-strong-password>";


	// Port the Modules Sockets listen on to verify with Link Analyst that the service is
	// up and running

	protected static int _NEXUS_ServerPort = desired_server_port;


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


}					// end of _NEXUS_JDBC_Connection_Acct
