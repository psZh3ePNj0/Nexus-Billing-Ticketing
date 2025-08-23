/*********************************************************************************************
**                                                              							**
** Class Name		: _Run , version 1.0 					    							**
**																							**
** Author        	: Christophe Cartwright                    								**
**																							**
** Position			: IT Developer															**
**																							**				
** Release Date    	: <release_date>		                       							**
**																							**
** Description   	: Implements the Runnable Interface to allow the threads to access the  **
**					: various methods and variables of the  Object.				        	** 
**					:																		**
** Dependencies		: _Thread																**
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

/**Imports**/
import java.sql.*;
 
  public class _NEXUS_Run implements Runnable {
	
		_NEXUS_Module _NEXUS;							// Variable Declaration () of type _Module
		String MyThreadName;							// Variable Declaration (MyThreadName) of type String
		private static boolean LoopForever = true;


	////////////////////////////////////////////////////////////////////////////////////
				
  		public _NEXUS_Run(String ThreadName,_NEXUS_Module HT) {
  		MyThreadName = ThreadName;	
		_NEXUS = HT;}

	///////////////////////////////////////////////////////////////////////////////////////

        public void run() {
        	
        	while (LoopForever){
        
     			try{_NEXUS._Nexus_SubMod(MyThreadName); }
     			
     			catch(Exception e) {
				System.err.print("_NEXUS_Run_Class Exception: ");
				System.err.println(e.getMessage());
				continue;
		   		} 
		   	
     			continue;
     			
     		}		// End of while (LoopForever)
     				
      	}			// End of public void run()
      	
  	}				// End of public class _NEXUS_Run implements Runnable
      	
      	
///////////////////////////////////////////////////////////////////////////////////////////////////////////