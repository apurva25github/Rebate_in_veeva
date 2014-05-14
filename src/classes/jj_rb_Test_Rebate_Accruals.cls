/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  5/05/2014
      @description  Test class for the Rebate accruals
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------     
     Sarabdeep Ahluwalia    5/05/2014       Original
 */
@isTest
private class jj_rb_Test_Rebate_Accruals {
    static testMethod void testAccrualActionButtons()
    {       
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
            jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
            jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
            
            // fill the customset for recordtypes
            List<jj_rb_Master_Data_RecordTypes__c> listRecType = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
            insert listRecType;
            
            // create a product
            jj_rb_Rebate_Product__c product = jj_rb_Test_BaseClass.setupRebateProduct();
            insert product;
            
            // create a retailer first
            Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
            insert retailer;
            
            // create rebate accrual record
            jj_rb_Rebate_Accrual__c ra = jj_rb_Test_BaseClass.setupRetailerAccrual(retailer);
            ra.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            ra.jj_rb_Month__c = Datetime.now().format('MM');
            ra.jj_rb_Year__C = Datetime.now().format('YYYY');
            insert ra;
            
            // create line items
            jj_rb_Rebate_Accrual_Line_Item__c raCLI = jj_rb_Test_BaseClass.setupAccrualLineItem(ra, product);
            insert raCLI;
            
            jj_rb_Accrual_Actions.createBatchReport();
            
        }   
    }
    
    static testMethod void testRetailerAccrualForExistingCustomer()
    {
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
            jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
            jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
            
            // fill the customset for recordtypes
            List<jj_rb_Master_Data_RecordTypes__c> listCS = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();                                                                               
            insert listCS;
            
            // create a product
            jj_rb_Rebate_Product__c product = jj_rb_Test_BaseClass.setupRebateProduct();
            insert product;
            
            // create a retailer first
            Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
            insert retailer;
            
            // setup era
            jj_rb_Estimated_Rebate_Accrual__c era = jj_rb_Test_BaseClass.setupERA(retailer, product); 
            insert era;
            
            // create a retailer contract
            jj_rb_Rebate_Contract__c contract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);           
            insert contract;
            
            // create contract line items
            jj_rb_Rebate_Contract_Line_Item__c cli = jj_rb_Test_BaseClass.setupRetailerContractLineItem(contract, product);
            insert cli;
            
            // approve the contract
            contract.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update contract;
            
            // create a retailer claim
            jj_rb_Rebate_Claim__c claim = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
            insert claim;
            
            // create claim line item
            jj_rb_Rebate_Claim_Line_Item__c claimLI = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(claim, product);
            insert claimLI;
            
            // approve the claim
            claim.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update claim;           
            
            // run the retailer accrual batch process
            //jj_rb_RetailerAccrualCalc batch = new jj_rb_RetailerAccrualCalc();
            //batch.retailer_contract = jj_rb_Test_BaseClass.getRecordTypeId('Retailer Contract', 'jj_rb_Rebate_Contract__c');
            //database.executeBatch(batch);
            jj_rb_RebateAccrualCalcScheduler sched = new jj_rb_RebateAccrualCalcScheduler();
            sched.execute(null);        
            
        }
        
     
        
        
        Test.stopTest();    
    }
    
    static testMethod void testRetailerAccrualForNewCustomer()
    {
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
            jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
            jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
            
            // fill the customset for recordtypes
            List<jj_rb_Master_Data_RecordTypes__c> listRecType = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
            insert listRecType;
            
            // create a product
            jj_rb_Rebate_Product__c product = jj_rb_Test_BaseClass.setupRebateProduct();
            insert product;
            
            // create a retailer first
            Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
            insert retailer;
            
            // setup era
            jj_rb_Estimated_Rebate_Accrual__c era = jj_rb_Test_BaseClass.setupERA(retailer, product); 
            insert era;
            
            // create a retailer contract
            jj_rb_Rebate_Contract__c contract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);           
            insert contract;
            
            // create contract line items
            jj_rb_Rebate_Contract_Line_Item__c cli = jj_rb_Test_BaseClass.setupRetailerContractLineItem(contract, product);
            insert cli;
            
            // approve the contract
            contract.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update contract;            
            
            // run the retailer accrual batch process
            //jj_rb_RetailerAccrualCalc batch = new jj_rb_RetailerAccrualCalc();
            //batch.retailer_contract = jj_rb_Test_BaseClass.getRecordTypeId('Retailer Contract', 'jj_rb_Rebate_Contract__c');
            //database.executeBatch(batch);
            jj_rb_Accrual_Actions.executeCalcBatch();               
        }    
     
        Test.stopTest();    
    }
    
    static testMethod void testHomecareAccrualForExistingCustomer()
    {
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
        jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
        jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
          
        // fill the customset for recordtypes
        List<jj_rb_Master_Data_RecordTypes__c> listCS = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();                                            
        insert listCS;
          
        // create a product
        jj_rb_Rebate_Product__c product = jj_rb_Test_BaseClass.setupRebateProduct();
        insert product;
        
        //String hcpRecordtype = jj_rb_Test_BaseClass.getRecordTypeId('Homecare provider', 'Account');  
        //String recordtype=hcpRecordtype.substring(0,15);  
        
        // create a homecare account
        Account homecare= jj_rb_Test_BaseClass.setupHomecareCustomer(rebateUser);
        homecare.Account_Type__c=jj_rb_Test_BaseClass.accountTypeCreator('Home Care Provider','Homecare');
        homecare.jj_rb_IMS_Customer_Id__c='25698';            
        insert homecare;
                       
       
        List<account> alist=[SELECT Id,jj_rb_IMS_Customer_Id__c,Account_Type__c,jj_rb_National_Channel_Manager__c,jj_rb_SAP_Customer_Number__c,Name,RecordTypeId FROM Account];
        System.assertEquals(1,alist.size());        
        
        // setup region
        jj_rb_Region__c region = jj_rb_Test_BaseClass.setupRegion();
        insert region;
                       
        // set NHS Trust
        Account trust = jj_rb_Test_BaseClass.setupTrustCustomer(region);
        insert trust;
            
        // create hospital
        Account hospital = jj_rb_Test_BaseClass.setupHospital(trust, rebateUser);
        insert hospital;
          
        // setup era
        jj_rb_Estimated_Rebate_Accrual__c era = jj_rb_Test_BaseClass.setupERA(homecare, product); 
        insert era;          
          
          
        // create a homecare claim
        jj_rb_Rebate_Claim__c hcpclaim = jj_rb_Test_BaseClass.setupHCPClaim(homecare);       
        insert hcpclaim;          
          
        // create claim line item
        jj_rb_Rebate_Claim_Line_Item__c claimLI = jj_rb_Test_BaseClass.setupHCPClaimLineItems(hcpclaim, product,hospital);
        insert claimLI;
          
        // approve the claim
        hcpclaim.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
        //hcpclaim.jj_rb_Customer__c=homecare.id;
        update hcpclaim;  
        
                
        jj_rb_HCPAccrualcalc batch= new jj_rb_HCPAccrualcalc();               
        Database.executeBatch(batch);
        batch.execute(null,alist);
                
        //Scheduler
        jj_rb_RebateAccrualCalcScheduler sched = new jj_rb_RebateAccrualCalcScheduler();
        sched.execute(null);                  
          
        }
        Test.stopTest();  
    }
    
    static testMethod void testHomecareAccrualForNewCustomer()
    {
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
        jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
        jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
          
        // fill the customset for recordtypes
        List<jj_rb_Master_Data_RecordTypes__c> listRecType = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
        insert listRecType;
          
        // create a product
        jj_rb_Rebate_Product__c product = jj_rb_Test_BaseClass.setupRebateProduct();
        insert product;      
        
         
        
        // create a homecare account
        Account homecares= jj_rb_Test_BaseClass.setupHomecareCustomer(rebateUser);
        homecares.Account_Type__c=jj_rb_Test_BaseClass.accountTypeCreator('Home Care Provider','Homecare');
        homecares.jj_rb_IMS_Customer_Id__c='25698';
       
        insert homecares;        
        
        List<account> alist=[SELECT Id,jj_rb_IMS_Customer_Id__c,Account_Type__c,jj_rb_National_Channel_Manager__c,jj_rb_SAP_Customer_Number__c,Name,RecordTypeId FROM Account];
        System.assertEquals(1,alist.size()); 
        
        // setup region
        jj_rb_Region__c region = jj_rb_Test_BaseClass.setupRegion();
        insert region;
                       
        // set NHS Trust
        Account trust = jj_rb_Test_BaseClass.setupTrustCustomer(region);
        insert trust;
            
        // create hospital
        Account hospital = jj_rb_Test_BaseClass.setupHospital(trust, rebateUser);
        insert hospital;
          
        // setup era
        jj_rb_Estimated_Rebate_Accrual__c era = jj_rb_Test_BaseClass.setupERA(homecares, product); 
        insert era;
          
        jj_rb_Accrual_Actions.executeCalcBatch();             
        }
        Test.stopTest();  
    }
    
    

}