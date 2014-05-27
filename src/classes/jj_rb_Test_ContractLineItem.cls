/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  3/05/2014
     @description  Test class for the Contract line item related functionality
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    3/05/2014      Original Version
 */
@isTest
private class jj_rb_Test_ContractLineItem {

    static testMethod void testNewContractLineItemOverride() {        
        // setup running user
        User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) {   
        	jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);     
        	
        	// setup a retailer account
        	Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
        	insert retailer;
        	// setup a retailer contract
        	jj_rb_Rebate_Contract__c contract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);
        	insert contract;
        	
        	Pagereference pageRef = Page.jj_rb_Contract_Line_Item_NewOverride;
        	Test.setCurrentPage(pageRef);
        	ApexPages.currentPage().getParameters().put('XXX_lkid',contract.Id);
        	
        	jj_rb_NewContractLineItemOverride controller = new jj_rb_NewContractLineItemOverride(new Apexpages.standardController(new jj_rb_Rebate_Contract_Line_Item__c()));
        	system.assertNotEquals(null, controller.url());
        }	
                
        Test.stopTest();
    }
    
    static testMethod void testEditContractLineItemOverride() {
    	User rebateUser = jj_rb_Test_BaseClass.setupUser();
        
        system.runAs(rebateUser) { 
        	jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
        	
        	List<jj_rb_Master_Data_RecordTypes__c> listRecType = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
            insert listRecType;
            list<jj_rb_Rebate_Contract_Line_Item_Status__c> listStatus = jj_rb_Test_BaseClass.createcustomstatus();
        	insert listStatus;
        	// setup a retailer account
        	Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
        	insert retailer;
        	// setup a rtailer contract
        	jj_rb_Rebate_Contract__c contract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);
        	insert contract;
        	// setup contract line items
        	jj_rb_Rebate_Product__c product = jj_rb_Test_BaseClass.setupRebateProduct();
        	insert product;
        	jj_rb_Rebate_Contract_Line_Item__c cli = jj_rb_Test_BaseClass.setupRetailerContractLineItem(contract, product);
        	insert cli;
        	test.startTest();
        	cli.jj_rb_status__c = 'Closed';
        	update cli;
        	jj_rb_EditcontractLineItemOverrideclass controller = new jj_rb_EditcontractLineItemOverrideclass(new ApexPages.Standardcontroller(cli));
        	controller.edit();
        	
        	cli.jj_rb_status__c = 'Approved';
        	update cli;
        	controller = new jj_rb_EditcontractLineItemOverrideclass(new ApexPages.Standardcontroller(cli));
        	controller.edit();
        	
        	contract.jj_rb_status__c = 'Submitted';
        	update contract;
        	controller = new jj_rb_EditcontractLineItemOverrideclass(new ApexPages.Standardcontroller(cli));
        	controller.edit();
        	
        	cli.jj_rb_status__c = 'Expired';
        	update cli;
        	controller = new jj_rb_EditcontractLineItemOverrideclass(new ApexPages.Standardcontroller(cli));
        	controller.edit();
        	
        	test.stopTest();
        }
    }
    	 
    
}