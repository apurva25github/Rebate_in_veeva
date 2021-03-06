/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  5/05/2014
      @description  Test class for the Rebate Claims
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------     
     Sarabdeep Ahluwalia    5/05/2014       Original
 */
@isTest
private class jj_rb_Test_RebateClaims {
    
    // test creation of retailer claims
    static testmethod void createRetailerClaims()
    {
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
            jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
            
            // setup custom settings
            List<jj_rb_Master_Data_RecordTypes__c> listCS =  jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
            insert listCS; 
            
            // setup a retailer account
            Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
            retailer.jj_rb_IMS_Customer_Id__c='78961';
            insert retailer;
            
            // setup rebate product
            jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
            rebateProduct.jj_rb_IMS_Product_ID__c='12345';
            insert rebateProduct;
            
            // setup retailer contract
            jj_rb_Rebate_Contract__c contract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);
            insert contract;
            
            // setup cpntract line items
            jj_rb_Rebate_Contract_Line_Item__c conLI = jj_rb_Test_BaseClass.setupRetailerContractLineItem(contract, rebateProduct);
            insert conLI;
            
            // update the contract status
            contract.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            conLI.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update contract;
            update conLI;
            
            // setup ims sales data
            jj_rb_IMS_Sales_Data__c imsdata = jj_rb_Test_BaseClass.setupImsSalesData(retailer, rebateProduct);
            imsdata.jj_rb_IMS_Data_Month__c='04';
        	imsdata.jj_rb_IMS_Data_Year__c='2014';
        	insert imsdata;
        	
        	//create tolerance record
            jj_rb_Tolerance__c tol=jj_rb_Test_BaseClass.setupTolerance(retailer,rebateProduct);
            insert tol;        	
        	
            
            // create a retailer claim
            jj_rb_Rebate_Claim__c retailerClaim1 = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
            retailerClaim1.jj_rb_month__c = '04';
            retailerClaim1.jj_rb_Year__c = '2014';
            insert retailerClaim1;
            
            // create retailer line items
            jj_rb_Rebate_Claim_Line_Item__c cli1 = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(retailerClaim1, rebateProduct);
            insert cli1;
            
            // create second claim with same month and year
            jj_rb_Rebate_Claim__c retailerClaim2 = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
            retailerClaim2.jj_rb_month__c = '04';
            retailerClaim2.jj_rb_Year__c = '2014';
            try { insert retailerClaim2;   } catch(Exception e) { }   
            
            // create retailer line items
            jj_rb_Rebate_Claim_Line_Item__c cli2 = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(retailerClaim2, rebateProduct);
            //jj_rb_RebateClaimLineItemTriggerHandler.alreadyFired = false;
            try { insert cli2;  } catch(Exception e) { }       
            
            // approve the claim
            retailerClaim1.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update retailerClaim1;             
            
            // Modification done by divya
            jj_rb_Retailer_Buying_Group__c retailerbuyinggroup=jj_rb_Test_BaseClass.setupBuyingGroup(retailer);
            insert retailerbuyinggroup;
            
