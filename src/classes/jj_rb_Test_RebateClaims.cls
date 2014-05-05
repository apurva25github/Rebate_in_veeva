/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  5/05/2014
      @description  Test class for the Rebate Claims
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------     
     Sarabdeep Ahluwalia    5/05/2014      	Original
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
        	insert retailer;
        	
        	// setup rebate product
        	jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
        	insert rebateProduct;
        	
        	// setup retailer contract
        	jj_rb_Rebate_Contract__c contract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);
        	insert contract;
        	
        	// setup cpntract line items
        	jj_rb_Rebate_Contract_Line_Item__c conLI = jj_rb_Test_BaseClass.setupRetailerContractLineItem(contract, rebateProduct);
        	insert conLI;
        	
        	// update the contract status
        	contract.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
        	update contract;
        	
        	// create a retailer claim
        	jj_rb_Rebate_Claim__c retailerClaim1 = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
        	retailerClaim1.jj_rb_month__c = '03';
        	retailerClaim1.jj_rb_Year__c = '2014';
        	insert retailerClaim1;
        	
        	// create retailer line items
        	jj_rb_Rebate_Claim_Line_Item__c cli1 = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(retailerClaim1, rebateProduct);
        	insert cli1;
        	
        	// create second claim
        	jj_rb_Rebate_Claim__c retailerClaim2 = jj_rb_Test_BaseClass.setupRetailerClaim(retailer);
        	retailerClaim2.jj_rb_month__c = '04';
        	retailerClaim2.jj_rb_Year__c = '2014';
        	insert retailerClaim2;
        	
        	// create retailer line items
        	jj_rb_Rebate_Claim_Line_Item__c cli2 = jj_rb_Test_BaseClass.setupRetailerClaimLineItems(retailerClaim2, rebateProduct);
        	insert cli2;
        	
        	// approve the claim
        	retailerClaim1.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
        	retailerClaim2.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
        	update new List<jj_rb_Rebate_Claim__c>{retailerClaim1,retailerClaim2}; 
        	
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
        	jj_rb_NHS_Trust__c trust = jj_rb_Test_BaseClass.setupTrust(region);
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
        	
        	// approve the contract
        	hcpContract.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
        	update hcpContract;       	
        	
        	// create a hcp claim
        	jj_rb_Rebate_Claim__c hcpClaim = jj_rb_Test_BaseClass.setupHCPClaim(customer);
        	hcpClaim.jj_rb_Month__c = '02';
        	hcpClaim.jj_rb_Year__c = '2014';
        	insert hcpClaim;
        	
        	
        	// create claim line items
        	jj_rb_Rebate_Claim_Line_Item__c claimCLI = jj_rb_Test_BaseClass.setupHCPClaimLineItems(hcpClaim, rebateProduct, hospital);
        	insert claimCLI;        	
        	
        	// approve the claim
        	hcpClaim.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED;
        	update hcpClaim;
        	
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
        	jj_rb_NHS_Trust__c trust = jj_rb_Test_BaseClass.setupTrust(region);
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
	

}