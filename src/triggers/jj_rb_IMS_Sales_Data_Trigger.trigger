trigger jj_rb_IMS_Sales_Data_Trigger on jj_rb_IMS_Sales_Data__c (before insert, before update) {
    
    if(Trigger.isBefore) {
        Map<String, jj_rb_IMS_Sales_Data__c> mapIMSData = new Map<String, jj_rb_IMS_Sales_Data__c>();        
        Set<String> setIMSCustomerNo = new Set<String>();
        Set<String> setIMSProductNo = new Set<String>();      
        
        for(jj_rb_IMS_Sales_Data__c ims : Trigger.new)
        {
            setIMSCustomerNo.add(ims.jj_rb_IMS_Customer_Number__c);
            setIMSProductNo.add(ims.jj_rb_IMS_Product_Number__c); 
        }
        
        system.debug('setCustomerSAPNo>>>' + setIMSCustomerNo);
        system.debug('setSAPMaterialCode>>>>' + setIMSProductNo);           
        
        Map<String, Account> mapAccounts = new Map<String, Account>();
        for(Account a : [select Id, jj_rb_IMS_Customer_Id__c
                            from Account where jj_rb_IMS_Customer_Id__c in : setIMSCustomerNo])
        {
            mapAccounts.put(a.jj_rb_IMS_Customer_Id__c, a);         
        } 
        
        system.debug('mapAccounts>>>>' +mapAccounts);                  
                                                                
        Map<String, jj_rb_Rebate_Product__c> mapProducts = new Map<String, jj_rb_Rebate_Product__c>();
        for(jj_rb_Rebate_Product__c product : [ select Id, jj_rb_IMS_Product_ID__c,jj_rb_Description__c
                                                    from jj_rb_Rebate_Product__c
                                                    where jj_rb_IMS_Product_ID__c in :setIMSProductNo])
        {
            mapProducts.put(product.jj_rb_IMS_Product_ID__c, product);
        } 
        
        system.debug('mapProducts>>>>' + mapProducts);                                                                          
                                                                                    
        for(jj_rb_IMS_Sales_Data__c ims : trigger.new)
        {
            Account a = mapAccounts.get(ims.jj_rb_IMS_Customer_Number__c);
            jj_rb_Rebate_Product__c product = mapProducts.get(ims.jj_rb_IMS_Product_Number__c);
            
            // fix the formatting for the month            
            if(String.isNotBlank(ims.jj_rb_IMS_Data_Month__c) 
                                && ims.jj_rb_IMS_Data_Month__c.length()  == 1) 
                ims.jj_rb_IMS_Data_Month__c = '0' + ims.jj_rb_IMS_Data_Month__c;
                        
            if(a != null) {
                ims.jj_rb_Customer__c = a.Id;
                
            } else  {
                ims.addError('Customer with IMS Customer Number - ' + ims.jj_rb_IMS_Customer_Number__c+ ' not found.');
                
            }           
            
            if(product != null) {
                ims.jj_rb_Product__c = product.id;
                ims.jj_rb_IMS_Product_Info__c = product.jj_rb_Description__c;
            } else {
            ims.addError('Rebate Product with IMS Product Number - ' + ims.jj_rb_IMS_Product_Number__c+ ' not found.');
                
            }         
        }                                                                                                                                               
    }
}