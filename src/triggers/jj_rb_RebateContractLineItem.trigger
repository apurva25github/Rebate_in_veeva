/*
Trigger on jj_rb_Rebate_Contract_Line_Item__c Object
*/

Trigger jj_rb_RebateContractLineItem on jj_rb_Rebate_Contract_Line_Item__c(before insert, before update) {
    //jj_rb_RebateContractLineItemHandler handler = new jj_rb_RebateContractLineItemHandler ();
    jj_rb_RebateContractLineItem_Handler handler = new jj_rb_RebateContractLineItem_Handler();
    
    if(Trigger.isBefore && Trigger.isInsert ||
        Trigger.isBefore && Trigger.isUpdate) {
        //handler.performDateRangeValidation(Trigger.new, Trigger.oldMap);
        handler.performDateRangeValidation(trigger.new);
    }
}