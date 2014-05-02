global class jj_rb_HCPAccrualcalc extends jj_rb_rebateAccrualBaseClass implements Database.batchable<sObject> 
{
     static id hcpRecordtypeID = jj_rb_rebate_utils.getRecordTypeId('Account_Homecare');
     
     global Database.QueryLocator start(Database.BatchableContext BC)
     {
         String query = 'SELECT Id,jj_rb_IMS_Customer_Id__c,Account_Type__c,jj_rb_National_Channel_Manager__c,jj_rb_SAP_Customer_Number__c,Name,RecordTypeId FROM Account where RecordTypeID =: hcpRecordtypeID'; 
            return Database.getQueryLocator(query);
     }
     
     
     global void execute(Database.BatchableContext BC, List<sObject> scope){    
     Map<Id, List<jj_rb_Rebate_Claim__c>> mapCustClaims = new Map<Id,List<jj_rb_Rebate_Claim__c>>();   // key -> cust id
     Map<Id, List<jj_rb_Estimated_Rebate_Accrual__c>> mapEstimatedAccruals = new Map<Id, List<jj_rb_Estimated_Rebate_Accrual__c>> ();   // key -> cust id         
     system.debug('********** '+scope);
     Map<Id, jj_rb_Rebate_Accrual__c> mapRebateAccrual = new Map<Id, jj_rb_Rebate_Accrual__c>();    // key -> cust id
     Map<Id, List<jj_rb_Rebate_Accrual_Line_Item__c>> mapRebateAccrualLI = new Map<Id, List<jj_rb_Rebate_Accrual_Line_Item__c>>();  // key -> cust Id
     Set<Id> setCustomerId = new Set<Id>(); 
     List<Account> listAccount = new List<Account>();     
    
     String Account_HCP = jj_rb_Rebate_utils.getRecordTypeId('Account_Homecare');
     String Accrual_HCP = jj_rb_Rebate_utils.getRecordTypeId('Accrual_Homecare');
     String HCPType = jj_rb_Rebate_utils.getAccountType('Home Care Provider');
     id Homecare_claim = jj_rb_Rebate_utils.getRecordTypeId('Claim_Homecare');
     // create a set of customer Id
     for(Account acc : (List<Account>) scope)
     {
         if(acc.Account_Type__c == HCPType )
         {
            setCustomerId.add(acc.id);
            listAccount.add(acc);
         }
     }
     
    /* List<Account> listAccount = [select Id,Name, jj_rb_National_Channel_Manager__c,
                                         jj_rb_SAP_Customer_Number__c, jj_rb_SAP_Vendor_Number__c 
                                        from Account where id in :setCustomerId];
     
     */
     // get the estimated rebate accrual values for the customer
     for(jj_rb_Estimated_Rebate_Accrual__c estimatedAccruals : [select Id, Name,jj_rb_Estimated_Accrual__c,
                                                                    jj_rb_Rebate_Product__c, jj_rb_Account__c
                                                                    from jj_rb_Estimated_Rebate_Accrual__c
                                                                    where jj_rb_Account__c in :setCustomerId])
     {    
        List<jj_rb_Estimated_Rebate_Accrual__c> listEstimatedAccruals = new List<jj_rb_Estimated_Rebate_Accrual__c>();
        if (mapEstimatedAccruals.containsKey(estimatedAccruals.jj_rb_Account__c))
        {
            listEstimatedAccruals = mapEstimatedAccruals.get(estimatedAccruals.jj_rb_Account__c);
        } 
        listEstimatedAccruals.add(estimatedAccruals);
        mapEstimatedAccruals.put(estimatedAccruals.jj_rb_Account__c, listEstimatedAccruals);
     }
     system.debug('mapEstimatedAccruals>>>>' + mapEstimatedAccruals);  
     
     // loop over claims and create a map with last 3 claims of the customer "super class"
     for(jj_rb_Rebate_Claim__c claim : [SELECT Id, Name, jj_rb_Claim_Date__c, jj_rb_Customer__c, 
                                                (select id, name, jj_rb_Rebate_Product__c, jj_rb_Quantity__c,
                                                        jj_rb_Net_Rebate__c from Rebate_Claim_Line_Items__r) 
                                                 FROM jj_rb_Rebate_Claim__c 
                                                 where jj_rb_Claim_Date__c = LAST_N_DAYS:730 
                                                       and recordtypeid =: Homecare_claim  
                                                       and jj_rb_Status__c = 'Approved'
                                                       and jj_rb_Claim_Date__c < THIS_MONTH
                                                       order by jj_rb_Claim_Date__c desc])
     {
        String customerId = claim.jj_rb_Customer__c;
        if(mapCustClaims.containsKey(customerId))
        {
            List<jj_rb_Rebate_Claim__c> listClaims = mapCustClaims.get(customerId);
            if(listClaims != null && listClaims.size() <=2)
            {
                listClaims.add(claim);
                mapCustClaims.put(customerId, listClaims);
            }
        } else {
            List<jj_rb_Rebate_Claim__c> listClaims = new List<jj_rb_Rebate_Claim__c>{claim};
            mapCustClaims.put(customerId, listClaims);
        }
     }                                                             
     
     // loop over each customer 
     for(Account customer : listAccount) 
     {
        String customerId = customer.Id;
        system.debug('customer - ' + customer.Name + ' with customer Id - ' + customerId);
        
        List<jj_rb_Rebate_Claim__c> listClaims = mapCustClaims.get(customerId);        
        if(listClaims != null && !listClaims.isEmpty())
        {           
            system.debug('claim  found for this customer>>>>>'  + listClaims);
            calcAccrualForExistingCustomer(customer, listClaims, mapRebateAccrual, mapRebateAccrualLI,Accrual_HCP);
        }
        else
        {
            system.debug('No claim line items for this customer>>>>>');
            processAccrualForNewCustomer(customer, mapEstimatedAccruals, mapRebateAccrual, mapRebateAccrualLI,Accrual_HCP); 
        }       
        
     } 
     
     // create the rebate accrual and rebate accrual Line Item record
     createAccruals(mapRebateAccrual, mapRebateAccrualLI);    
 }
 global void finish(Database.BatchableContext BC){   
       
 }
}