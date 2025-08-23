
/*****************************************************************************************************
** Class Name: 		: _NEXUS_Module, Version X														**
**					:																				**
** Author: 			: Christophe Cartwright															**
**					:																				**
** Position: 		: Oracle Resource, IT Developer													**
**					:																				**
** Release Date: 	: <release-date>																**
**					:																				**
** Description: 	: Automatically Creates | Updates  Residential and Commercial (Parent 			** 
**					: or Child) profiles from Billing.												**
**					:																				**
**	Release 4		:																				**
**  Add On features	:																				**
**					: All Services (Cable,Data & Voice) are now automatically created | updated		**	
**					: with there associated equipment and outlet. Customer status is more granular	**
**					: (Active,Disc,Inactive,Pending Restart,etc). Finally house status is			**
**					: introduced (Active, Never,Dual,Plant,Disconnect).								**
**					:																				**
** Dependencies:	:																				** 	
**					:																				**
**					: Classes:																		**
**					:			_NEXUS_JDBC_Connection_Acct											**
**					:			_NEXUS_Run															**
**					:			_NEXUS_Thread														**
**					:																				**
**					: Stored Procedures:															**
**					:					 MSSQL 2005:												**
**					:									_NEXUS_GET_ACC_ISLAND						**
**					:									_NEXUS_GET_SLA								**
**					:									_NEXUS_SERVICETYPE							**
**					:									_NEXUS_PARENT_PROFILE						**
**					:									_NEXUS_PARENT_UPD_COMM						**
**					:									_NEXUS_CHILD_PROFILE						**
**					:									_NEXUS_CHILD_UPD_COMM						**	
**					: Triggers:																		**
**					:					BILLING Oracle 9i:											**
**					:									_NEXUS_CUST_EQUIP							**
**					:									_NEXUS_ACCTACT_RATECD						**      
**					:									_NEXUS_ACCTPND_RATECD						**
** 					:									_NEXUS_RATECD_STATUS						**
**					: Packages:																		**
**					:					BILLING Oracle 9i:											**
**					:									_NEXUS_PACKAGE								**	
**					: Tables:																		**
**					:					 MSSQL 2005:												**
**					:						Cable/Data/Voice Services. Child + Parent Profiles		**
**					:																				**
**					:					BILLING Oracle 9i:											**
**					:									<SCHEMA>.NEXUS_PROFILE 						**
**					:									<SCHEMA>.NEXUS_RATECODES					**
**					:									<SCHEMA>.NEXUS_LOCATION_CHILD_ACCOUNTS		**
**					:									<SCHEMA>.NEXUS_ERROR						**
**					:									<SCHEMA>.NEXUS_RATECD_LIMIT					**
**					:																				**
** 	Input:	 		: Thread-Name																	**
** 	Output: 		: None																			**
**																									**
*****************************************************************************************************/

/*****************************************************************************************************
**                                                              									**
** Revision History - Please include author, date and change details:								**
**                                                     												**
**                                                              									**
**                                                              									**
**                                                              									**
**                                                              									**
******************************************************************************************************/


