/**
 *    @author  Apurva Prasade
 *    @date  15/04/2014
     @description  Test class for Master Data Request 
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Apurva Prasade    15/04/2014      Original Version
 */
@isTest
    public class jj_rb_Test_MDR_class
    {
        //static User rebateUser;
        static list<jj_rb_Master_Data_Request__c> RetailerMDR = new list<jj_rb_Master_Data_Request__c>();
        static list<jj_rb_Master_Data_Request__c> HCPMDR = new list<jj_rb_Master_Data_Request__c>();
        static list<jj_rb_Master_Data_Request__c> trustMDR = new list<jj_rb_Master_Data_Request__c>();
        static list<jj_rb_Master_Data_Request__c> productMDR = new list<jj_rb_Master_Data_Request__c>();
      
        public static string customsStatusCreator(String name,String Status)
        {
            jj_rb_Rebate_Contract_Line_Item_Status__c Statuscustomsetting = new jj_rb_Rebate_Contract_Line_Item_Status__c();
            Statuscustomsetting.name = name;
            Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c = Status;
            insert Statuscustomsetting;
            return Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c;
        }
        public static testmethod void Test_RequestChange_CTE()
        {
            // MDR recordtypes
          
			User rebateuser = jj_rb_Test_BaseClass.setupUser();
			
            System.runas(rebateuser)
            {
            	List<jj_rb_Master_Data_RecordTypes__c> listRecType = jj_rb_Test_BaseClass.createRecordTypeCustomSetting();
				insert listRecType;
            	jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);
            	jj_rb_Test_BaseClass.setupRebateNCMUser(rebateUser);
            	Account retaileracc = jj_rb_Test_BaseClass.setupRetailerCustomer(rebateuser);
            	insert retaileracc;
            	jj_rb_Rebate_Product__c products = jj_rb_Test_BaseClass.setupRebateProduct();
            	insert products;
            	jj_rb_Test_MDR_class.Retialeracc(retaileracc,products);
            	Account hcpacc = jj_rb_Test_BaseClass.setupHomecareCustomer(rebateuser);
            	insert hcpacc;
            	jj_rb_Test_MDR_class.Homecareacc(hcpacc);
            	jj_rb_Region__c regionrec = jj_rb_Test_BaseClass.setupRegion();
            	insert regionrec;
            	Account trustacc = jj_rb_Test_BaseClass.setupTrustCustomer(regionrec);
            	insert trustacc;
            	jj_rb_Test_MDR_class.trustacc(trustacc);
            	jj_rb_Estimated_Rebate_Accrual__c era = jj_rb_Test_BaseClass.setupERA(retaileracc, products);
            	insert era;
           		//era.jj_rb_Account__c = retaileracc.id;
           		//update era;
            	
            // MDR Convert Trigger testing 
           
	            jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
	            
	            if(!RetailerMDR.isEmpty()) {
		            jj_rb_Master_Data_Request__c retailMDR = RetailerMDR[0];
		            retailMDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
		            update retailMDR;
		            era.jj_rb_Master_Data_Request__c =  retailMDR.Id;
		            update era;
		            
	            }      
	            if(!HCPMDR.isEmpty()) {
		            jj_rb_Master_Data_Request__c HomecareMDR = HCPMDR[0];
		            HomecareMDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
		            update HomecareMDR;
	            }
	            
	            if(!trustMDR.isEmpty()) {
		            jj_rb_Master_Data_Request__c trust_MDR = trustMDR[0];
		            trust_MDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
		            update trust_MDR;
	            }
	            
	            if(!productMDR.isEmpty()) {
		            jj_rb_Master_Data_Request__c proMDR = productMDR[0];
		            proMDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
		            update proMDR; 
	            }
             }
           
            
        }
      	public static void Retialeracc(Account retaileracc,jj_rb_Rebate_Product__c products)
        {
			// ************** Retailer **************************************
            // Call standard controller.
            System.debug('In Retaikeracc method ***** ');
            ApexPages.StandardController sc_customer =  new ApexPages.StandardController(retaileracc);
            ApexPages.StandardController sc_product =  new ApexPages.StandardController(products);
            // Call VF extension
            jj_rb_Rebate_RequestChange_CTE Request_change_customer = new jj_rb_Rebate_RequestChange_CTE(sc_customer);
            jj_rb_Rebate_RequestChange_CTE Request_change_product = new jj_rb_Rebate_RequestChange_CTE(sc_product);
            
            //Call VF pages with Newly inserted Record ID
            PageReference pgref = new PageReference('jj_rb_Rebate_Account_RequestChange');
            pgref.getParameters().put('id',string.valueOf(retaileracc.id));
            test.setCurrentPage(pgref);
            PageReference pageref = new PageReference('jj_rb_Rebate_Product_RequestChange');
            pageref.getParameters().put('id',string.valueOf(products.id));
            Test.setCurrentPage(pageref);
            
            // Call Extension methods
            Request_change_customer.AccountPageLoad();
            Request_change_product.ProductPageLoad();
            Request_change_customer.submitForChange();
            Request_change_product.submitForChange();
            Request_change_product.Cancel();  
            
             RetailerMDR = [select jj_rb_status__c,jj_rb_Business_Name__c,jj_rb_Rebate_Request_Change_For_ID__c,
                                    jj_rb_SAP_Customer_Number__c,jj_rb_National_Channel_Manager__c,
                                    jj_rb_SAP_Vendor_Number__c,jj_rb_IMS_Customer_Id__c,RecordTypeId 
                                    from jj_rb_Master_Data_Request__c 
                                    where jj_rb_Business_Name__c =: retaileracc.name];
                System.debug('Retailer MDR List  ***** '+RetailerMDR);
                if(RetailerMDR.size() > 0)
                {
                      System.assertEquals('test Account',RetailerMDR[0].jj_rb_Business_Name__c) ;
                }
            productMDR = [select jj_rb_Product_Name__c,jj_rb_SAP_EAN_Code__c
            				from jj_rb_Master_Data_Request__c
            				where jj_rb_Product_Name__c =: products.name];
           	if(productMDR.size() > 0)
           	{
           			system.assertEquals('Test Product',productMDR[0].jj_rb_Product_Name__c) ;
           	}
        }
        
        public static void Homecareacc(Account hcpacc)
        {
            //************** HCP **************************************************
            System.debug('HCP ACC  method ********* '+ hcpacc);
             // Call standard controller.
            ApexPages.StandardController hcpsc_customer =  new ApexPages.StandardController(hcpacc);
            System.debug('STD controller HCP ** '+hcpsc_customer);
            //ApexPages.StandardController hcpsc_product =  new ApexPages.StandardController(product);
            // Call VF extension
            jj_rb_Rebate_RequestChange_CTE hcpRequest_change_customer = new jj_rb_Rebate_RequestChange_CTE(hcpsc_customer);
            //jj_rb_Rebate_RequestChange_CTE hcpRequest_change_product = new jj_rb_Rebate_RequestChange_CTE(hcpsc_product);
            
            //Call VF pages with Newly inserted Record ID
            PageReference hcppgref = new PageReference('jj_rb_Rebate_Account_RequestChange');
            hcppgref.getParameters().put('id',string.valueOf(hcpacc.id));
            test.setCurrentPage(hcppgref);
           
            
            // Call Extension methods
            hcpRequest_change_customer.AccountPageLoad();
            //hcpRequest_change_product.ProductPageLoad();
            hcpRequest_change_customer.submitForChange();
            //hcpRequest_change_product.Cancel();
            
            HCPMDR = [select jj_rb_status__c,jj_rb_Business_Name__c,jj_rb_Rebate_Request_Change_For_ID__c,
                                    jj_rb_SAP_Customer_Number__c,jj_rb_National_Channel_Manager__c,
                                    jj_rb_SAP_Vendor_Number__c,jj_rb_IMS_Customer_Id__c,RecordTypeId 
                                    from jj_rb_Master_Data_Request__c 
                                    where jj_rb_Business_Name__c =: hcpacc.name];
            if(HCPMDR.size() > 0)
            {
            	System.assertEquals('test Account',RetailerMDR[0].jj_rb_Business_Name__c) ;
            }
            
        }
         public static void trustacc(Account trustacc)
         {
             //************* Trust ************************************************
             // Call standard controller.
            ApexPages.StandardController trust_customer =  new ApexPages.StandardController(trustacc);
             System.debug('STD controller  ** '+trust_customer);
            //ApexPages.StandardController hospsc_product =  new ApexPages.StandardController(product);
            // Call VF extension
            jj_rb_Rebate_RequestChange_CTE hospRequest_change_customer = new jj_rb_Rebate_RequestChange_CTE(trust_customer);
            //jj_rb_Rebate_RequestChange_CTE hospRequest_change_product = new jj_rb_Rebate_RequestChange_CTE(hospsc_product);
            
            //Call VF pages with Newly inserted Record ID
            PageReference hosppgref = new PageReference('jj_rb_Rebate_Account_RequestChange');
            hosppgref.getParameters().put('id',string.valueOf(trustacc.id));
            test.setCurrentPage(hosppgref);
         
            // Call Extension methods
            hospRequest_change_customer.AccountPageLoad();
            //hospRequest_change_product.ProductPageLoad();
            hospRequest_change_customer.submitForChange();
           // hospRequest_change_product.Cancel();
           trustMDR = [select jj_rb_status__c,jj_rb_Business_Name__c,jj_rb_Rebate_Request_Change_For_ID__c,
                                    jj_rb_SAP_Customer_Number__c,jj_rb_National_Channel_Manager__c,
                                    jj_rb_SAP_Vendor_Number__c,jj_rb_IMS_Customer_Id__c,RecordTypeId 
                                    from jj_rb_Master_Data_Request__c 
                                    where jj_rb_Business_Name__c =: trustacc.name];
           if(trustMDR.size() > 0)
            {
            	System.assertEquals('Test Trust',trustMDR[0].jj_rb_Business_Name__c) ;
            }
           
           
         }
       
    }