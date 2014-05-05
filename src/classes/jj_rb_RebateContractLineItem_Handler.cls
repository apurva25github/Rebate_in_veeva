/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  15/04/2014
     @description  Handler class for Rebate contract line item trigger 
 
     Function: Handles the controller logic for the Homecare upload page.
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description 
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    15/04/2014      Original Version
 */ 
public class jj_rb_RebateContractLineItem_Handler {
	@TestVisible public static final String LINEITEM_STATUS_STATUS = 'New';
	
	String retailerRecordType = jj_rb_Rebate_Utils.getRecordTypeId('Contract_LineItem_Retailer');
	String homecareRecordType = jj_rb_Rebate_Utils.getRecordTypeId('Homecare_Contract_Line_Item');
	
	public void performDateRangeValidation(List<jj_rb_Rebate_Contract_Line_Item__c> listNewContractLineItems)
	{
		Set<Id> setQueryParams = new Set<Id>();
		Set<Id> setContracts = new Set<Id>();
		Set<Id> setExistingLineItem = new Set<Id>();
		Integer i=0;
		Integer j=0;
		
		Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapContractLineItems 
									= new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>(); // key -> unique key
									
									
		// get contract information of the line items and prepare a map
		for(jj_rb_Rebate_Contract_Line_Item__c contractLineItem : listNewContractLineItems)
		{
			setQueryParams.add(contractLineItem.jj_rb_Product__c);
			setQueryParams.add(contractLineItem.jj_rb_Region__c);
			setContracts.add(contractLineItem.jj_rb_Rebate_Contract__c);
		}		
		Map<Id, jj_rb_Rebate_Contract__c> mapContracts = new Map<id, jj_rb_Rebate_Contract__c>([select Id, jj_rb_Customer__c,jj_rb_Product__c from jj_rb_Rebate_Contract__c where id in :setContracts]);
								
									
		// prepare a map of existing contract line items
		for(jj_rb_Rebate_Contract_Line_Item__c contractLineItem : listNewContractLineItems)
		{
			jj_rb_Rebate_Contract__c contract = mapContracts.get(contractLineItem.jj_rb_Rebate_Contract__c);
			contractLineItem.jj_rb_Rebate_Contract__r = contract;
			String uniqueKey = getUniqueKey(contractLineItem);
			
			setQueryParams.add(contract.jj_rb_Customer__c);
			
			setExistingLineItem.add(contractLineItem.Id);
			
			if(mapContractLineItems.containsKey(uniqueKey)) {
				mapContractLineItems.get(uniqueKey).add(contractLineItem);
			} else {
				mapContractLineItems.put(uniqueKey, new List<jj_rb_Rebate_Contract_Line_Item__c> {contractLineItem});
			}
		}
		
		// first validate the contract line items in the list
		for(jj_rb_Rebate_Contract_Line_Item__c newLineItem : listNewContractLineItems) 
		{
			// get the list of existing line items
			List<jj_rb_Rebate_Contract_Line_Item__c> lineItems = mapContractLineItems.get(getUniqueKey(newLineItem));
			for(jj_rb_Rebate_Contract_Line_Item__c lineItem : lineItems)
			{
				if(newLineItem == lineItem)
					continue;
				if(isDateOverLapping(newLineItem.jj_rb_Start_Date__c,newLineItem.jj_rb_End_Date__c,
										 lineItem.jj_rb_Start_Date__c, lineItem.jj_rb_End_Date__c )) {
							newLineItem.addError('There exists a contract line item with overlapping dates (' + 
                                lineItem.jj_rb_Start_Date__c.format() + ' to ' +
                                lineItem.jj_rb_End_Date__c.format() +
                                ') for a contract. Please change the dates and try again!');
                            break;			 	
					 }
					
			}
		}			
		
		
		// check the new rows with the existing rows	
		for(jj_rb_Rebate_Contract_Line_Item__c existingLineItems : [select Id,  jj_rb_Start_Date__c, jj_rb_End_Date__c, 
																			jj_rb_Rebate_Contract__r.jj_rb_Customer__c ,
																			jj_rb_Rebate_Contract__r.jj_rb_Product__c,
																			jj_rb_Product__c, recordTypeId, jj_rb_Region__c
																		from jj_rb_Rebate_Contract_Line_Item__c
																		where jj_rb_Status__c not in ('Closed')
																		and jj_rb_Product__c in :setQueryParams
																		and jj_rb_Rebate_Contract__r.jj_rb_Customer__c in :setQueryParams
																		and jj_rb_Region__c in :setQueryParams
																		and id not in :setExistingLineItem
																		 ]) {
			String uniqueKey = getUniqueKey(existingLineItems);
			if(mapContractLineItems.containsKey(uniqueKey)) {
				mapContractLineItems.get(uniqueKey).add(existingLineItems);
			} else {
				mapContractLineItems.put(uniqueKey, new List<jj_rb_Rebate_Contract_Line_Item__c> {existingLineItems});
			}															 	
		} // for-ends'
		
		//system.debug('mapContractLineItems existing>>>>>>'  +mapContractLineItems);
		
		// validate the DML contract line items with existing line items
		for(jj_rb_Rebate_Contract_Line_Item__c newLineItem : listNewContractLineItems)
		{
						
			// get the list of existing line items
			List<jj_rb_Rebate_Contract_Line_Item__c> existingLineItems = mapContractLineItems.get(getUniqueKey(newLineItem));
			for(jj_rb_Rebate_Contract_Line_Item__c existingLineItem : existingLineItems)
			{
				if(newLineItem.Id == existingLineItem.Id)
					continue;
				
				if(isDateOverLapping(newLineItem.jj_rb_Start_Date__c,newLineItem.jj_rb_End_Date__c,
										 existingLineItem.jj_rb_Start_Date__c, existingLineItem.jj_rb_End_Date__c )) {
							newLineItem.addError('There exists a contract line item with overlapping dates (' + 
                                existingLineItem.jj_rb_Start_Date__c.format() + ' to ' +
                                existingLineItem.jj_rb_End_Date__c.format() +
                                ') for a contract. Please change the dates and try again!');
                            break;			 	
				 }
			}			
		}			
	}
	
