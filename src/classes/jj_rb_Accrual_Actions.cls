/********************************************
* This class is used by the rebate accrual list buttons.
*
********************************************/

global class jj_rb_Accrual_Actions {
    webservice static void executeCalcBatch()
    {
       Database.executeBatch(new jj_rb_RetailerAccrualCalc());   
       Database.executeBatch(new jj_rb_HCPAccrualcalc());
    }
    
    webservice static void createBatchReport()
    {
        Database.executeBatch(new jj_rb_Accrual_Report_Generation());
    }
}