            //jj_rb_Retailer_Buying_Group_Member__c  RBGroupMember=jj_rb_Test_BaseClass.setupBuyingGroupMembers(retailerbuyinggroup,retailer);
            //insert RBGroupMember;             
        }
        test.stopTest();
    }
    
    static testmethod void createHCPClaim()
    {
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
            jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
            
            // setup custom settings
            List<jj_rb_Master_Data_RecordTypes__c> listCS =  jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
            insert listCS; 
            
            // setup a retailer account
            Account customer = jj_rb_Test_BaseClass.setupHomecareCustomer(rebateUser);
            insert customer;
            
            // setup rebate product
            jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
            insert rebateProduct;
            
            // setup region
            jj_rb_Region__c region = jj_rb_Test_BaseClass.setupRegion();
            insert region;
            
            // set NHS Trust
            Account trust = jj_rb_Test_BaseClass.setupTrustCustomer(region);
            insert trust;
            
            // create hospital
            Account hospital = jj_rb_Test_BaseClass.setupHospital(trust, rebateUser);
            insert hospital;
            
            // setup homecare contract
            jj_rb_Rebate_Contract__c hcpContract = jj_rb_Test_BaseClass.setupHomecareContract(rebateProduct, rebateUser);
            insert hcpContract;
                        
            // setup contract line items
            jj_rb_Rebate_Contract_Line_Item__c cli = jj_rb_Test_BaseClass.setupHomecareContractLineItem(hcpContract, region);
            insert cli;         
            
            // approve the contract
            hcpContract.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update hcpContract;
            cli.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update cli;
            
            system.debug('cli>>>' + cli);
            for(jj_rb_Rebate_Contract_Line_Item__c c : [select Id, recordtypeId from jj_rb_Rebate_Contract_Line_Item__c])
            {
            	system.debug('recordtype id >>>' + c.recordTypeId);
            }
                      
            // create a hcp claim
            jj_rb_Rebate_Claim__c hcpClaim = jj_rb_Test_BaseClass.setupHCPClaim(customer);
            hcpClaim.jj_rb_Month__c = '02';
            hcpClaim.jj_rb_Year__c = '2014';
            insert hcpClaim;            
            
            // create claim line items
            jj_rb_Rebate_Claim_Line_Item__c claimCLI = jj_rb_Test_BaseClass.setupHCPClaimLineItems(hcpClaim, rebateProduct, hospital);
            insert claimCLI;  
            
            // create a hcp claim 2
            jj_rb_Rebate_Claim__c hcpClaim2 = jj_rb_Test_BaseClass.setupHCPClaim(customer);
            hcpClaim2.jj_rb_Month__c = '02';
            hcpClaim2.jj_rb_Year__c = '2014';
            try { insert hcpClaim2; } catch(Exception ex) {}
            
            // create claim line items
            jj_rb_Rebate_Claim_Line_Item__c claimCLI2 = jj_rb_Test_BaseClass.setupHCPClaimLineItems(hcpClaim2, rebateProduct, hospital);
            try {insert claimCLI2; } catch(Exception ex) {}   
                      
            // create hcp claim 3
            jj_rb_Rebate_Claim__c hcpClaim3 = jj_rb_Test_BaseClass.setupHCPClaim(customer);
            try{insert hcpClaim3;} catch(Exception ex){}
            
            //create claim lineitems
            jj_rb_Rebate_Claim_Line_Item__c claimCLI3 = jj_rb_Test_BaseClass.setupHCPClaimLineItems(hcpClaim3, rebateProduct, hospital);
            try{insert claimCLI3;} catch(Exception ex){}
            
            // approve the claim
            hcpClaim.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update hcpClaim;
            
            //modifications
                        
            cli.jj_rb_Start_Date__c= date.newInstance(2014, 2, 2);
            cli.jj_rb_End_Date__c =cli.jj_rb_Start_Date__c.addDays(20);
            update cli;
            
        }
        test.stopTest();
    }

    
    static testmethod void testAvgQuantityCalculation()
    {
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
            jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
            jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser); 
            
            // setup custom settings
            List<jj_rb_Master_Data_RecordTypes__c> listCS =  jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
            insert listCS; 
            
            // setup hcp customer 
            Account hcp = jj_rb_Test_BaseClass.setupHomecareCustomer(rebateUser);
            insert hcp;
            
            // setup rebate product
            jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
            insert rebateProduct;
            
            // setup region
            jj_rb_Region__c region = jj_rb_Test_BaseClass.setupRegion();
            insert region;
            
            // set NHS Trust
            Account trust = jj_rb_Test_BaseClass.setupTrustCustomer(region);
            insert trust;
            
            // create hospital
            Account hospital = jj_rb_Test_BaseClass.setupHospital(trust, rebateUser);
            insert hospital;
            
            // setup homecare contract
            jj_rb_Rebate_Contract__c hcpContract = jj_rb_Test_BaseClass.setupHomecareContract(rebateProduct, rebateUser);
            insert hcpContract;
            
            // setup contract line items
            jj_rb_Rebate_Contract_Line_Item__c cli = jj_rb_Test_BaseClass.setupHomecareContractLineItem(hcpContract, region);
            insert cli;         
            
            // approve the contract
            hcpContract.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update hcpContract;
            
            // approve the contract line item also
            cli.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update cli;
            
            // create a hcp claim
            jj_rb_Rebate_Claim__c claim = jj_rb_Test_BaseClass.setupHCPClaim(hcp);          
            insert claim;
            
            // create line items
            jj_rb_Rebate_Claim_Line_Item__c claimCLI = jj_rb_Test_BaseClass.setupHCPClaimLineItems(claim, rebateProduct, hospital);
            insert claimCLI;
            
            // approve the claim
            claim.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update claim;
            
            // setup tolerance
            jj_rb_Tolerance__c tol = jj_rb_Test_BaseClass.setupTolerance(hcp, rebateProduct);
            insert tol;                 
        }
        
        
            // check avg qty
            jj_rb_avgQuantityCalc batch = new jj_rb_avgQuantityCalc();
            batch.homecareclaim_recType = jj_rb_Test_BaseClass.getRecordTypeId('Homecare Claim', 'jj_rb_Rebate_Claim__c');
            batch.status_approved = jj_rb_Test_BaseClass.STATUS_APPROVED;
            Database.executeBatch(batch);
            
            // run the scheduler too            
            //jj_rb_avgQuantityCalcScheduler sch = new jj_rb_avgQuantityCalcScheduler();
            //sch.execute(null);
            
        test.stopTest();
            
    }
    
    static testMethod void testNewClaimLineItemOverride()
    {
       // setup running user
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) {   
            // setup custom settings
            List<jj_rb_Master_Data_RecordTypes__c> listCS =  jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
            insert listCS; 
            
            // setup a retailer account
            Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
            insert retailer;
            
            // setup rebate product
            jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
            insert rebateProduct;
            
            // create a retailer claim
            jj_rb_Rebate_Claim__c retailerClaim = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
            insert retailerClaim;
            
            // create retailer line items
            jj_rb_Rebate_Claim_Line_Item__c cli = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(retailerClaim, rebateProduct);
            insert cli;
            
            Pagereference pageRef = Page.jj_rb_Claim_Line_Item_NewOverridepage;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('XXX_lkid',retailerClaim.Id);
            
            jj_rb_NewClaimLineItemOverride controller = new jj_rb_NewClaimLineItemOverride(new Apexpages.standardController(cli));
            system.assertNotEquals(null, controller.url());
        }   
                
        Test.stopTest();        
    }
    
    //Test Rebate claim invoice attachment
    static testMethod void testinvoiceattachment()
    {
        // setup running user
        User rebateUser = jj_rb_Test_BaseClass.setupUser();
        Test.startTest();
        system.runAs(rebateUser)
        {
            // create status custom settings
            list<jj_rb_Rebate_Contract_Line_Item_Status__c> listStatus = jj_rb_Test_BaseClass.createcustomstatus();
            insert listStatus;
            
        	// setup a retailer account
            Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
            insert retailer;
            
            // setup rebate product
            jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
            insert rebateProduct;
            
            // create a retailer claim
            jj_rb_Rebate_Claim__c retailerClaim = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
            insert retailerClaim;
            
            // create retailer line items
            jj_rb_Rebate_Claim_Line_Item__c cli = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(retailerClaim, rebateProduct);
            insert cli;
            
            // create attachment
            Attachment attach1 = jj_rb_Test_BaseClass.setupattachment(retailerClaim.id);
            insert attach1;
            delete attach1;
            retailerClaim.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_SUBMITTED;
            update retailerClaim;    
            Attachment testattach = jj_rb_Test_BaseClass.setupattachment(retailerClaim.id);
            insert testattach;
            
               
            // create attachment
            retailerClaim.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
            update retailerClaim;
            Attachment attach = jj_rb_Test_BaseClass.setupattachment(retailerClaim.id);
            insert attach;
            
            try{
                delete testattach;
            	delete attach;
        	}
            catch(DMLException e)
            {
            }
            System.assertEquals(false, retailerClaim.jj_rb_Attachment_Present__c);
           
        }
         test.stopTest();
    }
	static testmethod void testSubmitforApproval()
	{
		// setup running user
        User rebateUser = jj_rb_Test_BaseClass.setupUser();
        Test.startTest();
        system.runAs(rebateUser)
        {
        	// create status custom settings
            list<jj_rb_Rebate_Contract_Line_Item_Status__c> listStatus = jj_rb_Test_BaseClass.createcustomstatus();
            insert listStatus;
            
        	// setup a retailer account
            Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
            insert retailer;
            
            // setup rebate product
            jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
            insert rebateProduct;
            
            // create a retailer claim
            jj_rb_Rebate_Claim__c retailerClaim = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
            retailerClaim.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_NEW;
            insert retailerClaim;
            
            // create retailer line items
            jj_rb_Rebate_Claim_Line_Item__c cli = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(retailerClaim, rebateProduct);
            cli.jj_rb_Quantity__c  = 505;
            cli.jj_rb_Rebate_Per_Unit__c = 5;
            insert cli;
            // create attachment
            Attachment testattach = jj_rb_Test_BaseClass.setupattachment(retailerClaim.id);
            insert testattach;
            
            list<id> listClaim = new list<id>();
            // Call class
            listClaim.add(retailerClaim.id);
            jj_rb_Claimsubmit_Approval.Submitforapproval(listClaim);
            
            //Assert rescord
            
            list<jj_rb_Rebate_Claim__c> claims = [select id,jj_rb_status__c,name from jj_rb_Rebate_Claim__c where id =:retailerClaim.id ];
            System.assertEquals(jj_rb_Test_BaseClass.STATUS_SUBMITTED , claims[0].jj_rb_status__c);
        }
        test.stopTest();
    }
        
	
}