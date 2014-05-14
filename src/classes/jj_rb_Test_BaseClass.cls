public class jj_rb_Test_BaseClass {
    public static String  STATUS_APPROVED = 'Approved';
    public static String STATUS_NEW = 'New';
    public static String STATUS_SUBMITTED = 'Submitted';
    public static String STATUS_REJECTED = 'Rejected';
    
    public static Account setupHomecareCustomer(User ncmUser)
    {
        Id hcpRecordtype = getRecordTypeId('Homecare provider', 'Account');        
       
        Account a = new Account();
        a.jj_rb_National_Channel_Manager__c = ncmUser.Id;
        a.jj_rb_SAP_Customer_Number__c = '221';
        a.jj_rb_SAP_Vendor_Number__c = '221';
        a.RecordTypeId =hcpRecordtype; 
        a.Name = 'test Account';    
        
        return a;
        
    }
    
     public static Account setupTrustCustomer(jj_rb_Region__c region)
    {
    	Id hcpRecordtype = jj_rb_Test_BaseClass.getRecordTypeId('Hospital_vod', 'Account');
    	Account a = new Account();
    	a.Name = 'Test Trust';
    	a.Account_Type__c = 'Acute Trust';
    	a.jj_rb_Region__c = region.Id;    	
    	a.RecordTypeId = hcpRecordtype;
    	return a;    
    }
    
    
    
    public static jj_rb_Rebate_Contract__c setupRetailerContract(Account retailer, User ncmUser)
    {
        // get the retailer contract recordtype
        Id retailerContractRecordTypeId = jj_rb_Test_BaseClass.getRecordTypeId('Retailer Contract', 'jj_rb_Rebate_Contract__c');
        
        // create a new retailer contract
        jj_rb_Rebate_Contract__c retailerContract = new jj_rb_Rebate_Contract__c();
        retailerContract.jj_rb_National_Channel_Manager__c = ncmUser.Id;
        retailerContract.jj_rb_Customer__c = retailer.Id;
        retailerContract.RecordTypeId = retailerContractRecordTypeId;
        retailerContract.jj_rb_Status__c = STATUS_NEW;      
        return retailerContract;
    }   
   
    
    public static jj_rb_Rebate_Contract__c setupHomecareContract(jj_rb_Rebate_Product__c product, User ncmUser)
    {
        // get the retailer contract recordtype
        Id hcpContractRecordTypeId = jj_rb_Test_BaseClass.getRecordTypeId('Homecare Contract', 'jj_rb_Rebate_Contract__c');
        
        // create a new retailer contract
        jj_rb_Rebate_Contract__c hcpContract = new jj_rb_Rebate_Contract__c();
        hcpContract.jj_rb_National_Channel_Manager__c = ncmUser.Id;
        hcpContract.jj_rb_Product__c = product.id;
        hcpContract.RecordTypeId = hcpContractRecordTypeId;         
        return hcpContract;
    }
    
    public static jj_rb_Rebate_Contract_Line_Item__c setupRetailerContractLineItem(jj_rb_Rebate_Contract__c retailerContract, jj_rb_Rebate_Product__c rebateProduct)
    {
        // get the retailer contract line item
        Id retailerContractLineItemRecordtype = jj_rb_Test_BaseClass.getRecordTypeId('Retailer Contract', 'jj_rb_Rebate_Contract_Line_Item__c');
        
        // setup the rebate product
        //jj_rb_Rebate_Product__c rebateProduct = setupRebateProduct();
        
        jj_rb_Rebate_Contract_Line_Item__c cli = new jj_rb_Rebate_Contract_Line_Item__c();
        cli.jj_rb_Rebate_Contract__c = retailerContract.id;
        cli.jj_rb_Start_Date__c = date.today() - 200;
        cli.jj_rb_End_Date__c = cli.jj_rb_Start_Date__c.addDays(365);
        cli.jj_rb_Product__c = rebateProduct.id;
        cli.jj_rb_Rebate__c = 2.5;    
        cli.jj_rb_Status__c = STATUS_NEW;   
        cli.RecordTypeId = retailerContractLineItemRecordtype;
        return cli;
    }
    
    
    public static jj_rb_Rebate_Contract_Line_Item__c setupHomecareContractLineItem(jj_rb_Rebate_Contract__c hcpContract, jj_rb_Region__c region)
    {
        // get the retailer contract line item
        Id hcpContractLineItemRecordtype = jj_rb_Test_BaseClass.getRecordTypeId('Homecare Contract', 'jj_rb_Rebate_Contract_Line_Item__c');
    
        jj_rb_Rebate_Contract_Line_Item__c cli = new jj_rb_Rebate_Contract_Line_Item__c();
        cli.jj_rb_Rebate_Contract__c = hcpContract.id;
        cli.jj_rb_Start_Date__c = date.newInstance(2014, 1, 1);
        cli.jj_rb_End_Date__c = cli.jj_rb_Start_Date__c.addDays(365);
        cli.jj_rb_Region__c = region.id;
        cli.jj_rb_List_Price__c = 20;
        cli.jj_rb_Contract_Price__c = 18;   
        cli.RecordTypeId =  hcpContractLineItemRecordtype;   
        return cli;
    }    
        
    
    public static jj_rb_Rebate_Claim__c setupRetailerClaim(Account customer)
    {
        // get the retailer claim recordtype
        Id retailerClaimRecordTypeId = jj_rb_Test_BaseClass.getRecordTypeId('Retailer Rebate Claim', 'jj_rb_Rebate_Claim__c');
        return setupClaim(customer, retailerClaimRecordTypeId);     
    }
    
    public static jj_rb_Rebate_Claim__c setupHCPClaim(Account customer)
    {
        // get the hcp claim recordtype
        Id hcpClaimRecordTypeId = getRecordTypeId('Homecare Claim', 'jj_rb_Rebate_Claim__c');
        return  setupClaim(customer, hcpClaimRecordTypeId);   
    }
    
    public static jj_rb_Rebate_Claim__c setupClaim(Account customer, Id recordTypeId)
    {
        jj_rb_Rebate_Claim__c retailerClaim = new jj_rb_Rebate_Claim__c();
        retailerClaim.jj_rb_Customer__c = customer.Id;
        retailerClaim.jj_rb_Month__c = '01';
        retailerClaim.jj_rb_Year__c = '2014';
        retailerClaim.jj_rb_Status__c = STATUS_NEW;
        retailerClaim.RecordTypeId = recordTypeId;
        return retailerClaim;
    }
    
    
    public static jj_rb_Rebate_Claim_Line_Item__c setupRetailerClaimLineItems(jj_rb_Rebate_Claim__c retailerClaim, jj_rb_Rebate_Product__c product)
    {
        // get the retailer claim line item recordtype
        Id retailerCLaimLineItemRecordTypeId = getRecordTypeId('Retailer Rebate Claim', 'jj_rb_Rebate_Claim_Line_Item__c');
        
        return setupClaimLineItem(retailerClaim, product, retailerCLaimLineItemRecordTypeId);       
    }
    
    public static jj_rb_Rebate_Claim_Line_Item__c setupHCPClaimLineItems(jj_rb_Rebate_Claim__c hcpClaim, jj_rb_Rebate_Product__c product, Account hospital)
    {
        // get the retailer claim line item recordtype
        Id recordTypeId = getRecordTypeId('Homecare Claim', 'jj_rb_Rebate_Claim_Line_Item__c');             
        
        jj_rb_Rebate_Claim_Line_Item__c cli = new jj_rb_Rebate_Claim_Line_Item__c();
        cli.jj_rb_Rebate_Product__c = product.Id;
        cli.jj_rb_Hospital__c = hospital.id;
        cli.jj_rb_Rebate_Per_Unit__c = 2; 
        cli.jj_rb_Unit_List_Price__c = 100;
        cli.jj_rb_Unit_Contract_Price__c = 98;
        cli.jj_rb_Quantity__c = 1000;
        cli.jj_rb_VAT_Code__c = product.jj_rb_VAT_Code__c;
        cli.recordTypeId = recordTypeId;
        cli.jj_rb_Rebate_Claim__c = hcpClaim.Id;
        return cli;     
                
    }
    
    public static jj_rb_Rebate_Claim_Line_Item__c setupClaimLineItem(jj_rb_Rebate_Claim__c claim, jj_rb_Rebate_Product__c product, Id recordTypeId )
    {
        jj_rb_Rebate_Claim_Line_Item__c cli = new jj_rb_Rebate_Claim_Line_Item__c();
        cli.jj_rb_Rebate_Product__c = product.Id;
        cli.jj_rb_Rebate_Per_Unit__c = 2; 
        cli.jj_rb_Quantity__c = 1000;
        cli.jj_rb_VAT_Code__c = product.jj_rb_VAT_Code__c;
        cli.recordTypeId = recordTypeId;
        cli.jj_rb_Rebate_Claim__c = claim.Id;
        return cli;
    }
    
    public static jj_rb_Tolerance__c setupTolerance(Account hcpCustomer, jj_rb_Rebate_Product__c product)
    {
        jj_rb_Tolerance__c tol = new jj_rb_Tolerance__c();      
        tol.jj_rb_Customer__c = hcpCustomer.id;
        tol.jj_rb_Product__c = product.Id;
        tol.jj_rb_Quantity_Tolerance__c  =10;
                
        return tol;
    }
    
    public static jj_rb_Estimated_Rebate_Accrual__c setupERA(Account a, jj_rb_Rebate_Product__c p)
    {
        jj_rb_Estimated_Rebate_Accrual__c era = new jj_rb_Estimated_Rebate_Accrual__c();
        era.jj_rb_Account__c = a.id;
        era.jj_rb_Rebate_Product__c = p.id;
        era.jj_rb_Estimated_Accrual__c = 1000;
        
        return era;
    }
    
    public static Account setupRetailerCustomer(User ncmUser)
    {
        Id retailerRecordType = getRecordTypeId('Retailer','Account');
        Account a = new Account();
        a.jj_rb_National_Channel_Manager__c = ncmUser.Id;
        a.jj_rb_SAP_Customer_Number__c = '221';
        a.jj_rb_SAP_Vendor_Number__c = '221';
        a.jj_rb_IMS_Customer_Id__c = '221';
        a.RecordTypeId = retailerRecordType; 
        a.Name = 'test Account';        
        
        return a;
    }
    
     //Returns the recordTypeId for the specified record type name
    public static jj_rb_Master_Data_RecordTypes__c setupRecordTypeCustomSetting(String recordTypeName,string RecortypID)
    {
        jj_rb_Master_Data_RecordTypes__c recordType = new jj_rb_Master_Data_RecordTypes__c();
        recordType.name = recordTypeName;
        recordType.jj_rb_RecordTypeId__c = RecortypID;        
        return recordType;     
    }
    
    
    public static jj_rb_Rebate_Product__c setupRebateProduct()
    {
        jj_rb_VAT_Code__c vatCode = setupVATCode();
        
        jj_rb_Rebate_Product__c product = new jj_rb_Rebate_Product__c();
        product.jj_rb_SAP_EAN_Code__c = '376769';
        product.jj_rb_SAP_Material_Number__c = '376769';
        product.Name = 'Test Product';
        product.jj_rb_Description__c = 'Product description';
        product.jj_rb_VAT_Code__c = vatCode.id;
        product.jj_rb_IMS_Product_ID__c = '12345';      
        
        return product;
    }
    
    public static Account setupHospital(Account trust, User ncmUser)
    {
        Id hospitalRecordtype = getRecordTypeId('Hospital_vod', 'Account');
        Account a = new Account();
        a.Primary_Parent_vod__c = trust.Id;
        a.CODS_External_Id__c = '12345';
        a.RecordTypeId = hospitalRecordtype;
        a.name = 'Test Hospital';
        
        
        if(ncmUser != null)
            a.jj_rb_National_Channel_Manager__c = ncmUser.Id;
   
        
        return a;
        
    }
    
    public static jj_rb_VAT_Code__c setupVATCode()
    {
        jj_rb_VAT_Code__c vat = new jj_rb_VAT_Code__c();
        vat.jj_rb_VAT__c = 20;
        vat.jj_rb_VAT_External_Id__c = '20';
        vat.Name = 'test vat';
        
        insert vat;
        return vat;
    }  
    
    // create a test region
    public static jj_rb_Region__c setupRegion()
    {
        jj_rb_Region__c r = new jj_rb_Region__c();
        r.jj_rb_Description__c = 'test region';
        r.Name = 'TestRegion';      
        return r;
    }
    
    // setup buying groups
    public static jj_rb_Retailer_Buying_Group__c setupBuyingGroup(Account retailer)
    {
        jj_rb_Retailer_Buying_Group__c buyingGroup = new jj_rb_Retailer_Buying_Group__c();
        buyingGroup.jj_rb_Customer__c = retailer.Id;        
        return buyingGroup;
    }
    
    public static jj_rb_Retailer_Buying_Group_Member__c setupBuyingGroupMembers(jj_rb_Retailer_Buying_Group__c buyingGroup, Account retailer)
    {
        jj_rb_Retailer_Buying_Group_Member__c buyingGroupMember = new jj_rb_Retailer_Buying_Group_Member__c();
        buyingGroupMember.jj_rb_Lead_Retailers__c = buyingGroup.Id;
        buyingGroupMember.jj_rb_Customer__c = retailer.Id;
        
        return buyingGroupMember;
    }
    
    
    public static Id getRecordTypeId(String recordTypeName, String objectName)
    {
        List<RecordType> r = [select Id from RecordType 
                                    where name = :recordTypeName 
                                    and SobjectType = :objectName limit 1];
        if(!r.isEmpty())
            return r[0].Id;
        return null;    
    }
    
    public static User setupRebateNCMUser(User u)
    {
        // get rebate analyst permission set
        List<PermissionSet> permissionSetNCM = [select Id from PermissionSet where name = 'jj_rb_UK_Rebate_NCM' limit 1];
                
        if(!permissionSetNCM.isEmpty())
        {
            //return getUser(permissionSetNCM[0].Id);
            PermissionSetAssignment pa = new PermissionSetAssignment();
            pa.AssigneeId = u.Id;
            pa.PermissionSetId =  permissionSetNCM[0].Id;   
            insert pa;                                              
        }
        return null;    
    }
    
    public static User getUser(String permissionSetId)
    {
        if(String.isNotBlank(permissionSetId))
        {
            List<User> listUser = [select Id from User 
                                    where isActive = true 
                                    and id in (SELECT AssigneeId 
                                                    FROM PermissionSetAssignment where PermissionSetId = :permissionSetId) limit 1];            
            
            
            if(!listUser.isEmpty())
                return listUser[0]; 
        }
        return null;
    }
    
    public static User setupRebateAnalystUser(User u)
    {
        // get rebate analyst permission set
        List<PermissionSet> permissionSetAnalyst = [select Id from PermissionSet where name = 'jj_rb_UK_Rebate_Analyst' limit 1];
        if(!permissionSetAnalyst.isEmpty())
        {
            //return getUser(permissionSetAnalyst[0].Id);           
            PermissionSetAssignment pa = new PermissionSetAssignment();
            pa.AssigneeId = u.Id;
            pa.PermissionSetId =  permissionSetAnalyst[0].Id;   
            insert pa;                                                          
        }
        return null;
    }
    
    public Static User setupUser()
    {
        Profile prof = [select id from profile where name = 'System Administrator'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');
        insert u;
        return u;
    }
    
    public static void setupCustomSettings()
    {
        // set the custom setting  for permission set
        List<jj_rb_Rebate_Permission_Set__c> listPermissionSetCustomSetting = new List<jj_rb_Rebate_Permission_Set__c>();
        List<PermissionSet> listPermissionSet = [select Id, name  from PermissionSet where name like 'jj_rb_UK_Rebate_%'];
        for(PermissionSet pm : listPermissionSet) {
            jj_rb_Rebate_Permission_Set__c rps = new jj_rb_Rebate_Permission_Set__c();
            rps.name = pm.name;
            rps.jj_rb_Permission_Set_Id__c = pm.id;
            listPermissionSetCustomSetting.add(rps);
        }
        if(!listPermissionSetCustomSetting.isEmpty())
            insert listPermissionSetCustomSetting;
        
    }
    
    public static jj_rb_Rebate_Contract_Line_Item_Status__c setupCustomSettingForStatus(String name,String Status)
    {
            jj_rb_Rebate_Contract_Line_Item_Status__c statusCustomsetting = new jj_rb_Rebate_Contract_Line_Item_Status__c();
            statusCustomsetting.name = name;
            statusCustomsetting.jj_rb_Rebate_Line_Item_Status__c = Status;            
            return statusCustomsetting;
    }
    
     //Account type
     public static  String accountTypeCreator(String name,String Acc_type)
        {
            jj_rb_account_type__c accType= new jj_rb_account_type__c();
            accType.name=name;
            accType.jj_rb_Account_Type__c=Acc_type;
            insert accType;
            return accType.jj_rb_Account_Type__c;        
        }
    
    public static List<jj_rb_Master_Data_RecordTypes__c>  createRecordTypeCustomSetting() 
    {
            List<jj_rb_Master_Data_RecordTypes__c> listCS2 = new List<jj_rb_Master_Data_RecordTypes__c>();
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Contract_LineItem_Retailer',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer Contract', 'jj_rb_Rebate_Contract_Line_Item__c')));
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Retailer_Closed_Contract_Line_Item',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer Closed Contract', 'jj_rb_Rebate_Contract_Line_Item__c')));
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Homecare_Contract_Line_Item',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Contract', 'jj_rb_Rebate_Contract_Line_Item__c')));                                                          
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Homecare_Closed_Contract_Lineitem',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Closed Contract', 'jj_rb_Rebate_Contract_Line_Item__c')));                                                           
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Rebate_Contract_Retailer',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer Contract', 'jj_rb_Rebate_Contract__c')));                                                            
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Retailer_Closed_Contract',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer Closed Contract', 'jj_rb_Rebate_Contract__c')));                                                         
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Homecare_Contract',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Contract', 'jj_rb_Rebate_Contract__c')));                                                            
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Homecare_Closed_Contract',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Closed Contract', 'jj_rb_Rebate_Contract__c')));         
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Rebate_Claim_Retailer',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer Rebate Claim', 'jj_rb_Rebate_Claim__c')));                                                           
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Accrual_Retailer',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer Accrual', 'jj_rb_Rebate_Accrual__c')));
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Accrual_Homecare',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Accrual', 'jj_rb_Rebate_Accrual__c')));
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Accrual_Report_Retailer',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer report', 'jj_rb_Rebate_Accrual_Report__c')));                                                                        
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Accrual_Report_Homecare',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Report', 'jj_rb_Rebate_Accrual_Report__c')));
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Claim_Homecare',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Claim', 'jj_rb_Rebate_Claim__c')));
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Claim_LineItem_Homecare',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Homecare Claim', 'jj_rb_Rebate_Claim_Line_Item__c'))); 
            listCS2.add(jj_rb_Test_BaseClass.setupRecordTypeCustomSetting('Claim_LineItem_Retailer',
                                                                        jj_rb_Test_BaseClass.getRecordTypeId('Retailer Rebate Claim', 'jj_rb_Rebate_Claim_Line_Item__c')));                                                                                                                                                                                                 
                                                                                                                                                
            return listCS2;  
    }
    
    public static jj_rb_Rebate_Accrual__c setupRetailerAccrual(Account retailer)
    {       
        String recordTypeId = getRecordTypeId('Retailer Accrual', 'jj_rb_Rebate_Accrual__c');
        return setupAccrual(retailer, recordTypeId);
    }
    
    private static jj_rb_Rebate_Accrual__c setupAccrual(Account a, Id recordTypeId)
    {
        jj_rb_Rebate_Accrual__c rebateAccrual = new jj_rb_Rebate_Accrual__c();
        rebateAccrual.jj_rb_Customer__c = a.id;
        rebateAccrual.jj_rb_Month__c = '05';
        rebateAccrual.jj_rb_Year__c = '2014';
        rebateAccrual.jj_rb_Status__c = STATUS_NEW;
        rebateAccrual.recordtypeId = recordTypeId;
        return rebateAccrual; 
    }
    
    public static jj_rb_Rebate_Accrual_Line_Item__c setupAccrualLineItem(jj_rb_Rebate_Accrual__c rebateAccrual, jj_rb_Rebate_Product__c product)
    {
        jj_rb_Rebate_Accrual_Line_Item__c raCLI = new jj_rb_Rebate_Accrual_Line_Item__c();
        raCLI.jj_rb_Rebate_Accrual__c = rebateAccrual.Id;
        racLI.jj_rb_Product__c = product.id;
        racLI.jj_rb_Net_Rebate_Accrual_Amount__c = 1000;
        return racLI;
    }
    public static jj_rb_IMS_Sales_Data__c setupImsSalesData(Account retailer,jj_rb_Rebate_Product__c rebateProduct)
    {
        jj_rb_IMS_Sales_Data__c imsdata= new jj_rb_IMS_Sales_Data__c();
        imsdata.jj_rb_IMS_Data_Month__c='02';
        imsdata.jj_rb_IMS_Data_Year__c='2014';
        imsdata.jj_rb_IMS_Volume__c=200;
        imsdata.jj_rb_IMS_Product_Number__c = rebateProduct.jj_rb_IMS_Product_ID__c;
        imsdata.jj_rb_IMS_Customer_Number__c = retailer.jj_rb_IMS_Customer_Id__c;
        return imsdata;
    
    }
    

}