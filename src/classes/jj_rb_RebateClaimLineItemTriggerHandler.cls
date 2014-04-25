/**
 * Handler class for RebateClaimLineItemTrigger
 */
 
public without sharing class jj_rb_RebateClaimLineItemTriggerHandler {
   
    public static Boolean alreadyFired = false;
   
   // Code for Homecare process to update rebate and check for valid contract 
    public static void checkForValidContracts()
    {
        Savepoint sp = Database.setSavepoint();
        try {
        String seperator = '_';
        Set<Id> setProduct = new Set<Id>();
        Set<ID> setcustomer= new Set<ID>();
        Set<Id> setHospital = new Set<Id>();
        Set<String> setMonthAndYear = new Set<String>(); 
        Set<ID> ids= new Set<ID>();
        Boolean qtyToleranceCheckFailed = false;
        List<jj_rb_Rebate_Claim_Line_Item__c> lstClaimsToUpdateclaims= new List<jj_rb_Rebate_Claim_Line_Item__c>();
        //record types
        
        String homecareclaimrecType=jj_rb_Rebate_utils.getRecordTypeID('Claim_Homecare');
        String HospitalType = jj_rb_Rebate_utils.getAccountType('Hospital');
        String homecareclaimLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Claim_LineItem_Homecare');
        String homecareContractLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Homecare_Contract_Line_Item');
        
        List<jj_rb_Rebate_Claim_Line_Item__c> lstClaimsToUpdate = new List<jj_rb_Rebate_Claim_Line_Item__c>();
        
        Map<String,jj_rb_Rebate_Claim_Line_Item__c> mapRebateClaimLineItems =new Map<String,jj_rb_Rebate_Claim_Line_Item__c>();         
        Map<String,jj_rb_Rebate_Claim_Line_Item__c> mapRebateClaimLines =new Map<String,jj_rb_Rebate_Claim_Line_Item__c>(); //key:customerandproduct        
        Map<Id, jj_rb_Rebate_Claim_Line_Item__c> mapClaimsToValidate = new Map<Id, jj_rb_Rebate_Claim_Line_Item__c>();
        Map<Id, jj_rb_Rebate_Claim_Line_Item__c> mapClaimsTocheck = new Map<Id, jj_rb_Rebate_Claim_Line_Item__c>();
        Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapRebateContractLineItems =new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>();
        Map<String, jj_rb_Tolerance__c> mapTolerance = new Map<String, jj_rb_Tolerance__c>();
        
        List<jj_rb_Rebate_Claim_Line_Item__c> listNewClaimLineItem=System.Trigger.new;
        
        List<jj_rb_Rebate_Claim_Line_Item__c> listClaimLineItemsdata=[select id,jj_rb_Rebate_Product__c,jj_rb_Quantity__c,jj_rb_Tolerance_Failed_Qty__c,
                                                     jj_rb_Hospital__c,jj_rb_Rebate_Claim__c,jj_rb_Rebate_Per_Unit__c,jj_rb_Rebate_Claim__r.jj_rb_Month__c,
                                                     jj_rb_Rebate_Claim__r.jj_rb_Customer__c,jj_rb_Difference_in_Qty__c, 
                                                     jj_rb_Rebate_Claim__r.jj_rb_Year__c,jj_rb_Calculated_quantity__c 
                                                     from jj_rb_Rebate_Claim_Line_Item__c WHERE Id IN: listNewClaimLineItem AND
                                                     jj_rb_Rebate_Product__c != null AND                                                            
                                                     jj_rb_Rebate_Claim__r.jj_rb_Month__c != null AND
                                                     jj_rb_Rebate_Claim__r.jj_rb_Year__c != null AND
                                                     RecordTypeID=:homecareclaimLI_recType];
      
               // Collecting the set of Hospital and Product records
        for(jj_rb_Rebate_Claim_Line_Item__c objItem: listClaimLineItemsdata)
        {
            String uniqueKey=objItem.jj_rb_Rebate_Product__c+seperator+objItem.jj_rb_Hospital__c;
            mapRebateClaimLineItems.put(uniqueKey,objItem);
            
            setProduct.add(objItem.jj_rb_Rebate_Product__c);
            setHospital.add(objItem.jj_rb_Hospital__c);
            
            // add month and year in a single set 
            setMonthAndYear.add(objItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c);
            setMonthAndYear.add(objItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c);
            mapClaimsToValidate.put(objItem.id,objItem);
        }

      
         // Collecting the set of customer and Product records
         for(jj_rb_Rebate_Claim_Line_Item__c objItem: listClaimLineItemsdata)
        {
            String uniqueKey=objItem.jj_rb_Rebate_Product__c+seperator+objItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c;
            mapRebateClaimLines.put(uniqueKey,objItem);            
            
            setProduct.add(objItem.jj_rb_Rebate_Product__c);
            setcustomer.add(objItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c);           
            mapClaimsTocheck.put(objItem.id,objItem);
        }
        
        List<Account> hospitallist=[select jj_rb_NHS_Trust__r.jj_rb_Region__c from Account where type=:HospitalType AND id IN:setHospital];
        Map<id,String>  mapNHSTrust= new Map<id,String>();//key:accountid
        for(Account account:hospitallist)
        {
            ids.add(account.jj_rb_NHS_Trust__r.jj_rb_Region__c);
            mapNHSTrust.put(account.id,account.jj_rb_NHS_Trust__r.jj_rb_region__c);
        }
        System.debug('mapNHSTrust>>>'+mapNHSTrust);
        
        List<jj_rb_Rebate_Contract_Line_Item__c> listcontractlineitems=[SELECT jj_rb_Status__c,jj_rb_Start_Date__c, jj_rb_Rebate__c, 
                                                                        jj_rb_Rebate_Contract__r.jj_rb_Product__c, jj_rb_Region__c, 
                                                                        jj_rb_End_Date__c,Name,Id 
                                                                        FROM jj_rb_Rebate_Contract_Line_Item__c 
                                                                        WHERE (jj_rb_Status__c ='Approved' OR jj_rb_Status__c ='Expired') AND
                                                                        jj_rb_Rebate_Contract__r.jj_rb_Product__c IN: setProduct AND
                                                                        jj_rb_Region__c IN: ids AND
                                                                        jj_rb_Start_Date__c != null AND
                                                                        jj_rb_End_Date__c != null
                                                                        AND recordTypeID=:homecareContractLI_recType];
       System.debug('@@@listcontractlineitems'+listcontractlineitems); 
         List<jj_rb_Rebate_Claim_Line_Item__c> linelist= new  List<jj_rb_Rebate_Claim_Line_Item__c>();
       for(jj_rb_Rebate_Claim_Line_Item__c claimline: listClaimLineItemsdata)
       { 
                                                                              
        // Prepare the map of unique keys vs contract Line items
        for(jj_rb_Rebate_Contract_Line_Item__c contractLineItem: listcontractlineitems) 
        {        
            String uniqueKey1 = claimline.jj_rb_Rebate_Product__c + seperator + 
                        claimline.jj_rb_Hospital__c;            
           
            String uniqueKey = contractLineItem.jj_rb_Rebate_Contract__r.jj_rb_Product__c + seperator +contractLineItem.jj_rb_Region__c;                        
            System.debug('uniqueKey'+uniqueKey );
            if(mapRebateClaimLineItems.containsKey(uniqueKey1)) 
            {
                jj_rb_Rebate_Claim_Line_Item__c objClaimLineItem = mapRebateClaimLineItems.get(uniqueKey1);                    
                // Form the start and end dates                      
                Integer month = Integer.valueOf(objClaimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c);
                Integer year = Integer.valueOf(objClaimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c);
                Date dtFirstDayOfMonth = Date.newInstance(year, month, 1);
                Date dtLastDayOfMonth = dtFirstDayOfMonth.addDays(Date.daysInMonth(dtFirstDayOfMonth.year(), dtFirstDayOfMonth.month()) - 1);
                                
                // call method to check overlapping
                Boolean isDateOverlapping = isDateOverLapping(dtFirstDayOfMonth,dtLastDayOfMonth,contractLineItem.jj_rb_Start_Date__c,contractLineItem.jj_rb_End_Date__c);
                if(isDateOverlapping)
                {
                    if(!mapRebateContractLineItems.containsKey(uniqueKey))
                    {
                        mapRebateContractLineItems.put(uniqueKey, new List<jj_rb_Rebate_Contract_Line_Item__c>{contractLineItem});
                    }
                    else 
                    {
                        mapRebateContractLineItems.get(uniqueKey).add(contractLineItem);
                    }
                   
                }
                  
            }
                
        }
        
        
        }
     System.debug('@@mapRebateContractLineItems'+mapRebateContractLineItems);
        for(jj_rb_Rebate_Claim_Line_Item__c claimline: listClaimLineItemsdata)
        {               
            if(mapClaimsToValidate.containsKey(claimline.id))
            {
                  jj_rb_Rebate_Claim_Line_Item__c objItem = mapClaimsToValidate.get(claimline.Id);
                  String productkey=objItem.jj_rb_Rebate_Product__c;
                  System.debug('productkey@@@'+productkey);
                  
                  String uniqueKey = objItem.jj_rb_Rebate_Product__c + seperator +objItem.jj_rb_Hospital__c; 
                  System.debug('uniqueKey@@@'+uniqueKey);    
                   
                  string customer=objItem.jj_rb_Hospital__c;
                  System.debug('customer@@@'+customer); 
                  
                  
                  string region=mapNHSTrust.get(customer);
                  System.debug('region@@@'+region); 
                  
                  String unique1=productkey+seperator+region;
                  System.debug('unique1@@@'+unique1); 
                  
                  List<jj_rb_Rebate_Contract_Line_Item__c> lstContractLineItem = mapRebateContractLineItems.get(unique1);
                  jj_rb_Rebate_Claim_Line_Item__c objClaimLineItem = mapRebateClaimLineItems.get(uniqueKey);
                  
                  System.debug('lstContractLineItem '+lstContractLineItem );
                  
                  
                  if(objClaimLineItem !=null && lstContractLineItem!=null && !lstContractLineItem.isEmpty())
                  {
                  lstClaimsToUpdateclaims.add(new jj_rb_Rebate_Claim_Line_Item__c(id=claimline.id,jj_rb_Calculated_rebate_price__c = lstContractLineItem[0].jj_rb_Rebate__c,
                         jj_rb_Assoc_Contract_Line_Item__c = lstContractLineItem[0].Id));                    
                  }
                  System.debug('lstClaimsToUpdateclaims'+lstClaimsToUpdateclaims);
            }
        }
       
        // get the tolerance data for the customer and product
        for(jj_rb_Tolerance__c tol : [select id, jj_rb_Customer__c, jj_rb_Product__c, jj_rb_Price_Tolerance__c, jj_rb_Quantity_Tolerance__c,
                                                    jj_rb_Average_Quantity__c
                                                    from jj_rb_Tolerance__c 
                                                    where jj_rb_Customer__c in :setCustomer
                                                    and jj_rb_Product__c in :setProduct])
        {
            String uniqueKey=tol.jj_rb_Customer__c + seperator + tol.jj_rb_Product__c;
            mapTolerance.put(uniqueKey,tol);   
        }  
        
        System.debug('mapTolerance'+mapTolerance);                                                    
        List<jj_rb_Rebate_Claim_Line_Item__c> claimsToUpdate= new  List<jj_rb_Rebate_Claim_Line_Item__c>();
        for(jj_rb_Rebate_Claim_Line_Item__c objclaimline: mapClaimsTocheck.values())
        {
            String uniqueKey= objclaimline.jj_rb_Rebate_Claim__r.jj_rb_Customer__c + seperator + objclaimline.jj_rb_Rebate_Product__c;
            
            jj_rb_Tolerance__c tolerancelist=mapTolerance.get(uniqueKey);  
            
            System.debug('tolerancelist'+tolerancelist);   
            Decimal qtyTolerance = 0;
            if(tolerancelist!= null && tolerancelist.jj_rb_Average_Quantity__c!=null)
            {
                
                qtyTolerance = tolerancelist.jj_rb_Quantity_Tolerance__c;
                qtyToleranceCheckFailed = (math.abs( objclaimline.jj_rb_Quantity__c- tolerancelist.jj_rb_Average_Quantity__c)/tolerancelist.jj_rb_Average_Quantity__c)*100 > qtyTolerance;
                
            } 
            else if((tolerancelist!= null && tolerancelist.jj_rb_Average_Quantity__c==null) || tolerancelist== null) 
            {
                qtyToleranceCheckFailed =  (math.abs( objclaimline.jj_rb_Difference_in_Qty__c) ) > 0;
            }
            if(tolerancelist!= null && tolerancelist.jj_rb_Average_Quantity__c!=null)
            {
            claimsToUpdate.add(new jj_rb_Rebate_Claim_Line_Item__c(id=objclaimline.id,
                                        jj_rb_Calculated_quantity__c=tolerancelist.jj_rb_Average_Quantity__c,
                                         jj_rb_Tolerance_Failed_Qty__c = qtyToleranceCheckFailed));
            }else if((tolerancelist!= null && tolerancelist.jj_rb_Average_Quantity__c==null) || tolerancelist== null) 
            {
                claimsToUpdate.add(new jj_rb_Rebate_Claim_Line_Item__c(id=objclaimline.id,
                                        jj_rb_Calculated_quantity__c=0,
                                         jj_rb_Tolerance_Failed_Qty__c = true));
            
            }
            
        } 
         
        if(!claimsToUpdate.isEmpty())
        {       
            update claimsToUpdate;
        
        }  
        
        if(lstClaimsToUpdateclaims!=null){
        
        update lstClaimsToUpdateclaims;
        }
        
    }catch(Exception ex)
    {
        Trigger.new[0].addError(''+ex);
    Database.rollBack(sp);
    }
    
    }
     
    //this method for retailer process
    public static void findActiveRebateContractLineItems() {
        
        Savepoint sp = Database.setSavepoint();
        try {
            String seperator = '_';
            List<jj_rb_Rebate_Claim_Line_Item__c> lstRebateClaimLineItems = Trigger.new;
            List<jj_rb_Rebate_Claim_Line_Item__c> lstFilteredRebateClaimLineItems = 
                new List<jj_rb_Rebate_Claim_Line_Item__c>();
            Set<Id> setProductAndCustomers = new Set<Id>();
            Set<String> setMonthAndYear = new Set<String>();
            
            
            String retailerContractLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Contract_LineItem_Retailer');
            String retailerClaimLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Claim_LineItem_Retailer'); 
               
            Map<String, jj_rb_Rebate_Claim_Line_Item__c> mapRebateClaimLineItems =
                new Map<String, jj_rb_Rebate_Claim_Line_Item__c>(); 
            Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapRebateContractLineItems =
                new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>();
            
            Map<Id, jj_rb_Rebate_Claim_Line_Item__c> mapClaimsToValidate = new Map<Id, jj_rb_Rebate_Claim_Line_Item__c>();
            
            // Collecting the set of Claim and Product records
            for(jj_rb_Rebate_Claim_Line_Item__c objItem: [SELECT Id, jj_rb_Rebate_Product__c,
                                                            jj_rb_Quantity__c, jj_rb_Rebate_Claim__r.jj_rb_Customer__c, 
                                                            jj_rb_Rebate_Claim__c,
                                                            jj_rb_Rebate_Claim__r.jj_rb_Month__c, 
                                                            jj_rb_Rebate_Claim__r.jj_rb_Year__c,
                                                            jj_rb_Calculated_quantity__c
                                                            FROM
                                                            jj_rb_Rebate_Claim_Line_Item__c
                                                            WHERE Id IN: lstRebateClaimLineItems AND
                                                            jj_rb_Rebate_Product__c != null AND
                                                            jj_rb_Rebate_Claim__r.jj_rb_Customer__c != null AND
                                                            jj_rb_Rebate_Claim__r.jj_rb_Month__c != null AND
                                                            jj_rb_Rebate_Claim__r.jj_rb_Year__c != null AND 
                                                            RecordTypeId=:retailerClaimLI_recType]) {
                    
                String uniqueKey = objItem.jj_rb_Rebate_Product__c + seperator + 
                    objItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c;
                mapRebateClaimLineItems.put(uniqueKey, objItem);
                
                setProductAndCustomers.add(objItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c);
                setProductAndCustomers.add(objItem.jj_rb_Rebate_Product__c);
                
                // add month and year in a single set
                setMonthAndYear.add(objItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c);
                setMonthAndYear.add(objItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c);
                
                mapClaimsToValidate.put(objItem.Id, objItem);
               
            }
                        
            // Prepare the map of unique keys vs contract Line items
            for(jj_rb_Rebate_Contract_Line_Item__c contractLineItem: [SELECT jj_rb_Status__c, jj_rb_Start_Date__c, jj_rb_Rebate__c, 
                                                                        jj_rb_Rebate_Contract__r.jj_rb_Customer__c, jj_rb_Product__c, 
                                                                        jj_rb_End_Date__c, Name, Id 
                                                                        FROM jj_rb_Rebate_Contract_Line_Item__c 
                                                                        WHERE (jj_rb_Status__c ='Approved' OR 
                                                                        jj_rb_Status__c ='Expired') AND
                                                                        jj_rb_Rebate_Contract__r.jj_rb_Customer__c IN: setProductAndCustomers AND
                                                                        jj_rb_Product__c IN: setProductAndCustomers AND
                                                                        jj_rb_Start_Date__c != null AND
                                                                        jj_rb_End_Date__c != null AND
                                                                        RecordTypeId=:retailerContractLI_recType]) {
              
                String uniqueKey = contractLineItem.jj_rb_Product__c + seperator + 
                    contractLineItem.jj_rb_Rebate_Contract__r.jj_rb_Customer__c;                
                if(mapRebateClaimLineItems.containsKey(uniqueKey)) {
                    jj_rb_Rebate_Claim_Line_Item__c objClaimLineItem = mapRebateClaimLineItems.get(uniqueKey);
                    
                    // Form the start and end dates
                    Integer month = Integer.valueOf(objClaimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c);
                    Integer year = Integer.valueOf(objClaimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c);
                    Date dtFirstDayOfMonth = Date.newInstance(year, month, 1);
                    Date dtLastDayOfMonth = dtFirstDayOfMonth.addDays(Date.daysInMonth(dtFirstDayOfMonth.year(), dtFirstDayOfMonth.month()) - 1);
                    
                    // call method to check overlapping
                    Boolean isDateOverlapping = isDateOverLapping(
                                dtFirstDayOfMonth,
                                dtLastDayOfMonth,
                                contractLineItem.jj_rb_Start_Date__c,
                                contractLineItem.jj_rb_End_Date__c);
                    
                    if(isDateOverlapping) {
                        if(!mapRebateContractLineItems.containsKey(uniqueKey)) {
                            mapRebateContractLineItems.put(uniqueKey, new List<jj_rb_Rebate_Contract_Line_Item__c>{contractLineItem});
                        } else {
                            mapRebateContractLineItems.get(uniqueKey).add(contractLineItem);
                        }
                    }
                }
            }
            
            // Updating the claim line items
            List<jj_rb_Rebate_Claim_Line_Item__c> lstClaimsToUpdate = new List<jj_rb_Rebate_Claim_Line_Item__c>();
            for(jj_rb_Rebate_Claim_Line_Item__c objClaim: lstRebateClaimLineItems) {
                if(mapClaimsToValidate.containsKey(objClaim.Id)) {
                    jj_rb_Rebate_Claim_Line_Item__c objItem = mapClaimsToValidate.get(objClaim.Id);
                    String uniqueKey = objItem.jj_rb_Rebate_Product__c + seperator + 
                        objItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c;
                        
                    List<jj_rb_Rebate_Contract_Line_Item__c> lstContractLineItem = mapRebateContractLineItems.get(uniqueKey);
                    jj_rb_Rebate_Claim_Line_Item__c objClaimLineItem = mapRebateClaimLineItems.get(uniqueKey);
                    
                    if(lstContractLineItem != null && 
                        !lstContractLineItem.isEmpty() &&
                        objClaimLineItem != null) {
                        lstClaimsToUpdate.add(new jj_rb_Rebate_Claim_Line_Item__c(
                            Id = objClaim.Id,
                            jj_rb_Calculated_rebate_price__c = lstContractLineItem[0].jj_rb_Rebate__c,
                            jj_rb_Assoc_Contract_Line_Item__c = lstContractLineItem[0].Id));                                                      
                    }
                }
            }
            
           
            
            /*---------------------------------------------------------------------------------------------------------------------------
            // check for ims quantity
            */
            // get ims data for the customer, product and period
            Map<String, jj_rb_IMS_Sales_Data__c> mapIMSData = new Map<String, jj_rb_IMS_Sales_Data__c>();
            Map<String, jj_rb_Tolerance__c> mapTolerance = new Map<String, jj_rb_Tolerance__c>();
            Map<Id, List<Id>> mapBuyingGroup = new Map<Id, List<Id>>(); //key-> Lead retailers, value -> list of sub retailers
            Boolean qtyToleranceCheckFailed = false;
            set<Id> setBuyingGroupMembers = new Set<Id>();
            
            // check if any of the customers is in a rebate buying group
            List<jj_rb_Retailer_Buying_Group_Member__c> listBuyingGroupMbr = [select id, jj_rb_Customer__c, 
                                                                                    jj_rb_Lead_Retailers__r.id, 
                                                                                    jj_rb_Lead_Retailers__r.jj_rb_Customer__c
                                                                            from jj_rb_Retailer_Buying_Group_Member__c
                                                                            where jj_rb_Lead_Retailers__r.jj_rb_Customer__c in  :setProductAndCustomers];   
            // prepare a list of rebate group members                                                          
            for(jj_rb_Retailer_Buying_Group_Member__c buyingGroupMbr : listBuyingGroupMbr){
                setBuyingGroupMembers.add(buyingGroupMbr.jj_rb_Customer__c);
                
                Id leadRetailerId = buyingGroupMbr.jj_rb_Lead_Retailers__r.jj_rb_Customer__c;
                Id subRetailerId = buyingGroupMbr.jj_rb_Customer__c;
                if(mapBuyingGroup.containsKey(leadRetailerId))
                {
                    List<Id> listMember = mapBuyingGroup.get(leadRetailerId);
                    listMember.add(subRetailerId);
                    mapBuyingGroup.put(leadRetailerId, listMember);
                } else {
                    mapBuyingGroup.put(leadRetailerId, new List<Id>{subRetailerId});
                }
            } 
            
            List<jj_rb_Rebate_Claim_Line_Item__c> lstClaimsToUpdate2 = new List<jj_rb_Rebate_Claim_Line_Item__c>();
            for(jj_rb_IMS_Sales_Data__c ims : [select Id, jj_rb_Customer__c, jj_rb_Product__c,
                                                      jj_rb_IMS_Volume__c, jj_rb_IMS_Data_Year__c,
                                                      jj_rb_IMS_Data_Month__c   
                                                    from jj_rb_IMS_Sales_Data__c
                                                    where (jj_rb_Customer__c in :setProductAndCustomers or  jj_rb_Customer__c in :setBuyingGroupMembers)
                                                    and jj_rb_Product__c in :setProductAndCustomers
                                                    and jj_rb_IMS_Data_Month__c in :setMonthAndYear
                                                    and jj_rb_IMS_Data_Year__c in :setMonthAndYear]) {
                    
                    String uniqueKey = ims.jj_rb_Customer__c + seperator +
                                       ims.jj_rb_Product__c + seperator + 
                                       ims.jj_rb_IMS_Data_Month__c + seperator + 
                                       ims.jj_rb_IMS_Data_Year__c;  
                    mapIMSData.put(uniqueKey, ims);                                                                 
            }
            // get the tolerance data for the customer and product
            for(jj_rb_Tolerance__c tol : [select id, jj_rb_Customer__c, jj_rb_Product__c, jj_rb_Price_Tolerance__c, jj_rb_Quantity_Tolerance__c
                                                    from jj_rb_Tolerance__c 
                                                    where jj_rb_Customer__c in :setProductAndCustomers
                                                    and jj_rb_Product__c in :setProductAndCustomers]) {
                String uniqueKey = tol.jj_rb_Customer__c + seperator + tol.jj_rb_Product__c;
                mapTolerance.put(uniqueKey, tol);                                       
                                                        
            }
                        
            for(jj_rb_Rebate_Claim_Line_Item__c claimLineItem : mapClaimsToValidate.values())
            {
                String uniqueKey =  claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c + seperator +
                                    claimLineItem.jj_rb_Rebate_Product__c + seperator +                                     
                                    claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c + seperator + 
                                    claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c;
                // get ims data
                jj_rb_IMS_Sales_Data__c ims = mapIMSData.get(uniqueKey);
                
                if(ims != null) {
                     
                     // get the IMS vol
                     Decimal imsVolume = ims.jj_rb_IMS_Volume__c;
                     
                     // if the customer is a lead retailer in a rebate buying group then calculate the actual ims volume
                     if(mapBuyingGroup.containsKey(claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c))
                     {
                        List<Id> listSubRetailer = mapBuyingGroup.get(claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c);
                        for(Id subRetailerId : listSubRetailer)
                        {
                            String imsUniqueKey = subRetailerId +  seperator +
                                                  claimLineItem.jj_rb_Rebate_Product__c + seperator +                                     
                                                claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c + seperator + 
                                                claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c;  
                                                  
                            jj_rb_IMS_Sales_Data__c imsBG = mapIMSData.get(imsUniqueKey);
                            if(imsBG != null)
                            {
                               imsVolume-= imsBG.jj_rb_IMS_Volume__c;   
                            }                           
                        }
                     }
                      
                     
                     
                     jj_rb_Tolerance__c tol = mapTolerance.get(claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c + seperator +
                                                                        claimLineItem.jj_rb_Rebate_Product__c);     
                     Decimal qtyTolerance = 0;
                     if(tol != null) {
                        qtyTolerance = tol.jj_rb_Quantity_Tolerance__c;
                        qtyToleranceCheckFailed = (math.abs( imsVolume - claimLineItem.jj_rb_Quantity__c )/imsVolume)*100 > qtyTolerance;
                     } else {
                        qtyToleranceCheckFailed =  ( math.abs(imsVolume - claimLineItem.jj_rb_Quantity__c) ) > 0;
                     }
                     
                     lstClaimsToUpdate2.add(new jj_rb_Rebate_Claim_Line_Item__c(id = claimLineItem.Id, 
                                                                               jj_rb_Calculated_quantity__c = imsVolume,
                                                                               jj_rb_Tolerance_Failed_Qty__c = qtyToleranceCheckFailed,
                                                                               jj_rb_Assoc_IMS_Sales_Data__c = ims.id));                
                } else {
                    lstClaimsToUpdate2.add(new jj_rb_Rebate_Claim_Line_Item__c(id = claimLineItem.Id, 
                                                                               jj_rb_Calculated_quantity__c = 0,
                                                                               jj_rb_Tolerance_Failed_Qty__c = true));
                }
                
            }
            
            
             // Trigger.new[0].addError(''+lstClaimsToUpdate);
            if(!lstClaimsToUpdate.isEmpty()) {
                update lstClaimsToUpdate;
            }
            
            if(!lstClaimsToUpdate2.isEmpty()) {
                update lstClaimsToUpdate2;
            }
           
        } catch(Exception objEx) {
            Trigger.new[0].addError('' + objEx);
            Database.rollback(sp);
        }
    }
    
    
    // code for Home care and Retailer process Product Duplicate prevention
    public static void checkForDuplicateLineItems()
    {        
        Set<Id> setClaimIds = new Set<Id>();
        Set<Id> setClaimAccounts = new Set<Id>();
        Set<Id> setClaimProducts = new Set<Id>();
        Set<ID> setHomecareHospitals= new Set<ID>();
        Set<String> setClaimMonth = new Set<String>();
        Set<String> setClaimYear = new Set<String>();
        
        
        String homecareclaimrecType=jj_rb_Rebate_utils.getRecordTypeID('Claim_Homecare');
        String retailerclaim_recType=jj_rb_Rebate_utils.getRecordTypeID('Rebate_Claim_Retailer');
        String retailerclaimLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Claim_LineItem_Retailer');
        String homecareclaimLI_recType=jj_rb_Rebate_utils.getRecordTypeID('Claim_LineItem_Homecare');
        
        
        Map<String, jj_rb_Rebate_Claim_Line_Item__c> mapNotUniqueRetailerClaimLineItem = new map<String, jj_rb_Rebate_Claim_Line_Item__c>();
        Map<String, jj_rb_Rebate_Claim_Line_Item__c> mapNotUniqueHomecareClaimLineItem = new map<String, jj_rb_Rebate_Claim_Line_Item__c>();
                
        List<jj_rb_Rebate_Claim_Line_Item__c> listNewClaimLineItems = System.trigger.new;   
        
        // prepare sets of claim ids and claim products
        for(jj_rb_Rebate_Claim_Line_Item__c newLineItem : listNewClaimLineItems)
        {
            setClaimIds.add(newLineItem.jj_rb_Rebate_Claim__c);
            setClaimProducts.add(newLineItem.jj_rb_Rebate_Product__c);
        }
        
        // get the retailer claims associated with the new line items
        Map<Id, jj_rb_Rebate_Claim__c> mapRetailerClaim = new Map<Id, jj_rb_Rebate_Claim__c> ([select Id, jj_rb_Customer__c, toLabel(jj_rb_Month__c), jj_rb_Year__c
                                                                                                from jj_rb_Rebate_Claim__c where id in :setClaimIds AND RecordTypeID=:retailerclaim_recType]);

        // get the Homecare claims associated with the new line items
        Map<Id, jj_rb_Rebate_Claim__c> mapHomecareClaim = new Map<Id, jj_rb_Rebate_Claim__c> ([select Id, jj_rb_Customer__c, toLabel(jj_rb_Month__c), jj_rb_Year__c
                                                                                                from jj_rb_Rebate_Claim__c where id in :setClaimIds AND RecordTypeID=:homecareclaimrecType]);        
        
        
        // check if there is a claim line item with the same customer, product, claim month and year
        for(jj_rb_Rebate_Claim_Line_Item__c newLineItem : listNewClaimLineItems)
        {       
            jj_rb_Rebate_Claim__c claim = mapRetailerClaim.get(newLineItem.jj_rb_Rebate_Claim__c);
            jj_rb_Rebate_Claim__c homecareClaim=mapHomecareClaim.get(newLineItem.jj_rb_Rebate_Claim__c);
            
            if(claim!=null)
            {
                setClaimAccounts.add(claim.jj_rb_Customer__c);      
                setClaimMonth.add(claim.jj_rb_Month__c);
                setClaimYear.add(claim.jj_rb_Year__c);
                // check if a duplicate is present in the records being inserted
                String uniqueKey = prepareUniqueKey(claim.jj_rb_Customer__c,
                                                                newLineItem.jj_rb_Rebate_Product__c, 
                                                                claim.jj_rb_Month__c, 
                                                                claim.jj_rb_Year__c);
                if(mapNotUniqueRetailerClaimLineItem.containsKey(uniqueKey))
                {
                    newLineItem.addError(newLineItem.jj_rb_Rebate_Product__r.Name + ' has already been claimed for the period of ' + newLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c + ' ' + newLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c + '.');               
                } 
                mapNotUniqueRetailerClaimLineItem.put(uniqueKey, newLineItem);          
            }
            else if(homecareClaim!=null)
            {
                setClaimAccounts.add(homecareClaim.jj_rb_Customer__c);      
                setClaimMonth.add(homecareClaim.jj_rb_Month__c);
                setClaimYear.add(homecareClaim.jj_rb_Year__c);
                // check if a duplicate is present in the record being inserted
                String uniqueKey1=prepareUniqueKeyFOrHomecare(homecareClaim.jj_rb_Customer__c,
                                                                newLineItem.jj_rb_Rebate_Product__c,
                                                                newLineItem.jj_rb_hospital__c,                                                              
                                                                homecareClaim.jj_rb_Month__c,
                                                                homecareClaim.jj_rb_Year__c);               
                if(mapNotUniqueHomecareClaimLineItem.containsKey(uniqueKey1))
                {
                    newLineItem.addError(newLineItem.jj_rb_Rebate_Product__r.Name + ' ' + 'for'+ ' ' + newLineItem.jj_rb_hospital__r.name + ' ' + 'has already been claimed for the period of ' + newLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c + ' ' + newLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c + '.');                                     
                }
                mapNotUniqueHomecareClaimLineItem.put(uniqueKey1,newLineItem);
            }
            
        }
        
        // get all old Retailer line items with the same customer, product, month and year.
        for (jj_rb_Rebate_Claim_Line_Item__c oldLineItem : [select Id, jj_rb_Rebate_Claim__c, jj_rb_Rebate_Claim__r.jj_rb_Customer__c,
                                                                              jj_rb_Rebate_Product__c, jj_rb_Rebate_Product__r.Name,
                                                                              toLabel(jj_rb_Rebate_Claim__r.jj_rb_Month__c),
                                                                              jj_rb_Rebate_Claim__r.jj_rb_Year__c
                                                                        from jj_rb_Rebate_Claim_Line_Item__c
                                                                        where jj_rb_Rebate_Claim__r.jj_rb_Customer__c in :setClaimAccounts
                                                                        and  jj_rb_Rebate_Product__c in :setClaimProducts
                                                                        and id NOT IN : listNewClaimLineItems
                                                                        and  toLabel(jj_rb_Rebate_Claim__r.jj_rb_Month__c) in :setClaimMonth
                                                                        and jj_rb_Rebate_Claim__r.jj_rb_Year__c in :setClaimYear 
                                                                        AND RecordTypeID=:retailerclaimLI_recType])
        {
            String uniqueKey = prepareUniqueKey(oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c,
                                                           oldLineItem.jj_rb_Rebate_Product__c, 
                                                           oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c, 
                                                           oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c);            
            jj_rb_Rebate_Claim_Line_Item__c newLineItem = mapNotUniqueRetailerClaimLineItem.get(uniqueKey);
            if(newLineItem != null){
                newLineItem.addError(oldLineItem.jj_rb_Rebate_Product__r.Name + ' has already been claimed for the period of ' + oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c + ' ' + oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c + '.');
            }
            
        }
        
        // get all old Homecare claim line items with same customer,product,hospital,month,year
        for (jj_rb_Rebate_Claim_Line_Item__c oldLineItem : [select Id, jj_rb_Rebate_Claim__c, jj_rb_Rebate_Claim__r.jj_rb_Customer__c,
                                                                              jj_rb_Rebate_Product__c, jj_rb_Rebate_Product__r.Name,
                                                                              toLabel(jj_rb_Rebate_Claim__r.jj_rb_Month__c),
                                                                              jj_rb_Rebate_Claim__r.jj_rb_Year__c,jj_rb_Hospital__c,jj_rb_Hospital__r.name                                                                              
                                                                        from jj_rb_Rebate_Claim_Line_Item__c
                                                                        where jj_rb_Rebate_Claim__r.jj_rb_Customer__c in :setClaimAccounts
                                                                        and  jj_rb_Rebate_Product__c in :setClaimProducts
                                                                        and id NOT IN : listNewClaimLineItems
                                                                        and  toLabel(jj_rb_Rebate_Claim__r.jj_rb_Month__c) in :setClaimMonth
                                                                        and jj_rb_Rebate_Claim__r.jj_rb_Year__c in :setClaimYear 
                                                                        AND RecordTypeID=:homecareclaimLI_recType])
        {
            String uniqueKey1=prepareUniqueKeyFOrHomecare(oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Customer__c,
                                                                oldLineItem.jj_rb_Rebate_Product__c,
                                                                oldLineItem.jj_rb_Hospital__c,
                                                                oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c,
                                                                oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c);                                                                             
            
            jj_rb_Rebate_Claim_Line_Item__c newLineItem = mapNotUniqueHomecareClaimLineItem.get(uniqueKey1);
            if(newLineItem != null){
                newLineItem.addError(oldLineItem.jj_rb_Rebate_Product__r.Name +' '+ 'for'+ ' ' + oldLineItem.jj_rb_Hospital__r.name + ' ' + 'has already been claimed for the period of ' + oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Month__c + ' ' + oldLineItem.jj_rb_Rebate_Claim__r.jj_rb_Year__c + '.');                
            }
        }
        
    }    
    
    private static String prepareUniqueKey(String accountId, String productId, String month, String year){
        return  accountId + '-' + productId + '-' + month + '-' + year;     
    }
    
    private static String prepareUniqueKeyFOrHomecare(String accountId, String productId,String hospitalid,String month, String year)
    {
        return  accountId + '-' + productId + '-' + hospitalid +  '_'+ month + '-' + year;  
    
    }
    
    // This method checks for the validation of the overlapping dates
    private static Boolean isDateOverLapping(Date startDate1, Date endDate1, Date startDate2, Date endDate2) {
        
        system.debug(startDate1 + ' - ' + endDate1);
        system.debug(startDate2 + ' - ' + endDate2);
        
        system.debug(startDate1 + ' >= ' + startDate2 + ' && ' + startDate1 + ' <= ' + endDate2 + ' - @@@@case 1 - ' + (startDate1 >= startDate2 && startDate1 <= endDate2));
        system.debug(endDate1 + ' >= ' + startDate2 + ' && ' + endDate1 + ' <= ' + endDate2 + ' - @@@@case 2 - ' + (endDate1  >= startDate2 && endDate1  <= endDate2));
        system.debug(startDate1 + ' <= ' + startDate2 + ' && ' + endDate1 + ' >= ' + endDate2 + ' - @@@@case 3 - ' + (startDate1 <= startDate2 && endDate1  >= endDate2));
        
        return (
            startDate1 >= startDate2 && startDate1 <= endDate2 ||
            endDate1  >= startDate2 && endDate1  <= endDate2 ||
            startDate1 <= startDate2 && endDate1  >= endDate2
        );
    }
    
        
    
}