//////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////


	/** Packages **/
	package com.example1.myhost.nexus;


	/** Imports **/
	import java.sql.*;
	import java.io.*;
	import java.lang.*;
	import java.util.*;
	import java.text.*;
	import oracle.jdbc.driver.*;
	import javax.mail.*;
	import javax.mail.internet.*;


 public class _NEXUS_Module
 {

////////////////////////////////////////////////////////////////////////////////

	////////Variable  Declaration and Initialisation /////////////////

			private boolean Pool_ = true;
     		private boolean continue_loop = true;
		
    	    private String SysDateTime = "";
    		private String FileDateTime = "";
			private String BILLINGBackUp_LowerBound = "";
			private String BILLINGBackUp_UpperBound = "";
    	
			
			//Counters//
			private double Static_Global_Counter = 80.000;
			private double Dynamic_Global_Counter;
			private double Dynamic_Local_Counter;
			
			private double Emergency_Counter = 0.010;
			private int Emergency_Interval = 10;		
			private double Peak_Counter = 2.000;
			private int Peak_Interval = 1999;
			private double Normal_Counter = 4.000;
			private int Normal_Interval = 3999;
			private double GraveYard_Counter = 8.000;
			private int GraveYard_Interval = 7999;
			
			//Email Counter to send if there is a backlog
			private int Send_Email_Count = 0;
			
			//Thread Variables
			private String BILLINGBackUpBeginI = "BILLING Full Offline backup starting. Placing NEXUS in dormant state.";
			private int Display = 0;
			private int _NEXUS_IO = -1;
			private int Log_Message = -1;
			private int Thread_Sleep_Interval = 1000;
			
			
			//Suspend Counters - used to put Adapter to Sleep if Database connections fail after 10 tries
					
			private int Suspend_Billing_Thread = 0;	
			private int Suspend__Thread = 0;			
			private int Thread_Suspend_Sleep_Interval = 3600000; 	//To Make Adapter Sleep for 1 hr if connection to
																	//Billing or Provisioning Server is not Established

////////////////////////////////////////////////////////////////////////////////


  		static{
       			 try {
	    				// Load the MS SQL 2005 and Oracle 9i JDBC drivers

           				Class.forName("net.sourceforge.jtds.jdbc.Driver");
       					DriverManager.registerDriver( new oracle.jdbc.driver.OracleDriver());

       											/*******/

    					}	catch (ClassNotFoundException e) {
      							System.err.print("ClassNotFoundException: ");
		        				System.err.println(e.getMessage());
            				}


            				catch(SQLException e) {
		        			System.err.print("SQLException1: ");
		        			System.err.println(e.getMessage());
		        			}

    	 			}		// end of static



/*************************************************************************************************************
 **																											**
 **										METHODS DECLARATION AND INSTANTIATION             					**
 **																											**
 ************************************************************************************************************/



		public void _Nexus_SubMod(String ThreadName) {


         			  // Identify the Thread and Obtain the SysTime that thread began to Process //
         		
         		SysDateTime = DisplayDateTime(1);
      			System.out.println("SysDateTime launch for " + ThreadName + " is: " + SysDateTime);
				System.out.println(ThreadName + " activated and online for service.");

					// Set the initial BILLING Lower and Upper Bound BackUp Dates to Process //
					
				BILLINGBackUp_LowerBound = SetInitial_BILLING_BackUP_Date(0);
				BILLINGBackUp_UpperBound = SetInitial_BILLING_BackUP_Date(1);
							
				
				//Dynamic_Global_Counter
				
				Dynamic_Global_Counter = Static_Global_Counter;
				Dynamic_Local_Counter = Peak_Counter;
				Thread_Sleep_Interval = Peak_Interval;
				
				
				while(Pool_) {


      				try{ //superset Try			


    					SysDateTime = DisplayDateTime(1);

    									////////////////******************///////////////////

    					if(SysDateTime.equals(BILLINGBackUp_LowerBound)  ||  ( (SysDateTime.compareTo(BILLINGBackUp_LowerBound) > 0)
    							&& (SysDateTime.compareTo(BILLINGBackUp_UpperBound) < 0) )  ) {

 								//Get the Current Date-Time
 								SysDateTime = DisplayDateTime(1);
 								System.out.println('\n');
      							System.out.println(BILLINGBackUpBeginI);
      					      							
								// Set the next weeks LowBound and Upper bound Dates for 
								// the BILLING Offline Backup and log the new values								
      							Set_BILLING_OfflineBackUp_Dates();
      							System.out.println("BILLINGBackUp time for next week is: " + BILLINGBackUp_LowerBound);
								//System.out.println("BILLINGBackUp_LowerBound time for next week is: " + BILLINGBackUp_UpperBound); 						
      							System.out.println('\n');							
								
								//Make the thread sleep (95mins) so that accounts aren't refreshed multiple times
								Thread_Sleep_Interval=5700000;
								Thread.currentThread().sleep(Thread_Sleep_Interval);
								
								
								System.out.println(" NEXUS is back online for service");
					
								
    					}       // end of if (  (SysDateTime.equals(BILLINGBackUp_LowerBound)  ||  ( (SysDateTime.compareTo(BILLINGBackUp_LowerBound) > 0)
    							// && (SysDateTime.compareTo(BILLINGBackUp_UpperBound) < 0) )  )  && ThreadName.equals("CablePayAcctActv1"))


    				///////////////////////////////////////////////////////////////////////////////////////////////

						SysDateTime = DisplayDateTime(2);   // Change the time to hours to check what cycle
						Thread.currentThread().sleep(1);	// phase the day is in: Peak, Normal or GraveYard
					///////////////////////////////////////////////////////////////////////////////////////////////
										
						
						///////////////////////////////////////////////////////////////////////////////////////////////		
						Thread.currentThread().sleep(1);	
					///////////////////////////////////////////////////////////////////////////////////////////////
										
		
		    			if (Dynamic_Global_Counter <= 0.000) {
    							
    							//Reset Dynamic_Global_Counter
    							
    							Dynamic_Global_Counter = Static_Global_Counter;
    							//System.out.println("Dynamic_Global_Counter is " + Dynamic_Global_Counter);
    							//System.out.println("======================================");
    							
    							//Call Check_Nexus_Profile Method to Check number of rows in _Nexus_Profile Table
    							//The row count will directly determine the pooling interval of _Nexus
    							
    							Check_Nexus_Profile ();
	   							continue;
    					}
    					
    									
						
						
    					if (Dynamic_Global_Counter > 0.000) {
    							
    							//Extract potential BILLING user accounts for creation|modification in  Profile
 								_NEXUS_PROFILE(ThreadName);	
	      							      						
	      						//make thread sleep
    							Thread.currentThread().sleep(Thread_Sleep_Interval);
    							Dynamic_Global_Counter -= Dynamic_Local_Counter;
    							
    							//System.out.println("Dynamic_Global_Counter is " + Dynamic_Global_Counter);
    							//System.out.println("======================================");
    								
    							continue;
    					}
    							

		    	///////////////////////////////////////////////////////////////////////////////////////////////			

   					}		// end of try

   				 /////////////////////////////////////////////////////////////////////////////////////

					catch (SQLException e) {
		        			System.err.print("SQLException2: ");
		        			System.err.println(e.getMessage());
		        			continue;		        			
		        	}

					catch (InterruptedException e) {
		        			System.err.print("Thread Exception: ");
		        			System.err.println(e.getMessage());
		        			continue;
		        	}


		      	 continue;

			}    // end of while(Poll_) - this should never be reached!!!


    	} // end of public static void _SubMod(String ThreadName) throws SQLException


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


					private void _NEXUS_PROFILE(String ThreadName) throws SQLException{

					Connection conn1 = null;
					int Acc_Loop = 0;

					try{	//superset Try
							// Connect to the BILLING Oracle9i DataBase

           				conn1 = DriverManager.getConnection(_NEXUS_JDBC_Connection.JDBC_Connection1,
           				_NEXUS_JDBC_Connection.UserName1,_NEXUS_JDBC_Connection.Password1);
           				
           						}	catch (SQLException e) {
		        						System.err.print("SQLException3: ");
		        						System.err.println(e.getMessage());
		        						
		        						//Increment Suspend_Billing_Thread
		        						Suspend_Billing_Thread++;
		        						
		        						//If Suspend_Billing_Thread = 10 Make Thread sleep for 1 hour
		        								        						
		        						if (Suspend_Billing_Thread == 10)
		        							{
		    									Suspend_Thread(Thread_Suspend_Sleep_Interval);
    												
		        								//Reset Suspend_Thread back to 0	
		        								Suspend_Billing_Thread = 0;	
		        							}
		        							
		        						return;
		        					
		        					}
		        					
					
					try{  //try clause
					
						
						if(ThreadName.equals("_NEXUS_1") || ThreadName.equals("_NEXUS_2")){  


						/****************************************************************************
		    			 *																			*
		    			 *	 Stored Procedure (SP) for GetStatus (Extract) from the Oracle 9i		*
		    			 *	 DataBase - note the string structure is different from MSSQL 2005 		*
		    			 *	 The results of the BILLING SP's are stored in the billing_temp_status	*
		    			 *	 table. It is from this table where the _Module			 				*
		    			 *	 obtains verification of the Customers Account status,the customers		*
		  				 *																			*
		  				 ****************************************************************************/


							//Create Statement Object and  Callable Ojbect1 to execute
			           		Statement stmt1 = conn1.createStatement();
					
					
							//Create Callable Ojbect1 and Result Set1 to execute
			   	    		//GetProfileInfo Stored Procedure	 
							String callstatement1 = "{call <SCHEMA>._NEXUS_APP_PKG.NEXUS_STORED_PROCEDURE(?,?,..<AS_NEEDED_PLACEHOLDERS>..?,?)}";
							
						
							// Create Callable Ojbect
							CallableStatement cstmt1 = conn1.prepareCall(callstatement1);
							
							
							//register the type of output parameter
							cstmt1.registerOutParameter(1, java.sql.Types.INTEGER);
							cstmt1.registerOutParameter(2, java.sql.Types.VARCHAR);
							//		............................	
							//		CSTMT REGISTER-OUT PARAMETERS MUST MATCH VARIABLES RETURNED FROM PACKAGE 
							//		<SCHEMA>._NEXUS_APP_PKG.NEXUS_STORED_PROCEDURE....
							//		............................

														
							//Create Result Set to execute GetProfileInfo Stored Procedure
							ResultSet rstmt1 = cstmt1.executeQuery();
							
								
							// display the result set rs.next() returns false when there are no more rows

		           			while (rstmt1.next()) {

		           			    // extract the column entries for each row which qualifies
		           			    // for Account Verification

		           					// Get Account Validation Results from BILLING
		           					
		           				int    variable_i = cstmt1.getInt(1);	
					        	String variable_j = cstmt1.getString(2);
								//		............................	
								//		CSTMT GET PARAMETERS SHOULD MATCH VARIABLES RETURNED FROM CSTMT REGISTER-OUT PARAMETERS 
								//		............................
								

								/* FOR DEBUGGING ONLY
								System.out.println(variable_1);	
					        	System.out.println(variable_2);
								..............
								..............
					        	System.out.println("======================================");
					        	*/

		       			 		//////////////Submit Info to  //////////////////
		       			 		
		       			 		if(variable_j.equals("$$$$$$$$$")){break;} //break out of while statement
		       			 		

		  						else if((variable_j.length() <= 7) || (variable_j.length() >= 10)){
		  							
		  							Log_Message = 1;
		  							WriteLogFile(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/ Log_Message);
		  						}

								
		  						else{
		  								for(Acc_Loop = 0; Acc_Loop < 3; Acc_Loop++)
		  								{
	  									
		  									
											_NEXUS_SUBMIT(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/conn1);
											
																											
											// Determine if its safe to remove row entries in _PROFILE
											// table for accounts being passed to  Profile table
		  									// After 3 attempts the row entry will be removed regardless
		  							
									
									
										if( ((_NEXUS_IO>=1) && (_NEXUS_IO<=6)) || (_NEXUS_IO==8)){
												
		  										_NEXUS_BILLING_DROPACCT(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/conn1);
		  										_NEXUS_IO = -1;
		  										Acc_Loop = 3;
		  										continue;
		  									}
		  									
		  									
		  																									
											if(_NEXUS_IO==7){
												_NEXUS_BILLING_DROPACCT(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/conn1);
				   								_NEXUS_IO = -1;
				   								Acc_Loop = 3;
				   								Log_Message = 2;
												WriteLogFile(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/ Log_Message);
		  										
				   								continue;
				   							}
				   							
										
		  									

				   							if(Acc_Loop==2){
		  										_NEXUS_BILLING_DROPACCT(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/conn1);
												WriteLogFile(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/ Log_Message);
		  										_NEXUS_IO = -1;
		  										Acc_Loop = 3;
		  										continue;
		  									}
				   					
				   					
				   							   							
				   						} // end of For Statement
		  							
		  							
		  								//break out of while statement
		  								break;
		  								
									}	// end of else statement
												
								
		          			} // end of while (rstmt0.next())


							/////////////////////////////////////////////////////////////////////

							
							rstmt1.close(); // Close Result1 Object for this Polling round
		        			cstmt1.close(); // Close Statement1 Objects for this Polling round
		        			stmt1.close();	// Object will open again for the next polling session
							conn1.close();  // CLose BILLING connection for the polling round	
							/////////////////////////////////////////////////////////////////////
					

						}	// End of if(ThreadName.equals("1"))


							return;
							/////////////////////////////////////////////////////////////////////

					} // end of superset try

					catch (ArrayIndexOutOfBoundsException e){
                		System.err.print("ArrayIndexOutOfBoundsException: ");
		        		System.err.println(e.getMessage());
                	}


                  	catch (NullPointerException e){
                		System.err.print("NullPointerException: ");
		        		System.err.println(e.getMessage());
                	}


                	catch (SQLException e) {
		        		System.err.print("SQLException4: ");
		        		System.err.println(e.getMessage());
		        	}

					return;
					
				}	// private void _NEXUS_PROFILE(String ThreadName) throws SQLException{




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


 		private void _NEXUS_SUBMIT(String variable_j,int variable_i,/* APPROPRIATE VARIABLE LIST*/Connection conn1)
 			{
 						  							
 				 				
 				/////////////////// Format Phone Numbers with a - ////////////////////////
 				// Please change variable_placeholders below with meaningful variables for your requirements

 				if((variable_j != null) && (variable_j.length() >=7))
 				{
 					String variable_k = variable_j.substring(0,3) + '-';
 					String variable_l = variable_j.substring(3,variable_j.length());
 					variable_j = variable_k + variable_l;
				}


				// Account Combo for determining Data Rate Amount
				
					String variable_m = variable_j.substring(0,6);
					String variable_n = variable_j.substring(7,variable_j.length());
			
				
 					////////Variable  Declaration and Initialisation /////////////////
    	
    	
    			Connection conn3 = null;

       			 try {

           					// Connect to the MSSQL 2005 DataBase

           				conn3 = DriverManager.getConnection(_NEXUS_JDBC_Connection.JDBC_Connection2,
           				_NEXUS_JDBC_Connection.UserName2,_NEXUS_JDBC_Connection.Password2);

    							}	catch (SQLException e) {
		        						System.err.print("SQLException5: ");
		        						System.err.println(e.getMessage());
		    
		        								        						
		        					//Increment Suspend__Thread
		        					Suspend__Thread++;
		        						
		        					//If Suspend__Thread = 10 Make Thread sleep for 1 hour
		        								        						
		        					if (Suspend__Thread == 10)
		        						{
		    								Suspend_Thread(Thread_Suspend_Sleep_Interval);
    												
		        							//Reset Suspend_Thread back to 0	
		        							Suspend__Thread = 0;	
		        						}
		        					return;
		        				}


						
        		try{  //try clause		
			   				
			   				
			   				
			   				// Determine if incoming Account is a Child or Parent Profile
			   				String callstatement3 = "";
			   				
							if(variable_j.equals("Parent")){
								callstatement3 = "{call SQL2.user._NEXUS_PARENT_PROFILE (?,?,..<AS_NEEDED_PLACEHOLDERS>..?,?)}";
							}
		

							if(variable_j.equals("Child")){
								callstatement3 = "{call SQL2.user._NEXUS_CHILD_PROFILE (?,?,..<AS_NEEDED_PLACEHOLDERS>..,?,?)}";
							}
										
							// Load Up results from BILLING to TICKETING
													

			           		//Statement stmt3 = conn3.createStatement();

						    CallableStatement cstmt3 = conn3.prepareCall(callstatement3);

						    // Set the types and values for the IN parameters
							cstmt3.setString(1,variable_j);
					        cstmt3.setInt(2,variable_i);
							// ....
							// cstmt3 set other variables per the designed input variables for: 
							// _NEXUS_PARENT_PROFILE or _NEXUS_CHILD_PROFILE on the Ticketing System Side
							//....


				        	// register the type of output parameter: note <order_location_output_parameter>
							// immediately below => location of the output parameter in SP _NEXUS_CHILD_PROFILE
				        	cstmt3.registerOutParameter(order_location_output_parameter,java.sql.Types.INTEGER);
				        	
				        	//execute stored procedure and extract results
					        ResultSet rstmt3 = cstmt3.executeQuery();
							
							
							
							while (rstmt3.next()) {_NEXUS_IO = rstmt3.getInt(1);}
														     		       	
							rstmt3.close();			// Close the Result2 Set Object
							cstmt3.close();			// Close the Callable2 Set Object
							conn3.close();			// Close the connection to 




				       	///////////Write the Account Status Results back in //////////////////////

						
						if(_NEXUS_IO == 777) 
						{
							Log_Message = 0;
							WriteLogFile(variable_j,variable_i,/* APPROPRIATE VARIABLE LIST*/ Log_Message);
		  				}


						else{return;}
				        


			////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////


		        	}  	//end of try clause


			////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////


  						catch (NullPointerException e){
                			System.err.print("NullPointerException: ");
		        			System.err.println(e.getMessage());
                		}


                		catch (SQLException e) {
		        			System.err.print("SQLException6: ");
		        			System.err.println(e.getMessage());
		        		}

      					return;

       		} 		// end of public void _NEXUS_SUBMIT (?,?,?)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private void _NEXUS_BILLING_DROPACCT(int variable_i,String variable_j,Connection conn1)
 			{

			   			
				try{  //try clause
				
							////////////////////////////////////////////////////////////////////
				
			   	    		String callstatement4 = "{call <SCHEMA>._NEXUS_APP_PKG.NEXUS_DROP_ACCTINFO (?,?,?)}";

			           		Statement stmt4 = conn1.createStatement();

						    CallableStatement cstmt4 = conn1.prepareCall(callstatement4);

						    // Set the types and values for the IN parameters
						    //register the type for the OUT parameter
						    
							cstmt4.setInt(1,variable_i);
							cstmt4.setString(2,variable_j);;						
							cstmt4.registerOutParameter(3,java.sql.Types.INTEGER);

					        cstmt4.executeUpdate();
					        
							int DeleteResults = cstmt4.getInt(3);
							
							cstmt4.close();			// Close the Callable3 Set Object
							stmt4.close();			// Close the Statement3 Set Object
							
							///////////////////////////////////////////////////////////////////
							
							
							return;        

			////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////

			    	}  	//end of try clause


			////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////


  					catch (NullPointerException e){
                		System.err.print("NullPointerException: ");
		        		System.err.println(e.getMessage());
                	}


                	catch (SQLException e) {
		        		System.err.print("SQLException7: ");
		        		System.err.println(e.getMessage());
		        	}
		        	
		        	return;

       		} 		// end of private void _NEXUS_BILLING_DROPACCT

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



   			static private String DisplayDateTime(int DTime) {

			//Decalre Local Variable DateTime
			String DateTime="";
			
			// Get the current time (in milliseconds)
			long lTime=System.currentTimeMillis() ;
			
				
			//Create simple and Extended Date Format Object
			SimpleDateFormat sdf0 = new SimpleDateFormat("d-M-yyyy");					
			SimpleDateFormat sdf1 = new SimpleDateFormat("d/M/yyyy HH:mm:ss");
			SimpleDateFormat sdf2 = new SimpleDateFormat("HH:mm:ss");
			
			//Create a Date Object and get the cureent date
			java.util.Date objDate = new java.util.Date(lTime);


			if(DTime==0){DateTime = sdf0.format(objDate);}
						
			if(DTime==1){DateTime = sdf1.format(objDate);}
		
			if(DTime==2){DateTime = sdf2.format(objDate);}
			
			return(DateTime);

			}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



   		static private String SetInitial_BILLING_BackUP_Date(int BILLING_VAR) {

			///////////////////////////////////////////////////////////////////////
			
			//set while loop boolean
			boolean while_date_var = true;
			
			// Get the current time (in milliseconds)
			long lTime=System.currentTimeMillis() ;
			
			// Create a 24hr Increment variable
			long lower_incr_week = 86400000;
			
			//Create simple Day (EEE format = Mon,Tue,...Sun)  and DMY Format Object
			SimpleDateFormat sdf_d = new SimpleDateFormat("EEE");							
			SimpleDateFormat sdf_dmy = new SimpleDateFormat("d/M/yyyy");
			
			//Create a Date Object and get the cureent date
			java.util.Date objDate = new java.util.Date(lTime);
	
			String Day = sdf_d.format(objDate);
			String DMY = sdf_dmy.format(objDate);
			

			String BILLINGBackUp_Lower_hrs_mins_secs = " 00:00:00";
			String BILLINGBackUp_Upper_hrs_mins_secs = " 00:00:00";
			String BILLINGBackUP_Return_Variable = "";
			
			///////////////////////////////////////////////////////////////////////
			
			while(while_date_var){

				if(Day.equals("TARGET_DAY") && (BILLING_VAR == 0))
				{
					BILLINGBackUP_Return_Variable = DMY + BILLINGBackUp_Lower_hrs_mins_secs;
					while_date_var = false;
					break;
				}
				
				/////////////////////////////////////////////////
				
				else if(Day.equals("TARGET_DAY") && (BILLING_Var == 1))
				{
					BILLINGBackUP_Return_Variable = DMY + BILLINGBackUp_Upper_hrs_mins_secs;
					while_date_var = false;
					break;	
					
				}
				
				/////////////////////////////////////////////////
				
				else{
					lTime+=lower_incr_week;
					sdf_d = new SimpleDateFormat("EEE");
					sdf_dmy = new SimpleDateFormat("d/M/yyyy");
					objDate = new java.util.Date(lTime);
					Day = sdf_d.format(objDate);
					DMY = sdf_dmy.format(objDate);
					continue;
				}
				
			}
			
			///////////////////////////////////////////////////////////////////////
						
			return(BILLINGBackUP_Return_Variable);

		}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    	private void Set_BILLING_OfflineBackUp_Dates() {


			long lower_incr_week = 000000000;
			long upper_incr_week = 000000000;
			
			// Get the current time for lower and upper bound (in milliseconds)
					
			long lTime = System.currentTimeMillis();
			long uTime = System.currentTimeMillis();	
		

			lTime+=lower_incr_week;
			uTime+=upper_incr_week;
		
			
			//Create a simple Date Format Object
			SimpleDateFormat sdf = new SimpleDateFormat("d/M/yyyy HH:mm:ss");

			//Create a Date Object and get the cureent date
			java.util.Date lower_objDate = new java.util.Date(lTime);
			java.util.Date upper_objDate = new java.util.Date(uTime);
	
			BILLINGBackUp_LowerBound = sdf.format(lower_objDate);
			BILLINGBackUp_UpperBound = sdf.format(upper_objDate);
			
      		return;
		}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	private void WriteLogFile(String variable_j,int variable_i,/* APPROPRIATE VARIABLE LIST*/int message){

		  											
				boolean FileAppend = true;

				// Log File _Invalid_Account_Format Creation
				FileDateTime = DisplayDateTime(0);
 				String Log_File_Begin0 = "<TARGET_DRIVE>\\<TARGET_PATH>\\_NEXUS_Failed_Profile_" + FileDateTime;
 				String Log_File_End0 = ".log";    
        		String Log_File_Final0 = Log_File_Begin0.concat(Log_File_End0);

				
				// Log File _Invalid_Account_Format Creation
				FileDateTime = DisplayDateTime(0);
 				String Log_File_Begin1 = "<TARGET_DRIVE>\\<TARGET_PATH>\\_NEXUS_Invalid_Account_Format_" + FileDateTime;
 				String Log_File_End1 = ".log";
        		String Log_File_Final1 = Log_File_Begin1.concat(Log_File_End1);


				// Log File _Invalid_Account_Format Creation
				FileDateTime = DisplayDateTime(0);
 				String Log_File_Begin2 = "<TARGET_DRIVE>\\<TARGET_PATH>\\_NEXUS_NoActionTaken_" + FileDateTime;
 				String Log_File_End2 = ".log";
        		String Log_File_Final2 = Log_File_Begin2.concat(Log_File_End2);
        		
        		

				// Log File Message Types
				String _NEXUS_Failed_Attempts = " NEXUS Profile failed. Attempting to perform  Profile action again. Account Info below....";
				String _Invalid_CustID_Format = "Invalid  Profile Format. Output below.....";
				String _Profile_NoAction_Taken = "All current  Profile Services are higher than incoming service. No update performed. Output below.....";

				
				try{

	       			/////////////////////////////////////////////////////////////////////
	       		
	       		if(message==0){
	       					
        			BufferedWriter out = new BufferedWriter(new FileWriter(Log_File_Final0, FileAppend));
							
	       			out.write(_NEXUS_Failed_Attempts);
					out.newLine();
					out.write(variable_j + "|" + variable_i + "|" /* APPROPRIATE VARIABLE LIST*/);
	       			out.newLine();
	       			out.close();		
	       		}
	       		
	       		
	       		
	       			/////////////////////////////////////////////////////////////////////
	       		
	       		
				if(message==1){
					
					BufferedWriter out = new BufferedWriter(new FileWriter(Log_File_Final1, FileAppend));
					
					out.write(_Invalid_CustID_Format);
					out.newLine();
					out.write(variable_j + "|" + variable_i + "|" /* APPROPRIATE VARIABLE LIST*/);
	       			out.newLine();
	       			out.close();	       			
	       		}
	       		
	       		/////////////////////////////////////////////////////////////////////
	       		
	       		if(message==2){
					
					BufferedWriter out = new BufferedWriter(new FileWriter(Log_File_Final2, FileAppend));
					
					out.write(_Profile_NoAction_Taken);
					out.newLine();
					out.write(variable_j + "|" + variable_i + "|" /* APPROPRIATE VARIABLE LIST*/);
	       			out.newLine();
	       			out.close();	       			
	       		}
	       		
	       		
	       		/////////////////////////////////////////////////////////////////////
	       			
	       		return;
	       		
	       		/////////////////////////////////////////////////////////////////////
	       		
	       		}

       				catch (IOException e) {
      				System.err.print("File write Error: ");
      				System.err.println(e.getMessage());}

      				return;
      				
      	} // End of private void WriteLogFile


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	private void Check_Nexus_Profile () throws SQLException{

			Connection conn3 = null;


			try{	//superset Try
					// Connect to the BILLING Oracle9i DataBase

           		conn3 = DriverManager.getConnection(_NEXUS_JDBC_Connection.JDBC_Connection1,
           				_NEXUS_JDBC_Connection.UserName1,_NEXUS_JDBC_Connection.Password1);
           				
           						}	catch (SQLException e) {
		        						System.err.print("SQLException3: ");
		        						System.err.println(e.getMessage());
		        					
		        					//Increment Suspend_Billing_Thread
		        						Suspend_Billing_Thread++;
		        						
		        						//If Suspend_Billing_Thread = 10 Make Thread sleep for 1 hour
		        								        						
		        						if (Suspend_Billing_Thread == 10)
		        							{
		    									Suspend_Thread(Thread_Suspend_Sleep_Interval);
    												
		        								//Reset Suspend_Thread back to 0	
		        								Suspend_Billing_Thread = 0;	
		        							}
		        						return;
		        					}
		        					
		        					
			try{  //try clause
				
							////////////////////////////////////////////////////////////////////
				
			   	    		String callstatement4 = "{call <SCHEMA>._NEXUS_APP_PKG.NEXUS_GET_PROFILE_COUNT (?)}";

			           		Statement stmt4 = conn3.createStatement();

						    CallableStatement cstmt4 = conn3.prepareCall(callstatement4);

						    // Set the types and values for the IN parameters
						    //register the type for the OUT parameter
						    						
							cstmt4.registerOutParameter(1,java.sql.Types.INTEGER);

							
					        cstmt4.executeUpdate();

							int Count_Results = cstmt4.getInt(1);
							
					        		

							cstmt4.close();			// Close the Callable3 Set Object
							stmt4.close();			// Close the Statement3 Set Object
							conn3.close();  		// Close BILLING connection for the polling round	
							///////////////////////////////////////////////////////////////////
							
							
							// Emergency Cycle - Peak to Overload Activity on the Billing Side
							if(Count_Results >= 1000){
								Thread_Sleep_Interval = Emergency_Interval;
								Dynamic_Local_Counter = Emergency_Counter;
								Send_Email_Count++;
								

								////////////////////////////////////////////////////////////////
																
								//If there is a backlog in Nexus - Print Log Count to a file and run a batch script
								// send off an email to the  Team
								
								if(Send_Email_Count >= 6){
									
									
									//
									try{	//try clause
									
										
											String BackLog_Recipient[] = {"<desired-group>@example.com","<desired-user>@example.com"};
											String BackLog_Subject = " Nexus Service currently has a backlog";
											String BackLog_Message = " NEXUS backlog count is currently " + Count_Results;
											String BackLog_Sender = "NexusAdmin@example.com";
											
											postMail(BackLog_Recipient,BackLog_Sender,BackLog_Subject,BackLog_Message);
											Send_Email_Count =0;
																					
										} 	//end of try clause
										
										
										catch (MessagingException e){
                						System.err.print("MessageException: ");
		        						System.err.println(e.getMessage());
                						}
								////////////////////////////////////////////////////////////////
									
								}	// end of if(Send_Email_Count >= 12){
								
							
								////////////////////////////////////////////////////////////////	
								
								
								//System.out.println("Dynamic_Local_Counter is " + Dynamic_Local_Counter);
    							//System.out.println("======================================");	
							}
							
							
							
							// Peak Cycle - Average to peak activity on the Billing Side							
							if(Count_Results >= 50 && Count_Results < 300){
								Thread_Sleep_Interval = Peak_Interval;
								Dynamic_Local_Counter = Peak_Counter;
								
								//System.out.println("Dynamic_Local_Counter is " + Dynamic_Local_Counter);
    							//System.out.println("======================================");	
							}
							
							
							
							// Normal Cycle - Average to little activity on the Billing Side							
							if(Count_Results >= 10 && Count_Results < 50){
								Thread_Sleep_Interval = Normal_Interval;
								Dynamic_Local_Counter = Normal_Counter;
								
								//System.out.println("Dynamic_Local_Counter is " + Dynamic_Local_Counter);
    							//System.out.println("======================================");	
							}
	
	
	
							
							// GraveYard Cycle - Little to no activity on the Billing Side							
							if(Count_Results < 10){
								Thread_Sleep_Interval = GraveYard_Interval;
								Dynamic_Local_Counter = GraveYard_Counter;
								
								//System.out.println("Dynamic_Local_Counter is " + Dynamic_Local_Counter);
    							//System.out.println("======================================");	
							}
							
							
							return;        

			
			////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////

			    	}  	//end of try clause


			////////////////////////////////////////////////////////////////////////////////////////////////////
			////////////////////////////////////////////////////////////////////////////////////////////////////


  					catch (NullPointerException e){
                		System.err.print("NullPointerException: ");
		        		System.err.println(e.getMessage());
                	}


                	catch (SQLException e) {
		        		System.err.print("SQLException7: ");
		        		System.err.println(e.getMessage());
		        	}
		     

      				return;
      				
      	}	// End of private void Check_Nexus_Profile () throws SQLException{
      		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public void postMail(String recipients[], String from, String subject, String message) throws MessagingException
{
    boolean debug = false;

     //Set the host smtp address
     Properties props = new Properties();
     props.put("mail.smtp.host", "myhost.example.com");

    // create some properties and get the default Session
    Session session = Session.getDefaultInstance(props, null);
    session.setDebug(debug);

    // create a message
    Message msg = new MimeMessage(session);

    // set the from and to address
    InternetAddress addressFrom = new InternetAddress(from);
    msg.setFrom(addressFrom);

    InternetAddress[] addressTo = new InternetAddress[recipients.length]; 
    for (int i = 0; i < recipients.length; i++)
    {
        addressTo[i] = new InternetAddress(recipients[i]);
    }
    
    msg.setRecipients(Message.RecipientType.TO, addressTo);
   

    // Optional : You can also set your custom headers in the Email if you Want
    //msg.addHeader("MyHeaderName", "myHeaderValue");

    // Setting the Subject and Content Type
    msg.setSubject(subject);
    msg.setContent(message, "text/plain");
    Transport.send(msg);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	private void Suspend_Thread(int interval)
		{
			try {
		
		    		//Prompt log that Database connections failed. Provide possible explanations
		        								
		        	System.out.println('\n');
		        	System.out.println("========================================================================");
		        	System.out.println("BILLING Database |  Ticketing Database in unavailable. Possible reasons:\n");
		        	System.out.println("1/ REASON1:\n");
		        	System.out.println("2/ REASON2:\n");
		        	System.out.println("3/ REASON3.\n");
		        	System.out.println("If after SLA breach, The BILLING | TICKETING SYSTEM[s] is/are still unavailable - contact DBAs.\n");
		        	System.out.println("========================================================================");
		        	System.out.println('\n');
		        								
    				Thread.currentThread().sleep(interval);	
					return;
				}
		
			/////////////////////////////////////////////////////////////////////
				
			catch 	(InterruptedException e) {
		        	System.err.print("_BILLING_SubMod -> Thread Exception: ");
		        	System.err.println(e.getMessage());
		        	return;
		        }
				
		}		//End of private void Suspend_Thread(int interval)	
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		
} 		/*************** End of _NEXUS_Module Class **********************/