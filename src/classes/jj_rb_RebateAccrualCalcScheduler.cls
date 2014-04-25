/*
* Scheduler class for Retailer and homecare accrual calculation process.
* This class to be scheduled to run on the 18th of every month @ 1am.
*
*/
global class jj_rb_RebateAccrualCalcScheduler implements Schedulable {	
	global void execute(SchedulableContext ctx) {
		Database.executeBatch(new jj_rb_RetailerAccrualCalc());
		Database.executeBatch(new jj_rb_HCPAccrualcalc());		
	}
}