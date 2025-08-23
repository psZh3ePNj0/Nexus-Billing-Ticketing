
/*********************************************************************************************
**                                                              							**
** Class Name		: _Thread, version X			    	    							**
**																							**
** Author        	: Christophe Cartwright                    								**
**																							**
** Position			: IT Developer															**
**																							**
** Release Date    	: <release-date>		                       							**
**																							**
** Description   	: Declares and Instantiates a  Object, and launches				    	**
**					: threads.The threads simultaneously and independently run through the  **
**					: Object to update,  ticket account status._Thread also					**
**					: establishes a socket connection to allow  LinkAnalyst to monitor the	**
**					: module.																**
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
import java.sql.*;
import java.lang.*;
import java.net.*;
import java.io.*;


   public class _NEXUS_Thread {

			private static boolean Loop_Forever = true;
			private static boolean CloseConnection = false;
			private static int ServerPort = _NEXUS_JDBC_Connection._NEXUS_ServerPort;

    		public static void main(String args[]) throws SQLException {

       			_NEXUS_Module HT = new _NEXUS_Module();
       			
       			Thread _NEXUS_1   = new Thread(new _NEXUS_Run("_NEXUS_1",HT));
       			//Thread _NEXUS_2   = new Thread(new _NEXUS_Run("_NEXUS_2",HT));


				_NEXUS_1.setName("_NEXUS_1"); // Name _NEXUS_1 Thread
       			//_NEXUS_2.setName("_NEXUS_2"); // Name _NEXUS_2 Thread


       			try {
       				while(Loop_Forever){
       					
    						//////////////////////////////////////////////////////////		
									// Stagger the threads	
							//////////////////////////////////////////////////////////
				
					
       						_NEXUS_1.start(); 		// Start _NEXUS_1 Thread
       			
       			
       						//////////////////////////////////////////////////////////		
								Thread.currentThread().sleep(1000);	
							//////////////////////////////////////////////////////////
					
					
       						//_NEXUS_2.start(); 		// Start _NEXUS_2 Thread
		
       						return;

					}	//end of while(Loop_Forever){
				
				}	// End of try		

					catch (InterruptedException e) {
		        			System.err.print("Thread Exception: ");
		        			System.err.println(e.getMessage());
		        	}
		        	
		        	
       		}		//end of public static void main(String args[]) throws SQLException


 ///////////////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////////////


}				// end of public class _NEXUS_Thread



