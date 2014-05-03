@isTest
public class jj_rb_TestClass
{
    //Account type
     public static  String accountTypeCreator(String name,String Acc_type)
        {
            jj_rb_account_type__c accType= new jj_rb_account_type__c();
            accType.name=name;
            accType.jj_rb_Account_Type__c=Acc_type;
            insert accType;
            return accType.jj_rb_Account_Type__c;        
        }
    // Get Recordtypeid
    public static String getRecordtype(String recortypename,String objectType)
    {
        list<Recordtype> Rectypid = [select id,name from Recordtype where name =: recortypename AND SobjectType=:objectType];
        if(Rectypid.size() != 0)
        {
            return Rectypid[0].id;
        }
        else
            return null;
    }
      
    public static string customsettingCreator(String name,String Status)
    {
        jj_rb_Rebate_Contract_Line_Item_Status__c Statuscustomsetting = new jj_rb_Rebate_Contract_Line_Item_Status__c();
        Statuscustomsetting.name = name;
        Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c = Status;
        insert Statuscustomsetting;
        return Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c;
    }
    //User creator
    public static user userCreator()
    {
        List<Profile> profile = [select id, name from Profile where  name = 'EMEA_iConnect_Sales' limit 1];
        user u = new user();
        u.Alias='tuser';
        u.LastName='userforrebate';
        u.Email='test@sales.com';
        u.username='userforrebate@sales.com';
        u.EmailEncodingKey='UTF-8';
        u.TimeZoneSidKey='Europe/Paris';
        u.LocaleSidKey='en_US';
        u.LanguageLocaleKey='en_US' ;       
        u.ProfileId=profile[0].id;
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert u;
        }           
        return u;
      }
    //Retailer Account       
    public static Account accountCreator()
    {
      
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer','Account');
        Account customer = new Account();
        customer.jj_rb_SAP_Customer_Number__c = '8964';
        customer.jj_rb_National_Channel_Manager__c=testuser[0].id;
        customer.Name = 'Pharma'; 
        customer.jj_rb_SAP_Vendor_Number__c = '5645';  
        customer.Account_Type__c = jj_rb_TestClass.accountTypeCreator('Retailer Type','Retailer');
        customer.jj_rb_IMS_Customer_Id__c='52578';
        customer.RecordTypeId = jj_rb_TestClass.RecordTypeCreator('Account Retailer',rectypid);
        insert customer; 
        return customer;
    } 
    // IMS salesdata creator
    public static jj_rb_IMS_Sales_Data__c imsSalesdataCreator()
    {
        jj_rb_IMS_Sales_Data__c imsdata= new jj_rb_IMS_Sales_Data__c();        
        imsdata.jj_rb_Customer__c=jj_rb_TestClass.accountCreator().id;        
        imsdata.jj_rb_IMS_Customer__c='new customer';
        imsdata.jj_rb_IMS_Customer_Number__c='52578';
        imsdata.jj_rb_IMS_Data_Month__c='February';
        imsdata.jj_rb_IMS_Data_Year__c='2014';
        imsdata.jj_rb_IMS_Product_Number__c='98564';
        imsdata.jj_rb_Product__c=product.id;      
        imsdata.jj_rb_Product_Name__c='ims product';
        imsdata.jj_rb_IMS_Volume__c=500.00;
        insert imsdata;
        return imsdata;
    }
    
    //Homecare Account        
    public static Account homecareaccountCreator()
    {            
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare provider','Account');
        Account homecare = new Account();
        homecare.jj_rb_SAP_Customer_Number__c = '9855';
        homecare.jj_rb_National_Channel_Manager__c=testuser[0].id;
        homecare.Name = 'Homecare pharma';
        homecare.jj_rb_SAP_Vendor_Number__c = '7578';
        homecare.Account_type__c = jj_rb_TestClass.accountTypeCreator('Home Care Provider','Homacare provider');
        homecare.jj_rb_Credit_check_Validity_From__c = Date.today()-1;
        homecare.jj_rb_Credit_check_Validity_End__c = Date.today();
        homecare.RecordTypeId = jj_rb_TestClass.RecordTypeCreator('Account_Homecare',rectypid);
        insert homecare; 
        return homecare;
    }
    
    //Homecare Account after 2 weeks      
    public static Account homecareaccountCreator2weeks()
    {
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare provider','Account');
        Account homecare = new Account();
        homecare.jj_rb_SAP_Customer_Number__c = '14569';
        homecare.jj_rb_National_Channel_Manager__c=testuser[0].id;
        homecare.Name = 'Homecare pharma new';
        homecare.jj_rb_SAP_Vendor_Number__c = '3659';
        homecare.Account_type__c = jj_rb_TestClass.accountTypeCreator('Home Care Provider','Homacare provider');
        homecare.jj_rb_Credit_check_Validity_From__c = Date.today();
        homecare.jj_rb_Credit_check_Validity_End__c = Date.today()+14;
        homecare.RecordTypeId = jj_rb_TestClass.RecordTypeCreator('Account_Homecare',rectypid);
        insert homecare; 
        return homecare;
    }
    
    //Homecare Account after 2 month     
    public static Account homecareaccountCreator2months()
    {
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare provider','Account');
        Account homecare = new Account();
        homecare.jj_rb_SAP_Customer_Number__c = '14569';
        homecare.jj_rb_National_Channel_Manager__c=testuser[0].id;
        homecare.Name = 'Homecare pharma care';
        homecare.jj_rb_SAP_Vendor_Number__c = '3659';
        homecare.Account_type__c = jj_rb_TestClass.accountTypeCreator('Home Care Provider','Homacare provider');
        homecare.jj_rb_Credit_check_Validity_From__c = Date.today();
        homecare.jj_rb_Credit_check_Validity_End__c = Date.today()+60;
        homecare.RecordTypeId = jj_rb_TestClass.RecordTypeCreator('Account_Homecare',rectypid);
        insert homecare; 
        return homecare;
    }
        
    // Hospital Account
    public static Account HospitalCreator()
    {
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1]; 
        String rectypid = jj_rb_TestClass.getRecordtype('Hospital_vod','Account');
        Account customer = new Account();
        customer.jj_rb_National_Channel_Manager__c=jj_rb_TestClass.userCreator().Id;
        customer.Name = 'Hospital'; 
        customer.Account_Type__c = jj_rb_TestClass.accountTypeCreator('Hospital','Hospital');
        customer.jj_rb_NHS_Trust__c = jj_rb_TestClass.NhstrustCreator().id;
        customer.RecordTypeId = jj_rb_TestClass.RecordTypeCreator('Account_Hospital',rectypid);
        insert customer; 
        return customer;
    }
     public static String RecordTypeCreator(String recordTypeName,string RecortypID)
        {
            jj_rb_Master_Data_RecordTypes__c RecordType = new jj_rb_Master_Data_RecordTypes__c();
            RecordType.name = recordTypeName;
            RecordType.jj_rb_RecordTypeId__c = RecortypID;
            insert RecordType;
            return RecordType.jj_rb_RecordTypeId__c;       
        }
    public static jj_rb_Region__c region;
    public static jj_rb_Region__c regionCreator()
    {
        region= new jj_rb_Region__c();
        region.Name='4GEN';
        region.jj_rb_Description__c='General';  
        insert region;
        return region;
    }
    //NHS Trust creator
    public static jj_rb_NHS_Trust__c NhstrustCreator()
    {
        jj_rb_NHS_Trust__c nhstrust= new jj_rb_NHS_Trust__c();
        nhstrust.name = 'Fortis';
        nhstrust.jj_rb_Business_City__c='Banglore';
        nhstrust.jj_rb_Business_Country__c='India';
        nhstrust.jj_rb_Business_Phone__c='96523';
        nhstrust.jj_rb_Business_Postal_Code__c='986531';
        nhstrust.jj_rb_Business_State__c='karnataka';
        nhstrust.jj_rb_Business_Street__c='samllStreet';
        nhstrust.jj_rb_NHS_Trust_ID__c='96531';
        nhstrust.jj_rb_Region__c=jj_rb_TestClass.regionCreator().Id;       
        insert nhstrust;  
        return nhstrust;
    }
    
    //Retailer buying group creator
    public static jj_rb_Retailer_Buying_Group__c retailerBGCreator()
    {
        jj_rb_Retailer_Buying_Group__c retailerBG= new jj_rb_Retailer_Buying_Group__c();                   
        retailerBG.jj_rb_Customer__c=jj_rb_TestClass.accountCreator().id;        
        insert retailerBG;
        return retailerBG;
    }
    
    //Retailer buying group member creator
    public static jj_rb_Retailer_Buying_Group_Member__c retailerBGMemberCreator()
    {
        jj_rb_Retailer_Buying_Group_Member__c retailerBGMember= new jj_rb_Retailer_Buying_Group_Member__c();                   
        retailerBGMember.jj_rb_Customer__c=jj_rb_TestClass.accountCreator().id;   
        retailerBGMember.jj_rb_Lead_Retailers__c=jj_rb_TestClass.retailerBGCreator().id; 
        insert retailerBGMember;        
        return retailerBGMember;
    }
   
    
    // Low vatcode
    public static jj_rb_VAT_Code__c vat; 
    public static jj_rb_VAT_Code__c  lowvatCodeCreator()
    {
        vat= new jj_rb_VAT_Code__c(); 
        vat.name = 'low VAT';
        vat.jj_rb_VAT__c = 5;    
        insert vat;
        return vat;
    }
    //Standard Vatcode 
    public static jj_rb_VAT_Code__c vat1; 
    public static jj_rb_VAT_Code__c  vatCodeCreator()
    {
       vat1= new jj_rb_VAT_Code__c(); 
        vat1.name = 'Standard VAT';
        vat1.jj_rb_VAT__c = 15;    
        insert vat1;
        return vat1;
    }       
        
    //Product creator    Lowvatcodewitn
    public static jj_rb_Rebate_Product__c product;
    public static jj_rb_Rebate_Product__c rebateProductCreator()
    {
       
        product = new jj_rb_Rebate_Product__c();
        product.Name ='Triz';
        product.jj_rb_Description__c ='Triz - For cold';
        product.jj_rb_SAP_Material_Number__c ='98455';
        product.jj_rb_SAP_EAN_Code__c='96850';
        product.jj_rb_IMS_Product_ID__c = '98564';
        product.jj_rb_Unit_of_Measure__c='Pieces';
        product.jj_rb_VAT_Code__c=jj_rb_TestClass.lowvatCodeCreator().id;
        insert product;
        return product;
    }
    //Product creator    Standard vatcodewitn 
    public static jj_rb_Rebate_Product__c product1;
    public static jj_rb_Rebate_Product__c rebateProductCreator1()
    {
        jj_rb_VAT_Code__c vatcode = jj_rb_TestClass.vatCodeCreator();
        product1 = new jj_rb_Rebate_Product__c();
        product1.Name ='citrizen';
        product1.jj_rb_Description__c ='citrizen- For cold';
        product1.jj_rb_SAP_Material_Number__c ='6985';
        product1.jj_rb_SAP_EAN_Code__c='69852';
        product1.jj_rb_IMS_Product_ID__c = '01236';
        product1.jj_rb_Unit_of_Measure__c='Pieces';
        product1.jj_rb_VAT_Code__c=vat1.id;
        insert product1;
        return product1;
    }
     //Rebate Claim creator for february
    public static jj_rb_Rebate_Claim__c rebateClaimCreator()
    {
        jj_rb_Rebate_Claim__c RClaim= new jj_rb_Rebate_Claim__c(); 
        
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Rebate Claim','jj_rb_Rebate_Claim__c');                
        RClaim.jj_rb_Customer__c=jj_rb_TestClass.accountCreator().id;       
        RClaim.jj_rb_Description__c='This is a retailer claim';
        RClaim.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved');
        RClaim.jj_rb_Month__c='february';
        RClaim.jj_rb_year__c='2014'; 
        RClaim.RecordTypeId=jj_rb_TestClass.RecordTypeCreator('Rebate_Claim_Retailer',rectypid);   
        insert RClaim;       
        return RClaim;
    }
    //Rebate claim line item creator
    public static jj_rb_Rebate_Claim_Line_Item__c rebateClaimlineitemCreator()
    {
        jj_rb_Rebate_Claim_Line_Item__c RClaimline= new jj_rb_Rebate_Claim_Line_Item__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Rebate Claim','jj_rb_Rebate_Claim_Line_Item__c');                                   
       
        RClaimline.jj_rb_Rebate_Claim__c=jj_rb_TestClass.rebateClaimCreator().id;
        RClaimline.jj_rb_Rebate_Product__c=product.id; 
        RClaimline.jj_rb_Rebate_Per_Unit__c = 500.00;   
        RClaimline.jj_rb_Quantity__c=50;
        RClaimline.jj_rb_VAT_Code__c=Vat.id; 
        RClaimline.RecordTypeId=jj_rb_TestClass.RecordTypeCreator('Claim_LineItem_Retailer',rectypid);    
        insert RClaimline;
        return RClaimline;
    } 
    //Rebate Claim creator for march
    public static jj_rb_Rebate_Claim__c rebateClaimCreator1()
    {
        jj_rb_Rebate_Claim__c RClaim= new jj_rb_Rebate_Claim__c();   
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Rebate Claim','jj_rb_Rebate_Claim__c');                
        RClaim.jj_rb_Customer__c=jj_rb_TestClass.accountCreator().id;       
        RClaim.jj_rb_Description__c='This is a retailer claim for march ';
        RClaim.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved');
        RClaim.jj_rb_Month__c='march';
        RClaim.jj_rb_year__c='2015'; 
        RClaim.RecordTypeId=jj_rb_TestClass.RecordTypeCreator('Rebate_Claim_Retailer',rectypid);    
        insert RClaim;       
        return RClaim;
    } 
    //Rebate claim line item creator
    public static jj_rb_Rebate_Claim_Line_Item__c rebateClaimlineitemCreator1()
    {
        jj_rb_Rebate_Claim_Line_Item__c RClaimline= new jj_rb_Rebate_Claim_Line_Item__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Rebate Claim','jj_rb_Rebate_Claim_Line_Item__c');                                   
        RClaimline.jj_rb_Rebate_Claim__c=jj_rb_TestClass.rebateClaimCreator1().id;
        RClaimline.jj_rb_Rebate_Product__c=jj_rb_TestClass.rebateProductCreator1().id; 
        RClaimline.jj_rb_Rebate_Per_Unit__c = 1500.00;   
        RClaimline.jj_rb_Quantity__c=150;
        RClaimline.jj_rb_VAT_Code__c=vat1.id; 
        RClaimline.RecordTypeId=jj_rb_TestClass.RecordTypeCreator('Claim_LineItem_Retailer',rectypid);    
        insert RClaimline;
        return RClaimline;
    }
     // Rebate Contract Creator
    public static jj_rb_Rebate_Contract__c rebateContractCreator()
    {
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];
        jj_rb_Rebate_Contract__c RContract= new jj_rb_Rebate_Contract__c();   
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract__c');                                                   
        RContract.jj_rb_Customer__c=jj_rb_TestClass.accountCreator().id; 
        RContract.RecordTypeId =jj_rb_TestClass.RecordTypeCreator('Rebate_Contract_Retailer',rectypid);    
        RContract.jj_rb_Description__c='This is a contract';
        RContract.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved');
        RContract.jj_rb_National_Channel_Manager__c=testuser[0].id;         
        insert RContract;
        return RContract;
    } 
    
    //Rebate Retailer contract Line Item Creator  with enddate<today
    public static jj_rb_Rebate_Contract_Line_Item__c rebateContractLineItemCreator()
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract_Line_Item__c');                                                   
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=jj_rb_TestClass.rebateContractCreator().id;
        Rebatecontractlineitem.RecordTypeId =jj_rb_TestClass.RecordTypeCreator('Contract_LineItem_Retailer',rectypid);    
        Rebatecontractlineitem.jj_rb_Product__c=jj_rb_TestClass.rebateProductCreator().id;
        Rebatecontractlineitem.jj_rb_Start_Date__c=Date.parse('1/2/2014');
        Rebatecontractlineitem.jj_rb_End_Date__c=Date.parse('9/2/2014');
        Rebatecontractlineitem.jj_rb_Rebate__c=500.00;
        Rebatecontractlineitem.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved'); 
        Rebatecontractlineitem.jj_rb_Is_Modified__c=false;      
        insert Rebatecontractlineitem;
        return Rebatecontractlineitem;
    }
    //Rebate Retailer contract Line Item Creator  with enddate>today
    public static jj_rb_Rebate_Contract_Line_Item__c rebateContractLineItemCreator1()
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract_Line_Item__c');                                                   
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=jj_rb_TestClass.rebateContractCreator().id;
        Rebatecontractlineitem.RecordTypeId =jj_rb_TestClass.RecordTypeCreator('Contract_LineItem_Retailer',rectypid);    
        Rebatecontractlineitem.jj_rb_Product__c=jj_rb_TestClass.rebateProductCreator().id;
        Rebatecontractlineitem.jj_rb_Start_Date__c=Date.Today();
        Rebatecontractlineitem.jj_rb_End_Date__c=Date.Today()+5;
        Rebatecontractlineitem.jj_rb_Rebate__c=1500.00;
        Rebatecontractlineitem.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved'); 
        Rebatecontractlineitem.jj_rb_Is_Modified__c=false;      
        insert Rebatecontractlineitem;
        return Rebatecontractlineitem;
    }
    
    
    // HCP Contract Creator
    public static jj_rb_Rebate_Contract__c HCPContractCreator()
    {
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];
        jj_rb_Rebate_Contract__c HCPContract= new jj_rb_Rebate_Contract__c(); 
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract__c');                                                                     
        HCPContract.jj_rb_Product__c=product.id; 
        HCPContract.RecordTypeId =jj_rb_TestClass.RecordTypeCreator('Homecare_Contract',rectypid);    
        HCPContract.jj_rb_Description__c='This is a contract';
        HCPContract.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved');
        HCPContract.jj_rb_National_Channel_Manager__c=testuser[0].id;
        insert HCPContract;
        return HCPContract;
    }
    //HCP contract line item  
    public static jj_rb_Rebate_Contract_Line_Item__c HCPContractLineItemCreator()
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract_Line_Item__c'); 
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=jj_rb_TestClass.HCPContractCreator().id;
        Rebatecontractlineitem.RecordTypeId =jj_rb_TestClass.RecordTypeCreator('Homecare_Contract_Line_Item',rectypid);  
        Rebatecontractlineitem.jj_rb_Region__c=jj_rb_TestClass.regionCreator().id;
        Rebatecontractlineitem.jj_rb_Start_Date__c=Date.parse('1/2/2014');
        Rebatecontractlineitem.jj_rb_End_Date__c=Date.parse('1/3/2014');
        Rebatecontractlineitem.jj_rb_Rebate__c=1400.00;
        Rebatecontractlineitem.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved'); 
        Rebatecontractlineitem.jj_rb_Is_Modified__c=false;      
        insert Rebatecontractlineitem;
        return Rebatecontractlineitem;
    
    }
    
    //HCP CLaim creator
     public static jj_rb_Rebate_Claim__c HCPClaimCreator()
    {        
        jj_rb_Rebate_Claim__c HCPClaim= new jj_rb_Rebate_Claim__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare Claim','jj_rb_Rebate_Claim__c');                    
        HCPClaim.jj_rb_Customer__c=jj_rb_TestClass.homecareaccountCreator().id;
        HCPClaim.jj_rb_Description__c='This is a hcp claim';
        HCPClaim.jj_rb_Status__c=jj_rb_TestClass.customsettingCreator('Approved','Approved'); 
        HCPClaim.jj_rb_Month__c='february';
        HCPClaim.jj_rb_year__c='2014';  
        HCPClaim.RecordTypeId=jj_rb_TestClass.RecordTypeCreator('Claim_Homecare',rectypid); 
        insert HCPClaim;       
        return HCPClaim;
    }
    
    //HCP claim line item creator
    public static   jj_rb_Rebate_Claim_Line_Item__c HCPClaimlineitemCreator()
    {
        jj_rb_Rebate_Claim_Line_Item__c HCPClaimline= new jj_rb_Rebate_Claim_Line_Item__c(); 
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare Claim','jj_rb_Rebate_Claim_Line_Item__c');                   
        HCPClaimline.jj_rb_Rebate_Claim__c=jj_rb_TestClass.HCPClaimCreator().id;
        HCPClaimline.jj_rb_Unit_List_Price__c=1500.00;
        HCPClaimline.jj_rb_Unit_Contract_Price__c=1000.00;      
        HCPClaimline.jj_rb_Rebate_Product__c=product.id; //jj_rb_TestClass.rebateProductCreator().id;
        HCPClaimline.jj_rb_Hospital__c=jj_rb_TestClass.HospitalCreator().id;
        HCPClaimline.jj_rb_Quantity__c=200.00;
        HCPClaimline.jj_rb_VAT_Code__c=vat.id;
        HCPClaimline.RecordTypeId=jj_rb_TestClass.RecordTypeCreator('Claim_LineItem_Homecare',rectypid); 
        insert HCPClaimline;
        return HCPClaimline;
    }
    
    
    
    // Test method for homecare notification class
    static testMethod void jj_rb_Homecare_CreditCheck_notification()
    {
        
        Account hcpaccToday=jj_rb_TestClass.homecareaccountCreator();
        Account hcpacc2weeks=jj_rb_TestClass.homecareaccountCreator2weeks();
        Account hcpacc2months=jj_rb_TestClass.homecareaccountCreator2months();
        test.startTest();
        upsert hcpaccToday;
        upsert hcpacc2weeks;
        upsert hcpacc2months;
        test.stopTest();
        
        jj_rb_Homecare_CreditCheck_notification obj= new jj_rb_Homecare_CreditCheck_notification();
        Database.executeBatch(obj);    
    }       
    // Test method for homecare notification class
    static testMethod void jj_rb_Accrual_Actions()
    {
        jj_rb_RetailerAccrualCalc obj1= new jj_rb_RetailerAccrualCalc();    
        Database.executeBatch(obj1);
        jj_rb_Accrual_Actions ob= new jj_rb_Accrual_Actions();
        jj_rb_Accrual_Actions.executeCalcBatch();
        jj_rb_Accrual_Actions.createBatchReport();
        
    }
    // Customer Master Data Request creator
    /*public static jj_rb_Master_Data_Request__c MDR_CustomerCreator()
    {   
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];     
        jj_rb_Master_Data_Request__c customer = new jj_rb_Master_Data_Request__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Homecare Customer Data Request','jj_rb_Master_Data_Request__c');  
        customer.ownerid=testuser[0].id;       
        customer.jj_rb_Total_Estimat_Rebate_Accrual__c=500.00;
        customer.jj_rb_Business_Name__c = 'Boots Ltd';  
        customer.jj_rb_Status__c = jj_rb_TestClass_Accrual.customsettingCreator('new','new'); 
        customer.jj_rb_SAP_Vendor_Number__c ='65892';
        customer.jj_rb_SAP_Customer_Number__c = '9006'; 
        customer.RecordTypeId =jj_rb_TestClass_Accrual.RecordTypeCreator('Homecare_MDR',rectypid); 
        insert customer;
        return customer;
    }
    //HCP Estimated accrual creator
    public static jj_rb_Estimated_Rebate_Accrual__c estimatedAccrualCreator()
    {        
        jj_rb_Estimated_Rebate_Accrual__c EstimatedAccruals= new jj_rb_Estimated_Rebate_Accrual__c();
        EstimatedAccruals.jj_rb_Account__c=jj_rb_TestClass_Accrual.homecareaccountCreators().id;
        EstimatedAccruals.jj_rb_Rebate_Product__c=jj_rb_TestClass_Accrual.rebateProductCreators().id; 
        EstimatedAccruals.jj_rb_Master_Data_Request__c=jj_rb_TestClass_Accrual.MDR_CustomerCreator().id;
        EstimatedAccruals.jj_rb_Estimated_Accrual__c=5000;
        insert EstimatedAccruals;
        return EstimatedAccruals;
    }
    
     // Retailer Customer Master Data Request creator
    public static jj_rb_Master_Data_Request__c RetailerMDR_CustomerCreator()
    {   
        list<User> testuser = [select id,name from user where userrole.name = 'R8-UK-LCM National Channel Mgr 01' limit 1];     
        jj_rb_Master_Data_Request__c customer = new jj_rb_Master_Data_Request__c();
        String rectypid = jj_rb_TestClass.getRecordtype('Retailer Customer Data Request','jj_rb_Master_Data_Request__c');  
        customer.ownerid=testuser[0].id;       
        customer.jj_rb_Total_Estimat_Rebate_Accrual__c=1500.00;
        customer.jj_rb_Business_Name__c = 'Boots PVT Ltd';  
        customer.jj_rb_Status__c = jj_rb_TestClass.customsettingCreator('new','new'); 
        customer.jj_rb_SAP_Vendor_Number__c ='85236';
        customer.jj_rb_SAP_Customer_Number__c = '4568'; 
        customer.RecordTypeId =jj_rb_TestClass.RecordTypeCreator('Retailer_MDR',rectypid); 
        insert customer;
        return customer;
    }
    //Retailer Estimated accrual creator
    public static jj_rb_Estimated_Rebate_Accrual__c RetailerestimatedAccrualCreator()
    {        
        jj_rb_Estimated_Rebate_Accrual__c EstimatedAccruals= new jj_rb_Estimated_Rebate_Accrual__c();
        EstimatedAccruals.jj_rb_Account__c=TestClass.accountCreator().id;
        EstimatedAccruals.jj_rb_Rebate_Product__c=product.id;//TestClass.rebateProductCreator().id; 
        EstimatedAccruals.jj_rb_Master_Data_Request__c=TestClass.RetailerMDR_CustomerCreator().id;
        EstimatedAccruals.jj_rb_Estimated_Accrual__c=5000;
        insert EstimatedAccruals;
        return EstimatedAccruals;
    }*/
    
    //test method for Rebate claim line item validations
    static testMethod void jj_rb_Rebate_claim_validation()
    {
       
        jj_rb_Rebate_Claim__c claim=jj_rb_TestClass.rebateClaimCreator();
        jj_rb_Rebate_Claim__c claim1=jj_rb_TestClass.rebateClaimCreator1();
        test.startTest();
        upsert claim;
        upsert claim1;        
        test.stopTest();            
    }
    // Test method for Rebateclaimlineitem validation
    static testMethod void jj_rb_Rebate_claimLineitem_validation()
    {
        //Retailer process
        jj_rb_Rebate_Contract__c contracts =jj_rb_TestClass.rebateContractCreator();
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem =jj_rb_TestClass.rebateContractLineItemCreator();
        jj_rb_Rebate_Claim__c claim=jj_rb_TestClass.rebateClaimCreator();
        jj_rb_Rebate_Claim__c claim1=jj_rb_TestClass.rebateClaimCreator1();
        jj_rb_Rebate_Claim_Line_Item__c RClaimline=jj_rb_TestClass.rebateClaimlineitemCreator();
        jj_rb_Rebate_Claim_Line_Item__c RClaimline1=jj_rb_TestClass.rebateClaimlineitemCreator1();
        
        //Home care process
        jj_rb_Rebate_Contract__c HCPcontracts = jj_rb_TestClass.HCPContractCreator();
        jj_rb_Rebate_Contract_Line_Item__c HCPcontractLineItem =jj_rb_TestClass.HCPContractLineItemCreator();
        jj_rb_Rebate_Claim__c hcpclaim= jj_rb_TestClass.HCPClaimCreator();
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem= jj_rb_TestClass.HCPClaimlineitemCreator();
        jj_rb_IMS_Sales_Data__c imsdata=jj_rb_TestClass.imsSalesdataCreator();
        jj_rb_Retailer_Buying_Group__c Retailerbg=jj_rb_TestClass.retailerBGCreator();
        jj_rb_Retailer_Buying_Group_Member__c retailerbgMemberold=jj_rb_TestClass.retailerBGMemberCreator();
        
        jj_rb_NewClaimLineItemOverride newclaim= new  jj_rb_NewClaimLineItemOverride(new ApexPages.StandardController(RClaimline));
        //newclaim.pageLoadExecution();
        
        Test.StartTest();
        upsert contracts;
        upsert RcontractLineItem;      
        upsert claim;
        upsert claim1;
        upsert hcpclaim;
        upsert claimlineitem;
        upsert RClaimline;
        upsert RClaimline1;
        RClaimline.jj_rb_Calculated_rebate_price__c=RcontractLineItem.jj_rb_Rebate__c;
        RClaimline.jj_rb_Assoc_Contract_Line_Item__c=RcontractLineItem.id;
        RClaimline.jj_rb_Calculated_quantity__c=imsdata.jj_rb_IMS_Volume__c;
        RClaimline.jj_rb_Assoc_IMS_Sales_Data__c=imsdata.id;    
        RClaimline.jj_rb_Tolerance_Failed_Qty__c=true;
        update RClaimline;
        Test.StopTest();           
    }
    // testmethod for jj_rb_RebateAccrualCalcScheduler class
    
   /* static testMethod void RebateAccrualCalcScheduler()
    {
        Test.startTest();
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('testScheduledApex', CRON_EXP, new jj_rb_RebateAccrualCalcScheduler() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }*/
    
    // testmethod for jj_rb_avgQuantityCalcSchedulerclass
    
    /*static testMethod void avgQuantityCalcScheduler()
    {
        Test.startTest();
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('testScheduledApex', CRON_EXP, new jj_rb_avgQuantityCalcScheduler() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }*/
        
    
     
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
              


}