/**
 *    @author  MangaDivya Kasani
 *    @date  30/04/2014
     @description  Scheduler class for the Average Quantity Calculation batch process 
      
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     MangaDivya Kasani    15/04/2014      Original Version
 */
global class jj_rb_avgQuantityCalcScheduler implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        jj_rb_avgQuantityCalc obj= new jj_rb_avgQuantityCalc();
        Database.executebatch(obj);
    }
}