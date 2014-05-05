@isTest
    public class jj_rb_Test_MDR_class
    {
        static User rebateUser;
        static list<jj_rb_Master_Data_Request__c> RetailerMDR = new list<jj_rb_Master_Data_Request__c>();
        static list<jj_rb_Master_Data_Request__c> HCPMDR = new list<jj_rb_Master_Data_Request__c>();
        static list<jj_rb_Master_Data_Request__c> HOSPMDR = new list<jj_rb_Master_Data_Request__c>();
        static list<jj_rb_Master_Data_Request__c> productMDR = new list<jj_rb_Master_Data_Request__c>();
        public static user getRebateUser()
        {
            if(rebateUser == null)
                rebateUser = jj_rb_Test_MDR_class.userCreator();
            return  rebateUser;
        }
        
        public static  String accountTypeCreator(String name,String Acc_type)
        {
            jj_rb_account_type__c accType= new jj_rb_account_type__c();
            accType.name=name;
            accType.jj_rb_Account_Type__c=Acc_type;
            insert accType;
            return accType.jj_rb_Account_Type__c;        
        }
        // Get Recordtypeid
        public static String getRecordtype(String recortypename,String objecttype)
        {
            list<Recordtype> Rectypid = [select id,name from Recordtype where name =: recortypename and sobjecttype =: objecttype];
            if(Rectypid.size() != 0)
            {
                return Rectypid[0].id;
            }
            else
                return null;
        }
        //User creator
        public static user userCreator()
        {
            list<Profile> prof = [select id,name from profile where name =: 'System Administrator'];
            user u = new user();
            u.Alias='abc';
            u.LastName='TestUser';
            u.Email='test@sales.com';
            u.username='qwe@sales.com';
            u.EmailEncodingKey='UTF-8';
            u.TimeZoneSidKey='Europe/Paris';
            u.LocaleSidKey='en_US';
            u.LanguageLocaleKey='en_US' ;       
            u.ProfileId=prof[0].id;     
            insert u;
            return u;
        }
        //Retailer Account
        
        public static Account accountCreator()
        {
            String rectypid = jj_rb_Test_MDR_class.getRecordtype('Retailer','Account');
            Account customer = new Account();
            customer.jj_rb_SAP_Customer_Number__c = '8964';
            customer.jj_rb_National_Channel_Manager__c=jj_rb_Test_MDR_class.getRebateUser().id;
            customer.Name = 'Pharma'; 
            customer.jj_rb_SAP_Vendor_Number__c = '5645';  
            customer.Account_Type__c = jj_rb_Test_MDR_class.accountTypeCreator('Retailer Type','Retailer');
            customer.jj_rb_IMS_Customer_Id__c='52578';
            customer.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Account_Retailer',rectypid);
            insert customer; 
            return customer;
        }
        
        //Homecare Account
        
        public static Account homecareaccountCreator()
        {
            String rectypid = jj_rb_Test_MDR_class.getRecordtype('Homecare provider','Account');
            //System.debug('ID HCP ********** '+rectypid);
            Account homecare = new Account();
            homecare.jj_rb_SAP_Customer_Number__c = '9855';
            homecare.jj_rb_National_Channel_Manager__c= jj_rb_Test_MDR_class.getRebateUser().id;
            homecare.Name = 'Homecare pharma';
            homecare.jj_rb_SAP_Vendor_Number__c = '7578';
            homecare.Account_type__c = jj_rb_Test_MDR_class.accountTypeCreator('Home Care Provider','Homacare provider');
            homecare.jj_rb_Credit_check_Validity_From__c = Date.today();
            homecare.jj_rb_Credit_check_Validity_End__c = Date.today()+60;
            homecare.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Account_Homecare',rectypid);
            //homecare.RecordTypeId  = '012110000004SmZ';
            //System.debug('in HCP creator method***** '+homecare.RecordTypeId);
            insert homecare; 
            return homecare;
        }
        
        // Hospital Account
        public static Account HospitalCreator()
        {
            String rectypid = jj_rb_Test_MDR_class.getRecordtype('Hospital_vod','Account');
            Account customer = new Account();
            customer.jj_rb_National_Channel_Manager__c=jj_rb_Test_MDR_class.getRebateUser().Id;
            customer.Name = 'Hospital'; 
            customer.Account_Type__c = jj_rb_Test_MDR_class.accountTypeCreator('Hospital','Hospital');
            customer.jj_rb_NHS_Trust__c = jj_rb_Test_MDR_class.NhstrustCreator().id;
            customer.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Account_Hospital',rectypid);
            insert customer; 
            return customer;
        }

        public static jj_rb_Region__c regionCreator()
    {
        jj_rb_Region__c region= new jj_rb_Region__c();
        region.Name='4GEN';
        region.jj_rb_Description__c='General';  
        insert region;
        return region;
    }
    public static jj_rb_NHS_Trust__c NhstrustCreator()
    {
        jj_rb_NHS_Trust__c nhstrust = new jj_rb_NHS_Trust__c();
        nhstrust.name = 'Fortis';
        nhstrust.jj_rb_Business_City__c = 'Banglore';
        nhstrust.jj_rb_Business_Country__c = 'India';
        nhstrust.jj_rb_Business_Phone__c='96523';
        nhstrust.jj_rb_Business_Postal_Code__c = '986531';
        nhstrust.jj_rb_Business_State__c = 'karnataka';
        nhstrust.jj_rb_Business_Street__c='samllStreet';
        nhstrust.jj_rb_NHS_Trust_ID__c = '96531';
        nhstrust.jj_rb_Region__c = jj_rb_Test_MDR_class.regionCreator().Id;
       
        insert nhstrust;  
        return nhstrust;
    } 
        // ERA creator 
        public static jj_rb_Estimated_Rebate_Accrual__c ERAcreator(integer estimatedAcc,id products)
        {
            jj_rb_Estimated_Rebate_Accrual__c ERA = new jj_rb_Estimated_Rebate_Accrual__c();
            //ERA.jj_rb_Account__c = jj_rb_MDR_proc_test_class.accountCreator();
            ERA.jj_rb_Estimated_Accrual__c = estimatedAcc;
            ERA.jj_rb_Rebate_Product__c =   products;
            //ERA.jj_rb_Master_Data_Request__c = mdrId;
            insert ERA;
            return ERA;
        }
        public static string customsStatusCreator(String name,String Status)
        {
            jj_rb_Rebate_Contract_Line_Item_Status__c Statuscustomsetting = new jj_rb_Rebate_Contract_Line_Item_Status__c();
            Statuscustomsetting.name = name;
            Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c = Status;
            insert Statuscustomsetting;
            return Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c;
        }
        public static jj_rb_VAT_Code__c  vatCodeCreator()
        {
            jj_rb_VAT_Code__c vat= new jj_rb_VAT_Code__c(); 
            vat.name = 'low VAT';
            vat.jj_rb_VAT__c = 5;    
            insert vat;
            return vat;
        }
        
        
    //Product creator
    
    public static jj_rb_Rebate_Product__c rebateProductCreator()
        {
            jj_rb_VAT_Code__c vatcode = jj_rb_Test_MDR_class.vatCodeCreator();
            jj_rb_Rebate_Product__c product = new jj_rb_Rebate_Product__c();
            product.Name ='Digene';
            product.jj_rb_Description__c ='Triz - For cold';
            product.jj_rb_SAP_Material_Number__c ='98455';
            product.jj_rb_SAP_EAN_Code__c='96850';
            product.jj_rb_IMS_Product_ID__c = '98564';
            product.jj_rb_Unit_of_Measure__c='Pieces';
            product.jj_rb_VAT_Code__c=vatcode.id;
            insert product;
            return product;
        }
        
         public static String ReocrdTypeCreator(String recordTypeName,string RecortypID)
        {
            jj_rb_Master_Data_RecordTypes__c RecordType = new jj_rb_Master_Data_RecordTypes__c();
            RecordType.name = recordTypeName;
            RecordType.jj_rb_RecordTypeId__c = RecortypID;
            insert RecordType;
            return RecordType.jj_rb_RecordTypeId__c;       
        }
        // Test User
        public static user testUser()
        {
            User testUser = jj_rb_Test_MDR_class.getRebateUser();
            	jj_rb_Test_BaseClass.setupRebateAnalystUser(testUser);
            	return testUser;
        }
        public static testmethod void mainTestMethod()
        {
            user u = testUser();
            if(u!= null)
            {
                System.runAs(u){
                Test_RequestChange_CTE();}
            } 
        }
        public static void Test_RequestChange_CTE()
        {
            // MDR recordtypes
            jj_rb_Test_MDR_class.ReocrdTypeCreator('Retailer_MDR',jj_rb_Test_MDR_class.getRecordtype('Retailer Customer Data Request','jj_rb_Master_data_request__c'));
            jj_rb_Test_MDR_class.ReocrdTypeCreator('Homecare_MDR',jj_rb_Test_MDR_class.getRecordtype('Homecare Customer Data Request','jj_rb_Master_data_request__c'));
            jj_rb_Test_MDR_class.ReocrdTypeCreator('Hospital_Data_Request',jj_rb_Test_MDR_class.getRecordtype('Hospital Data Request','jj_rb_Master_data_request__c'));
            jj_rb_Test_MDR_class.ReocrdTypeCreator('Product_Data_Request', jj_rb_Test_MDR_class.getRecordtype('Product Data Request','jj_rb_Master_data_request__c'));
            
            // Product creation
            jj_rb_Rebate_Product__c product = jj_rb_Test_MDR_class.rebateProductCreator();
            // Retailer customer
            Account retaileracc = jj_rb_Test_MDR_class.accountCreator();
            jj_rb_Test_MDR_class.Retialeracc(retaileracc,product);
            // HCP customer
            Account hcpacc = jj_rb_Test_MDR_class.homecareaccountCreator();
            jj_rb_Test_MDR_class.Homecareacc(hcpacc);
			// Hospital customer
            Account hospacc = jj_rb_Test_MDR_class.HospitalCreator();
            jj_rb_Test_MDR_class.hospitalacc(hospacc);
            // Assert New values using assert function
            try{
                RetailerMDR = [select jj_rb_status__c,jj_rb_Business_Name__c,jj_rb_Rebate_Request_Change_For_ID__c,
                                    jj_rb_SAP_Customer_Number__c,jj_rb_National_Channel_Manager__c,
                                    jj_rb_SAP_Vendor_Number__c,jj_rb_IMS_Customer_Id__c,RecordTypeId 
                                    from jj_rb_Master_Data_Request__c 
                                    where jj_rb_Business_Name__c =: retaileracc.name];
                System.debug('Retailer MDR List  ***** '+RetailerMDR);
                if(RetailerMDR.size() > 0)
                {
                      System.assertEquals('Pharma',RetailerMDR[0].jj_rb_Business_Name__c) ;
                }
                
                HCPMDR = [select jj_rb_status__c,jj_rb_Business_Name__c from jj_rb_Master_Data_Request__c where jj_rb_Business_Name__c =: hcpacc.name];
                //System.debug('**MDR ++ '+HCPMDR[0].jj_rb_Status__c);
                if(HCPMDR.size() > 0)
                {
                    System.assertEquals('Homecare pharma',HCPMDR[0].jj_rb_Business_Name__c) ;
                }
                
                HOSPMDR = [select jj_rb_status__c,jj_rb_Business_Name__c from jj_rb_Master_Data_Request__c where jj_rb_Business_Name__c =: hospacc.name];
                if(HOSPMDR.size()>0)
                {
                    System.assertEquals('Hospital',HOSPMDR[0].jj_rb_Business_Name__c) ;
                    
                }
                productMDR = [select name,jj_rb_Product_Name__c from jj_rb_Master_Data_Request__c where jj_rb_Product_Name__c =: product.name ];
                System.debug('Product ******** '+productMDR);
                if(productMDR.size()>0)
                {
                    System.assertEquals('Digene',productMDR[0].jj_rb_Product_Name__c);
                }
            }
            catch(exception e)
            {
                    System.debug('The following exception has occurred: ' + e.getMessage());   
            }
            // MDR Convert Trigger testing 
           //jj_rb_MDR_proc_test_class.customsStatusCreator('New','New');
           jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
            jj_rb_Master_Data_Request__c retailMDR = RetailerMDR[0];
            retailMDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
            update retailMDR;
            jj_rb_Estimated_Rebate_Accrual__c newERA = jj_rb_Test_MDR_class.ERAcreator(50, product.id);
            newERA.jj_rb_Master_Data_Request__c = retailMDR.Id;
            update newERA;
            jj_rb_Master_Data_Request__c HomecareMDR = HCPMDR[0];
            HomecareMDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
            update HomecareMDR;
            jj_rb_Master_Data_Request__c HospitalMDR = HOSPMDR[0];
            HospitalMDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
            update HospitalMDR;
            jj_rb_Master_Data_Request__c proMDR = productMDR[0];
            proMDR.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved','Approved');
            update proMDR;
            
            //jj_rb_Master_Data_Request__c
            
        }
      	public static void Retialeracc(Account retaileracc,jj_rb_Rebate_Product__c product)
        {
			// ************** Retailer **************************************
            // Call standard controller.
            ApexPages.StandardController sc_customer =  new ApexPages.StandardController(retaileracc);
            ApexPages.StandardController sc_product =  new ApexPages.StandardController(product);
            // Call VF extension
            jj_rb_Rebate_RequestChange_CTE Request_change_customer = new jj_rb_Rebate_RequestChange_CTE(sc_customer);
            jj_rb_Rebate_RequestChange_CTE Request_change_product = new jj_rb_Rebate_RequestChange_CTE(sc_product);
            
            //Call VF pages with Newly inserted Record ID
            PageReference pgref = new PageReference('jj_rb_Rebate_Account_RequestChange');
            pgref.getParameters().put('id',string.valueOf(retaileracc.id));
            test.setCurrentPage(pgref);
            PageReference pageref = new PageReference('jj_rb_Rebate_Product_RequestChange');
            pageref.getParameters().put('id',string.valueOf(product.id));
            Test.setCurrentPage(pageref);
            
            // Call Extension methods
            Request_change_customer.AccountPageLoad();
            Request_change_product.ProductPageLoad();
            Request_change_customer.submitForChange();
            Request_change_product.submitForChange();
            Request_change_product.Cancel();  
        }
        
        public static void Homecareacc(Account hcpacc)
        {
            System.debug('********');

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
            /*PageReference hcppageref = new PageReference('jj_rb_Rebate_Product_RequestChange');
            hcppageref.getParameters().put('id',string.valueOf(product.id));
            Test.setCurrentPage(hcppageref);*/
            
            // Call Extension methods
            hcpRequest_change_customer.AccountPageLoad();
            //hcpRequest_change_product.ProductPageLoad();
            hcpRequest_change_customer.submitForChange();
            //hcpRequest_change_product.Cancel();
            
        }
         public static void hospitalacc(Account hospacc)
         {
             System.debug('********');
             

             
             //************* Hospital ************************************************
            System.debug('hosp in method *** '+hospacc);
             // Call standard controller.
            ApexPages.StandardController hospsc_customer =  new ApexPages.StandardController(hospacc);
             System.debug('STD controller  ** '+hospsc_customer);
            //ApexPages.StandardController hospsc_product =  new ApexPages.StandardController(product);
            // Call VF extension
            jj_rb_Rebate_RequestChange_CTE hospRequest_change_customer = new jj_rb_Rebate_RequestChange_CTE(hospsc_customer);
            //jj_rb_Rebate_RequestChange_CTE hospRequest_change_product = new jj_rb_Rebate_RequestChange_CTE(hospsc_product);
            
            //Call VF pages with Newly inserted Record ID
            PageReference hosppgref = new PageReference('jj_rb_Rebate_Account_RequestChange');
            hosppgref.getParameters().put('id',string.valueOf(hospacc.id));
            test.setCurrentPage(hosppgref);
            /*PageReference hosppageref = new PageReference('jj_rb_Rebate_Product_RequestChange');
            hosppageref.getParameters().put('id',string.valueOf(product.id));
            Test.setCurrentPage(hosppageref);*/
            
            // Call Extension methods
            hospRequest_change_customer.AccountPageLoad();
            //hospRequest_change_product.ProductPageLoad();
            hospRequest_change_customer.submitForChange();
           // hospRequest_change_product.Cancel();
         }
       
    }