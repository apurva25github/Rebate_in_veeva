/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  	6/3/2014
     @description  Scheduler class to generate accrual reports from approved 
     accrual records.
      
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    6/3/2014      Original Version
 */
global class jj_rb_AccrualReportGenerateScheduler implements Schedulable {
	global void execute(SchedulableContext ctx) {
		Database.executeBatch(new jj_rb_Accrual_Report_Generation());				
	}
}