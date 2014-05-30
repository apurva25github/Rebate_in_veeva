/**
 * Trigger on RebateClaimLineItemTrigger object
 */
 
trigger jj_rb_RebateClaimLineItemTrigger on jj_rb_Rebate_Claim_Line_Item__c (after insert, after update, before insert, before update) {
List<jj_rb_Rebate_Claim_Line_Item__c> listNewClaimLineItem = System.Trigger.new; 
String homecareclaimLI_recType;
String retailerclaimLI_recType;

Set<jj_rb_Rebate_Claim_Line_Item__c> setRetailerRecords = new Set<jj_rb_Rebate_Claim_Line_Item__c>();
Set<jj_rb_Rebate_Claim_Line_Item__c> setHomecareRecords = new Set<jj_rb_Rebate_Claim_Line_Item__c>();
  
    
    if(!jj_rb_RebateClaimLineItemTriggerHandler.alreadyFired) {
        
        jj_rb_RebateClaimLineItemTriggerHandler.alreadyFired = true;  
        
        homecareclaimLI_recType = jj_rb_Rebate_utils.getRecordTypeID('Claim_LineItem_Homecare');
		retailerclaimLI_recType = jj_rb_Rebate_utils.getRecordTypeID('Claim_LineItem_Retailer');
        
        
          for(jj_rb_Rebate_Claim_Line_Item__c ClaimlineItem: listNewClaimLineItem)
		    {
		       if(ClaimlineItem.RecordTypeId==retailerclaimLI_recType){
		           setRetailerRecords.add(ClaimlineItem);		           
		       }
		       else if(ClaimlineItem.RecordTypeId==homecareclaimLI_recType)
		       {
		           setHomecareRecords.add(ClaimlineItem);		         
		       }
		    }    
        
        if(Trigger.isBefore)
        {
        	// if it is a homecare claim
        	if(!setHomecareRecords.isEmpty())
        	{
        		// check if hospitals are associated with a parent trust and the parent trust is associated with a region
        		jj_rb_RebateClaimLineItemTriggerHandler.validateHospitalCustomers(setHomecareRecords);        		
        	}
        }
        
        
        
        if(Trigger.isAfter) {   
                
            jj_rb_RebateClaimLineItemTriggerHandler.checkForDuplicateLineItems();
            
            if(!setRetailerRecords.isEmpty())
            {
                jj_rb_RebateClaimLineItemTriggerHandler.findActiveRebateContractLineItems();
                
            }else if(!setHomecareRecords.isEmpty())
            {          
                jj_rb_RebateClaimLineItemTriggerHandler.checkForValidContracts();
            }
           
        }
            
    }
}