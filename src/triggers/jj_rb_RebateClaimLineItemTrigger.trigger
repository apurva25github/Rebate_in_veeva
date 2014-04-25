/**
 * Trigger on RebateClaimLineItemTrigger object
 */
 
trigger jj_rb_RebateClaimLineItemTrigger on jj_rb_Rebate_Claim_Line_Item__c (after insert, after update) {
List<jj_rb_Rebate_Claim_Line_Item__c> listNewClaimLineItem=System.Trigger.new; 
String homecareclaimLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Homecare claim line item');
String retailerclaimLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Retailer claim line item');

Map<ID,ID> MapRetailerRecordtype= new Map<ID,ID>();
Map<ID,ID> MapHCPRecordtype= new Map<ID,ID>();

    for(jj_rb_Rebate_Claim_Line_Item__c Claimlines: listNewClaimLineItem)
    {
       if(Claimlines.RecordTypeId==retailerclaimLI_recType){
           MapRetailerRecordtype.put(Claimlines.id,Claimlines.Recordtypeid);
           System.debug('MapRetailerRecordtype>>'+MapRetailerRecordtype);
       }
       else if(Claimlines.RecordTypeId==homecareclaimLI_recType)
       {
           MapHCPRecordtype.put(Claimlines.id,Claimlines.Recordtypeid);
           System.debug('MapHCPRecordtype>>'+MapHCPRecordtype);
       }
    }
    
    if(!jj_rb_RebateClaimLineItemTriggerHandler.alreadyFired) {
        
        jj_rb_RebateClaimLineItemTriggerHandler.alreadyFired = true;      
        
        if(Trigger.isAfter) {   
                
            jj_rb_RebateClaimLineItemTriggerHandler.checkForDuplicateLineItems();
            
            if(!MapRetailerRecordtype.values().isEmpty())
            {
                jj_rb_RebateClaimLineItemTriggerHandler.findActiveRebateContractLineItems();
                
            }else if(!MapHCPRecordtype.values().isEmpty())
            {          
                jj_rb_RebateClaimLineItemTriggerHandler.checkForValidContracts();
            }
           
        }
            
    }
}