	private String getUniqueKey(jj_rb_Rebate_Contract_Line_Item__c lineItem) {
		String uniqueKey;
		if(lineItem.RecordTypeId == retailerRecordType) {
			 uniqueKey = lineItem.jj_rb_Rebate_Contract__r.jj_rb_Customer__c + '_' + lineItem.jj_rb_Product__c + '_' + lineItem.RecordTypeId;
		} else {
			 uniqueKey = lineItem.jj_rb_Rebate_Contract__r.jj_rb_Product__c + '_' + lineItem.jj_rb_Region__c  +'_'+ lineItem.RecordTypeId;
		} 	
		//system.debug('uniqueKey>>>>' + uniqueKey); 
		return uniqueKey;
	}
	
	 // This method checks for the validation of the overlapping dates
    private Boolean isDateOverLapping(Date startDate1, Date endDate1, Date startDate2, Date endDate2) {
        
        //system.debug(startDate1 + ' - ' + endDate1);
        //system.debug(startDate2 + ' - ' + endDate2);
        
        //system.debug('@@@@case 1 - ' + (startDate1 >= startDate2 && startDate1 <= endDate2));
        //system.debug('@@@@case 2 - ' + (endDate1  >= startDate2 && endDate1  <= endDate2));
        //system.debug('@@@@case 3 - ' + (startDate1 <= startDate2 && endDate1  >= endDate2));
        
        return (
            startDate1 >= startDate2 && startDate1 <= endDate2 ||
            endDate1  >= startDate2 && endDate1  <= endDate2 ||
            startDate1 <= startDate2 && endDate1  >= endDate2
        );
    }
}