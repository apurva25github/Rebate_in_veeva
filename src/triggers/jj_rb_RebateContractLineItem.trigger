/*
Trigger on jj_rb_Rebate_Contract_Line_Item__c Object
*/

Trigger jj_rb_RebateContractLineItem on jj_rb_Rebate_Contract_Line_Item__c(before insert, before update) {    
    jj_rb_RebateContractLineItem_Handler handler = new jj_rb_RebateContractLineItem_Handler();
    
    // if it is a update and if previous status of the line item
    // is Closed, then do not change it to expired
    if(Trigger.isBefore && Trigger.isUpdate)
    {
    	for(jj_rb_Rebate_Contract_Line_Item__c lineItem : trigger.new)
    	{
    		// compare status
    		if(trigger.oldMap.get(lineItem.id).jj_rb_Status__c == 'Closed')
    		{
    			lineItem.jj_rb_Status__c = 'Closed';
    		}
    	}
    }
    
    // check for duplicate dates
    if(Trigger.isBefore && Trigger.isInsert ||
        Trigger.isBefore && Trigger.isUpdate) {
        
        handler.performDateRangeValidation(trigger.new);
    }
}