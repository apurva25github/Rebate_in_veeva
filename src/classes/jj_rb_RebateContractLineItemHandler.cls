/*
    Handler for RebateContractLineItem.trigger
*/

public class jj_rb_RebateContractLineItemHandler  {
    
    @TestVisible public static final String LINEITEM_STATUS_STATUS = 'New';
    String retailerRecordTypeID = jj_rb_Rebate_utils.getRecordTypeId('Retailer contract line item');
    String homecareProviderRecordTypeID = jj_rb_Rebate_utils.getRecordTypeId('HCP Contract line item');
    // Constructor
    public jj_rb_RebateContractLineItemHandler () {}
    
    public void performDateRangeValidation(
        List<jj_rb_Rebate_Contract_Line_Item__c> lstContractLineItems, 
        Map<Id, jj_rb_Rebate_Contract_Line_Item__c> mapContractLineItems) {
            
        try {
        
            Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapContractWithLineItems = 
                new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>();
           Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapHCPContractWithLineItems = 
                new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>();
                
            Map<Id, List<jj_rb_Rebate_Contract_Line_Item__c>> mapProductsWithLineItems = 
                new Map<Id, List<jj_rb_Rebate_Contract_Line_Item__c>>();
            
            Map<Id, List<jj_rb_Rebate_Contract_Line_Item__c>> mapRegionWithLineItems = 
                new Map<Id, List<jj_rb_Rebate_Contract_Line_Item__c>>();
                
            String strKeySeperator = '_';
                
            Set<Id> setContracts = new Set<Id>();
            Set<Id> setProducts = new Set<Id>();
            Set<ID> setHCPRegion= new Set<id>();
            Set<ID> setHCPContracts= new Set<id>();
            
            // Collect the jj_rb_Rebate_Contract_Line_Item__c Records
            for(jj_rb_Rebate_Contract_Line_Item__c newContact: lstContractLineItems) {
            
                if(newContact.jj_rb_Status__c != LINEITEM_STATUS_STATUS && 
                            (newContact.RecordTypeId ==retailerRecordTypeID ||newContact.RecordTypeId ==homecareProviderRecordTypeID )) {
                    continue;
                }
                
                // Do not process if it is update case and any of the dates are null or has not been changed
                if(mapContractLineItems != null&& newContact.RecordTypeId ==retailerRecordTypeID) {
                    jj_rb_Rebate_Contract_Line_Item__c oldContact = mapContractLineItems.get(newContact.Id);
                    if(newContact.jj_rb_Start_Date__c == null && 
                        oldContact.jj_rb_Start_Date__c == newContact.jj_rb_Start_Date__c && 
                        newContact.jj_rb_End_Date__c == null && 
                        oldContact.jj_rb_End_Date__c == newContact.jj_rb_End_Date__c || 
                        (newContact.jj_rb_Status__c != LINEITEM_STATUS_STATUS &&
                         oldContact.jj_rb_Status__c == newContact.jj_rb_Status__c)) {
                        // continue;
                    }
                }
                else if(mapContractLineItems != null && newContact.RecordTypeId ==homecareProviderRecordTypeID)
                {
                    jj_rb_Rebate_Contract_Line_Item__c oldHCPContact = mapContractLineItems.get(newContact.Id);
                    if(newContact.jj_rb_Start_Date__c == null && 
                        oldHCPContact.jj_rb_Start_Date__c == newContact.jj_rb_Start_Date__c && 
                        newContact.jj_rb_End_Date__c == null && 
                        oldHCPContact.jj_rb_End_Date__c == newContact.jj_rb_End_Date__c || 
                        (newContact.jj_rb_Status__c != LINEITEM_STATUS_STATUS &&
                         oldHCPContact.jj_rb_Status__c == newContact.jj_rb_Status__c))
                          {
                       
                          }
                }
                
                
                // Collecting the Contract Ids
                if(!String.isEmpty(newContact.jj_rb_Rebate_Contract__c) && newContact.RecordTypeId ==retailerRecordTypeID) {
                    setContracts.add(newContact.jj_rb_Rebate_Contract__c);
                }
                else if(!String.isEmpty(newContact.jj_rb_Rebate_Contract__c) && newContact.RecordTypeId ==homecareProviderRecordTypeID )
                {                    
                    setHCPContracts.add(newContact.jj_rb_Rebate_Contract__c);                
                }
                
                // Collecting the Product Ids
                if(!String.isEmpty(newContact.jj_rb_Product__c)) {
                    setProducts.add(newContact.jj_rb_Product__c);
                }
                else if(!String.isEmpty(newContact.jj_rb_Region__c)) {
                    setHCPRegion.add(newContact.jj_rb_Region__c);
                }
            }
            
            System.debug('@@@@setContracts - '+setContracts);
            System.debug('@@@@setHCPContracts- '+setHCPContracts);
            
            
            // Prepare map of Retailer jj_rb_Rebate_Contract__c's with respective Retailer jj_rb_Rebate_Contract_Line_Item__c
            for(jj_rb_Rebate_Contract_Line_Item__c eachContract: 
                [SELECT Id, jj_rb_Start_Date__c, jj_rb_End_Date__c, jj_rb_Rebate_Contract__c, jj_rb_Status__c, jj_rb_Product__c
                    FROM jj_rb_Rebate_Contract_Line_Item__c 
                    WHERE 
                    jj_rb_Rebate_Contract__c IN: setContracts AND
                    jj_rb_Status__c =: LINEITEM_STATUS_STATUS AND
                    RecordTypeId =: retailerRecordTypeID]) {
                String strKey = eachContract.jj_rb_Rebate_Contract__c + strKeySeperator + eachContract.jj_rb_Product__c;
                if(!mapContractWithLineItems.containsKey(strKey)) {
                    mapContractWithLineItems.put(strKey, 
                        new List<jj_rb_Rebate_Contract_Line_Item__c>{eachContract});
                } else {
                    mapContractWithLineItems.get(strKey).add(eachContract);
                }
            }
            
            // Prepare map of  Home care provider jj_rb_Rebate_Contract__c's with respective Home care Provider jj_rb_Rebate_Contract_Line_Item__c
            for(jj_rb_Rebate_Contract_Line_Item__c eachHCPContract: 
                [SELECT Id, jj_rb_Start_Date__c, jj_rb_End_Date__c, jj_rb_Rebate_Contract__c, jj_rb_Status__c,jj_rb_Region__c
                    FROM jj_rb_Rebate_Contract_Line_Item__c 
                    WHERE 
                    jj_rb_Rebate_Contract__c IN: setHCPContracts AND
                    jj_rb_Status__c =: LINEITEM_STATUS_STATUS AND
                    RecordTypeId =: homecareProviderRecordTypeID ]) {
                String strKey = eachHCPContract.jj_rb_Rebate_Contract__c + strKeySeperator + eachHCPContract.jj_rb_Region__c;
                if(!mapHCPContractWithLineItems.containsKey(strKey)) {
                    mapHCPContractWithLineItems.put(strKey, 
                        new List<jj_rb_Rebate_Contract_Line_Item__c>{eachHCPContract});
                } else {
                    mapHCPContractWithLineItems.get(strKey).add(eachHCPContract);
                }
            }
            
            System.debug(mapContractWithLineItems.values().size() + ' @@@@mapContractWithLineItems- '+mapContractWithLineItems);
             System.debug(mapHCPContractWithLineItems.values().size() + ' @@@@mapHCPContractWithLineItems - '+mapHCPContractWithLineItems );
            
            System.debug('@@@@setProducts- '+setProducts);
            System.debug('@@@@setHCPRegion- '+setHCPRegion);
            
            // Prepare map of Retailer jj_rb_Product__c's with respective jj_rb_Rebate_Contract_Line_Item__c
            for(jj_rb_Rebate_Contract_Line_Item__c eachContact: 
                [SELECT Id, jj_rb_Start_Date__c, jj_rb_End_Date__c, jj_rb_Product__c, jj_rb_Status__c
                    FROM jj_rb_Rebate_Contract_Line_Item__c 
                    WHERE 
                    jj_rb_Product__c IN: setProducts AND
                    jj_rb_Status__c =: LINEITEM_STATUS_STATUS AND
                     RecordTypeId =: retailerRecordTypeID]) {
    
                if(!mapProductsWithLineItems.containsKey(eachContact.jj_rb_Product__c)) {
                    mapProductsWithLineItems.put(eachContact.jj_rb_Product__c, 
                        new List<jj_rb_Rebate_Contract_Line_Item__c>{eachContact});
                } else {
                    mapProductsWithLineItems.get(eachContact.jj_rb_Product__c).add(eachContact);
                }
            }
            
            // Prepare map of Home care provider jj_rb_Region__c's with respective jj_rb_Rebate_Contract_Line_Item__c
            for(jj_rb_Rebate_Contract_Line_Item__c eachContact: 
                [SELECT Id, jj_rb_Start_Date__c, jj_rb_End_Date__c, jj_rb_Region__c,jj_rb_Status__c
                    FROM jj_rb_Rebate_Contract_Line_Item__c 
                    WHERE 
                        jj_rb_Region__c IN: setHCPRegion AND
                    jj_rb_Status__c =: LINEITEM_STATUS_STATUS AND
                     RecordTypeId =: homecareProviderRecordTypeID ]) {
    
                if(!mapRegionWithLineItems.containsKey(eachContact.jj_rb_Region__c)) {
                    mapRegionWithLineItems.put(eachContact.jj_rb_Region__c, 
                        new List<jj_rb_Rebate_Contract_Line_Item__c>{eachContact});
                } else {
                    mapRegionWithLineItems.get(eachContact.jj_rb_Region__c).add(eachContact);
                }
            }
            
            System.debug(mapProductsWithLineItems.values().size() + ' @@@@mapProductsWithLineItems- '+mapProductsWithLineItems);
            System.debug(mapRegionWithLineItems.values().size() + ' @@@@mapRegionWithLineItems - '+mapRegionWithLineItems );
            
            // Iterate the original inserted records
            for(jj_rb_Rebate_Contract_Line_Item__c currentContact: lstContractLineItems) {
                
                // Only process if the record is approved
                if(currentContact.jj_rb_Status__c != LINEITEM_STATUS_STATUS && currentContact.RecordTypeId == retailerRecordTypeID) {
                    continue;
                }
                else if(currentContact.jj_rb_Status__c != LINEITEM_STATUS_STATUS && currentContact.RecordTypeId == homecareProviderRecordTypeID ) {
                    continue;
                }
                
                Boolean isErrorAdded = false;
                
                String strKey = currentContact.jj_rb_Rebate_Contract__c + strKeySeperator + currentContact.jj_rb_Product__c;
                String strKeyRegion = currentContact.jj_rb_Rebate_Contract__c + strKeySeperator + currentContact.jj_rb_Region__c;
                // Iterate all the existing Line Items related to contract and 
                // validate overlapping with All Contract Line Items within the Contract
                if(mapContractWithLineItems.containsKey(strKey)) {
                    
                    System.debug('@@@@currentContact.jj_rb_Status__c - '+currentContact.jj_rb_Status__c);
                    
                    for(jj_rb_Rebate_Contract_Line_Item__c otherContact: 
                        mapContractWithLineItems.get(strKey)) {
                        // Do not check overlapping with itself!
                        if(otherContact.Id == currentContact.Id) {
                            continue;
                        }
                        
                        Boolean isDateOverlapping = isDateOverLapping(otherContact.jj_rb_Start_Date__c,
                            otherContact.jj_rb_End_Date__c,
                            currentContact.jj_rb_Start_Date__c,
                            currentContact.jj_rb_End_Date__c);
                        
                        System.debug('@@@@otherContact.jj_rb_Status__c - '+otherContact.jj_rb_Status__c);
                        
                        if(isDateOverlapping) {
                            
                            System.debug('@@@@Adding error!');
                            currentContact.addError('There exists a New contract line item with overlapping dates (' + 
                                otherContact.jj_rb_Start_Date__c.format() + ' to ' +
                                otherContact.jj_rb_End_Date__c.format() +
                                ') inside a Contract with Same Product, Please change the dates and try again!');
                            isErrorAdded = true;
                            break;
                        }
                    }
                }
                else if(mapHCPContractWithLineItems.containsKey(strKeyRegion )) {
                    
                    System.debug('@@@@HCP@@@@currentContact.jj_rb_Status__c - '+currentContact.jj_rb_Status__c);
                    
                    for(jj_rb_Rebate_Contract_Line_Item__c otherContact: 
                        mapHCPContractWithLineItems.get(strKeyRegion )) {
                        // Do not check overlapping with itself!
                        if(otherContact.Id == currentContact.Id) {
                            continue;
                        }
                        
                        Boolean isDateOverlapping = isDateOverLapping(otherContact.jj_rb_Start_Date__c,
                            otherContact.jj_rb_End_Date__c,
                            currentContact.jj_rb_Start_Date__c,
                            currentContact.jj_rb_End_Date__c);
                        
                        System.debug('@@@@otherContact.jj_rb_Status__c - '+otherContact.jj_rb_Status__c);
                        
                        if(isDateOverlapping) {
                            
                            System.debug('@@@@Adding error!');
                            currentContact.addError('There exists a New contract line item with overlapping dates (' + 
                                otherContact.jj_rb_Start_Date__c.format() + ' to ' +
                                otherContact.jj_rb_End_Date__c.format() +
                                ') inside a Contract with Same Region, Please change the dates and try again!');
                            isErrorAdded = true;
                            break;
                        }
                    }
                }
                
                // If the dates are overlapping within contract, then do not check for if they exists within contract!
                if(isErrorAdded) {
                    continue;
                }
                
                // Iterate all the existing Line Items related to Prodcust and 
                // validate overlapping with All Contract Line Items within the Product
                if(mapProductsWithLineItems.containsKey(currentContact.jj_rb_Product__c)) {
                    
                    System.debug('@@@@currentContact.jj_rb_Status__c - '+currentContact.jj_rb_Status__c);
                    
                    for(jj_rb_Rebate_Contract_Line_Item__c otherContact: 
                        mapProductsWithLineItems.get(currentContact.jj_rb_Product__c)) {
                        // Do not check overlapping with itself!
                        if(otherContact.Id == currentContact.Id) {
                            continue;
                        }
                        
                        Boolean isDateOverlapping = isDateOverLapping(otherContact.jj_rb_Start_Date__c,
                            otherContact.jj_rb_End_Date__c,
                            currentContact.jj_rb_Start_Date__c,
                            currentContact.jj_rb_End_Date__c);
                        
                        System.debug('@@@@otherContact.jj_rb_Status__c - '+otherContact.jj_rb_Status__c);
                        
                        if(isDateOverlapping) {
                            
                            System.debug('@@@@Adding error!');
                            currentContact.addError('There exists a New contract line item with overlapping dates (' + 
                                otherContact.jj_rb_Start_Date__c.format() + ' to ' +
                                otherContact.jj_rb_End_Date__c.format() +
                                ') inside a products, Please change the dates and try again!');
                            break;
                        }
                    }
                }
                 // Iterate all the existing Line Items related to Region and 
                // validate overlapping with All Contract Line Items within the Region
                else if(mapRegionWithLineItems.containsKey(currentContact.jj_rb_Region__c)) {
                    
                    System.debug('@@@@currentContact.jj_rb_Status__c - '+currentContact.jj_rb_Status__c);
                    
                    for(jj_rb_Rebate_Contract_Line_Item__c otherRegionContract: 
                        mapRegionWithLineItems .get(currentContact.jj_rb_Region__c)) {
                        // Do not check overlapping with itself!
                        if(otherRegionContract.Id == currentContact.Id) {
                            continue;
                        }
                        
                        Boolean isDateOverlapping = isDateOverLapping(otherRegionContract.jj_rb_Start_Date__c,
                            otherRegionContract.jj_rb_End_Date__c,
                            currentContact.jj_rb_Start_Date__c,
                            currentContact.jj_rb_End_Date__c);
                        
                        System.debug('@@@@otherContact.jj_rb_Status__c - '+otherRegionContract.jj_rb_Status__c);
                        
                        if(isDateOverlapping) {
                            
                            System.debug('@@@@Adding error!');
                            currentContact.addError('There exists a New contract line item with overlapping dates (' + 
                                otherRegionContract.jj_rb_Start_Date__c.format() + ' to ' +
                                otherRegionContract.jj_rb_End_Date__c.format() +
                                ') inside a Region, Please change the dates and try again!');
                            break;
                        }
                    }
                }
            
            }
        } catch(Exception objEx) {
            Trigger.new[0].addError('Error#' + objEx.getLineNumber() + ': ' +objEx.getMessage());
        }
    }
    
    // This method checks for the validation of the overlapping dates
    public static Boolean isDateOverLapping(Date startDate1, Date endDate1, Date startDate2, Date endDate2) {
        
        system.debug(startDate1 + ' - ' + endDate1);
        system.debug(startDate2 + ' - ' + endDate2);
        
        system.debug('@@@@case 1 - ' + (startDate1 >= startDate2 && startDate1 <= endDate2));
        system.debug('@@@@case 2 - ' + (endDate1  >= startDate2 && endDate1  <= endDate2));
        system.debug('@@@@case 3 - ' + (startDate1 <= startDate2 && endDate1  >= endDate2));
        
        return (
            startDate1 >= startDate2 && startDate1 <= endDate2 ||
            endDate1  >= startDate2 && endDate1  <= endDate2 ||
            startDate1 <= startDate2 && endDate1  >= endDate2
        );
    }

}