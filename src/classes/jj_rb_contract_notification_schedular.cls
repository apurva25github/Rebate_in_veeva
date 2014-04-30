/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  15/04/2014
     @description  Scheduler class for the contract expiry notification batch process 
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    15/04/2014      Original Version
 */
global class jj_rb_contract_notification_schedular implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        jj_rb_Contract_notifications batch = new jj_rb_Contract_notifications();
        database.executebatch(batch) ;
    }
}