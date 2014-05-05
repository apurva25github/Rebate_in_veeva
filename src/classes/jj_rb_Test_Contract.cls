/**
 *    @author  Apurva Prasade
 *    @date  5/05/2014
      @description  Test class for the Rebate Contracts
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Apurva Prasade			5/05/2014		Original Version
     Sarabdeep Ahluwalia    5/05/2014      	Added testmethod for Contract Edit Override
 */
@isTest
private class jj_rb_Test_Contract 
{    
    // test method for contract edit override functionality
    static testmethod void testEditContractOverride()
    {
    	User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
        	jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
        	
        	// setup a retailer account
        	Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
        	insert retailer;
        	// setup a rtailer contract
        	jj_rb_Rebate_Contract__c contract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);    
        	insert contract;    	
        	
        	jj_rb_EditcontractOverrideclass controller = new jj_rb_EditcontractOverrideclass(new ApexPages.Standardcontroller(contract));
        	controller.Edit();        	
        }
        
        Test.stopTest();	
    }
        
    
    // test method to test creation of a retailer contract
    static testmethod void testCreateRetailerContract()
    {
    	User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
        	jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
        	
        	insert jj_rb_Test_BaseClass.setupCustomSettingForStatus('Approved', 'Approved');
        	
        	// setup a retailer account
        	Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
        	insert retailer;
        	// setup rebate product
        	jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
        	insert rebateProduct;
        	
        	// setup a retailer contract
        	jj_rb_Rebate_Contract__c rebateContract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);
        	insert rebateContract;
        	// create line item 1
        	jj_rb_Rebate_Contract_Line_Item__c cli1 =  jj_rb_Test_BaseClass.setupRetailerContractLineItem(rebateContract, rebateProduct);
        	insert cli1;
        	// create line item 2 with overlapping dates
        	jj_rb_Rebate_Contract_Line_Item__c cli2 =  jj_rb_Test_BaseClass.setupRetailerContractLineItem(rebateContract, rebateProduct);
        	try {
        		insert cli2;
        	} catch (Exception e) {}   	
        	
        	
        	// submit the contract for approval
        	rebateContract.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_SUBMITTED;
        	update rebateContract;
        	cli1.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_SUBMITTED;
        	update cli1;
        	
        	// approve the contract
        	rebateContract.jj_rb_Status__c = jj_rb_Test_BaseClass.STATUS_APPROVED; 
        	update rebateContract; 	       	
        }
        
        Test.stopTest();	
    }
    
    static testmethod void testExpiringContractNotifications()
    {
    	User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
        	jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
        	
        	// setup a retailer account
        	Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
        	insert retailer;
        	// setup rebate product
        	jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
        	insert rebateProduct;
        	
        	// setup a retailer contract
        	jj_rb_Rebate_Contract__c rebateContract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);
        	insert rebateContract;
        	// create line item 1
        	jj_rb_Rebate_Contract_Line_Item__c cli1 =  jj_rb_Test_BaseClass.setupRetailerContractLineItem(rebateContract, rebateProduct);
        	cli1.jj_rb_Start_Date__c = date.today() - 1;
        	cli1.jj_rb_End_Date__c = date.today() + 1;
        	// create line item 2
        	jj_rb_Rebate_Contract_Line_Item__c cli2 =  jj_rb_Test_BaseClass.setupRetailerContractLineItem(rebateContract, rebateProduct);
        	cli2.jj_rb_Start_Date__c = date.today() + 2;
        	cli2.jj_rb_End_Date__c = date.today() + 14;
        	// create line item 3
        	jj_rb_Rebate_Contract_Line_Item__c cli3 =  jj_rb_Test_BaseClass.setupRetailerContractLineItem(rebateContract, rebateProduct);
        	cli3.jj_rb_Start_Date__c = date.today() + 30;
        	cli3.jj_rb_End_Date__c = date.today() + 60;
        	
        	insert new List<jj_rb_Rebate_Contract_Line_Item__c> {cli1, cli2, cli3};
        	
        	// call the notifications batch        	
         	jj_rb_contract_notification_schedular schedular = new jj_rb_contract_notification_schedular();
         	schedular.execute(null);         	  
        }
        Test.stopTest();	
    }
    
    static testmethod void testCloseContract()
    {
    	User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        
        Test.startTest();
        
        system.runAs(rebateUser) { 
        	jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
        	
        	// setup a retailer account
        	Account retailer = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateUser);
        	insert retailer;
        	// setup rebate product
        	jj_rb_Rebate_Product__c rebateProduct = jj_rb_Test_BaseClass.setupRebateProduct();
        	insert rebateProduct;
        	
        	// setup a retailer contract
        	jj_rb_Rebate_Contract__c rebateContract = jj_rb_Test_BaseClass.setupRetailerContract(retailer, rebateUser);
        	rebateContract.jj_rb_status__c = jj_rb_Test_BaseClass.STATUS_SUBMITTED;
        	insert rebateContract;
        	
        	// create line item 1
        	jj_rb_Rebate_Contract_Line_Item__c cli1 =  jj_rb_Test_BaseClass.setupRetailerContractLineItem(rebateContract, rebateProduct);
        	insert cli1;
        	
        	// setup custom settings for status
        	List<jj_rb_Rebate_Contract_Line_Item_Status__c> listCS  = new List<jj_rb_Rebate_Contract_Line_Item_Status__c>();
        	listCS.add(jj_rb_Test_BaseClass.setupCustomSettingForStatus('Closed','Closed'));
        	insert listCS;
        	
        	// setup custom settings for record type
        	List<jj_rb_Master_Data_RecordTypes__c> listRecordTypes = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
        	insert listRecordTypes;
        	
        	
        	// test closed contract functionality
        	jj_rb_Close_contract controller = new jj_rb_Close_contract(new APexpages.Standardcontroller(rebateContract));
        	controller.close_contract();
        	
        }
        test.stopTest();	
    }
     
    /*
    public static testmethod void Test_contract()
    {
        User u = testUser();
        if(u!=null)
        {
            System.runAs(u){
                jj_rb_Test_BaseClass.setupRebateNCMUser(u);
                Test_close_contract_CTE();
                Test_contract_notification();
            }
        }    
    }
    
     public static user testUser()
        {
            User test_user = jj_rb_Test_MDR_class.getRebateUser(); 
            return test_user;
        }
        
        
    //Retailer contract creator
    public static jj_rb_Rebate_Contract__c retailerContractCreator()
    {
        jj_rb_Rebate_Contract__c RContract= new jj_rb_Rebate_Contract__c();                   
        RContract.jj_rb_Customer__c = jj_rb_Test_MDR_class.accountCreator().id ;
        RContract.jj_rb_Description__c='Retailer Contract';
        RContract.jj_rb_Status__c= jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');
         RContract.jj_rb_National_Channel_Manager__c =  jj_rb_Test_Contract.testUser().id;
        Rcontract.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Rebate_Contract_Retailer',jj_rb_Test_MDR_class.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract__c'));
        //Rcontract.RecordTypeId = '012110000004Smv';
        insert RContract;
        return RContract;
    }
    //Retialer contract Line Item Creator  
    public static jj_rb_Rebate_Contract_Line_Item__c retailerContractLineItemCreator(id contractId,date srt_date,date end_date)
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=contractId;
        Rebatecontractlineitem.jj_rb_Product__c = newproduct.id;
        Rebatecontractlineitem.jj_rb_Start_Date__c = srt_date;
        Rebatecontractlineitem.jj_rb_End_Date__c = end_date;
        Rebatecontractlineitem.jj_rb_Rebate__c = 50;
        Rebatecontractlineitem.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');  
        Rebatecontractlineitem.jj_rb_Is_Modified__c= true;  
        Rebatecontractlineitem.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Contract_LineItem_Retailer',jj_rb_Test_MDR_class.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract_Line_Item__c'));
        //insert Rebatecontractlineitem;
        System.debug('Inserted contractlynitm ********* '+Rebatecontractlineitem);
        return Rebatecontractlineitem;
    }
    
    //Homecare contract creator
    public static jj_rb_Rebate_Contract__c HCPContractCreator()    
    {        
        jj_rb_Rebate_Contract__c HCPContract= new jj_rb_Rebate_Contract__c();                           
        HCPContract.jj_rb_Product__c = newproduct.id;         
        HCPContract.jj_rb_Description__c = 'Homecare contract';        
        HCPContract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');        
        HCPContract.jj_rb_National_Channel_Manager__c = jj_rb_Test_MDR_class.getRebateUser().id;             
        HCPContract.RecordTypeId =  jj_rb_Test_MDR_class.ReocrdTypeCreator('Homecare_Contract',jj_rb_Test_MDR_class.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract__c'));     
        //HCPContract.RecordTypeId = '012110000004Smt';
        insert HCPContract;
        return HCPContract;    
    }
    
    //Homecare contract Line item creator
    public static jj_rb_Rebate_Contract_Line_Item__c HCPcontractlntitmcreator(id contractid,date srt_date,date end_date)
    {
        jj_rb_Rebate_Contract_Line_Item__c HCPlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        HCPlineitem.jj_rb_Rebate_Contract__c = contractid;
        HCPlineitem.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');   
        HCPlineitem.jj_rb_Description__c = 'Homecare contract line item';
		HCPlineitem.jj_rb_Start_Date__c = srt_date;
        HCPlineitem.jj_rb_End_Date__c = end_date;
        HCPlineitem.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Homecare_Contract_Line_Item',jj_rb_Test_MDR_class.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract_Line_Item__c'));  
    	//HCPlineitem.RecordTypeId = '012110000004Smo';
        //insert HCPlineitem;
        //System.debug('Inserted HCP line item ********* '+HCPlineitem);
        return HCPlineitem;
    }
    
    //Close contract functionality - 94%
    public static void Test_close_contract_CTE()
    {
         jj_rb_Test_MDR_class.ReocrdTypeCreator('Homecare_Contract_Line_Item',jj_rb_Test_MDR_class.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract_Line_Item__c'));

        //Retailer Contract  
        jj_rb_Test_MDR_class.ReocrdTypeCreator('Contract_LineItem_Retailer',jj_rb_Test_MDR_class.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract_Line_Item__c'));
        jj_rb_Rebate_Contract__c contract = jj_rb_test_Contract.retailerContractCreator();
        jj_rb_Rebate_Contract_Line_Item__c retailerRCLI = jj_rb_test_Contract.retailerContractLineItemCreator(contract.id,date.today()+80,date.today()+180);
        insert retailerRCLI;
        contract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Submitted', 'Submitted'); 
        update contract;
        
         ApexPages.StandardController sc_contract = new ApexPages.StandardController(contract);
        jj_rb_Close_contract closeContract = new jj_rb_Close_contract(sc_contract);
        PageReference pgref = new PageReference('jj_rb_Close_Rebate_Contract');
        pgref.getParameters().put('id',string.valueOf(contract.id));
        test.setCurrentPage(pgref);
        closeContract.close_contract();
        
        //Homecare contract
        jj_rb_Rebate_Contract__c hcp_contract = jj_rb_test_Contract.HCPContractCreator();
        //System.debug('HCP contract ****** '+hcp_contract);
        
        jj_rb_Rebate_Contract_Line_Item__c hcpRCLI = jj_rb_test_Contract.HCPcontractlntitmcreator(hcp_contract.id,date.today()+80,date.today()+180);
        insert hcpRCLI;
        //System.debug('HCP line Item ******** '+jj_rb_test_Contract.HCPcontractlntitmcreator(hcp_contract.id));
        hcp_contract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Submitted', 'Submitted'); 
        update hcp_contract;
        //System.debug('updates HCP line item **** '+hcp_contract);
        ApexPages.StandardController hcp_controller = new ApexPages.StandardController(hcp_contract);
        //System.debug('controller ***** '+hcp_controller);
        jj_rb_Close_contract hcpcloseContract = new jj_rb_Close_contract(hcp_controller);
        PageReference pagref = new PageReference('jj_rb_Close_Rebate_Contract');
        pagref.getParameters().put('id',string.valueOf(hcp_contract.id));
        test.setCurrentPage(pagref);
        hcpcloseContract.close_contract();
        
        contract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved', 'Approved'); 		
        update contract;
    }
    
    // contract Notification
     public static void Test_contract_notification()
     {
         list<jj_rb_Rebate_Contract_Line_Item__c> listLineItem = new list<jj_rb_Rebate_Contract_Line_Item__c>();
         //Retailer contract
         jj_rb_Rebate_Contract__c contract = jj_rb_test_Contract.retailerContractCreator();
         jj_rb_Rebate_Contract_Line_Item__c line_item_today = jj_rb_test_Contract.retailerContractLineItemCreator(contract.id,date.today()-1,date.today());
         jj_rb_Rebate_Contract_Line_Item__c line_item_2wks = jj_rb_test_Contract.retailerContractLineItemCreator(contract.id,date.today()+1,date.today()+14);
         jj_rb_Rebate_Contract_Line_Item__c line_item_2mnth = jj_rb_test_Contract.retailerContractLineItemCreator(contract.id,date.today()+30,date.today()+60);
		 listLineItem.add(line_item_today);
         listLineItem.add(line_item_2wks);
         listLineItem.add(line_item_2mnth);
         
         // Homecare contract
		 
         jj_rb_Rebate_Contract__c hcp_contract = jj_rb_test_Contract.HCPContractCreator();
         jj_rb_Rebate_Contract_Line_Item__c hcp_today = jj_rb_test_Contract.HCPcontractlntitmcreator(hcp_contract.id,date.today()-1,date.today());     
         jj_rb_Rebate_Contract_Line_Item__c hcp_2wks = jj_rb_test_Contract.HCPcontractlntitmcreator(hcp_contract.id,date.today()+1,date.today()+14); 
         jj_rb_Rebate_Contract_Line_Item__c hcp_2mnth = jj_rb_test_Contract.HCPcontractlntitmcreator(hcp_contract.id,date.today()+30,date.today()+60);     
		 listLineItem.add(hcp_today);
         listLineItem.add(hcp_2wks);
         listLineItem.add(hcp_2mnth);
         
		 insert listLineItem;
		 jj_rb_Contract_notifications notification= new jj_rb_Contract_notifications();
         Database.executeBatch(notification);  
     }*/
}