@isTest
public class jj_rb_TestClass_Accrual
{ 
/*	    
     public static user testUser()
     {
        User test_user = jj_rb_TestClass.getRebateUser(); 
        return test_user;
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
     //Retailer Account       
    public static Account accountCreator()
    {      
        
        
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer','Account');
        Account customer = new Account();
        customer.jj_rb_SAP_Customer_Number__c = '8964';
        customer.jj_rb_National_Channel_Manager__c=jj_rb_TestClass_Accrual.testUser().id;
        customer.Name = 'Pharmas'; 
        customer.jj_rb_SAP_Vendor_Number__c = '5645';  
        customer.Account_Type__c = jj_rb_TestClass_Accrual.accountTypeCreator('Retailer Type','Retailer');
        customer.jj_rb_IMS_Customer_Id__c='52578';
        customer.RecordTypeId = jj_rb_TestClass_Accrual.RecordTypeCreator('Account Retailer',rectypid);
        insert customer; 
        return customer;
    } 
      //Homecare Account        
    public static Account homecareaccountCreators()
    {            
        
       
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Homecare provider','Account');
        Account homecare = new Account();
        homecare.jj_rb_SAP_Customer_Number__c = '9855';
        homecare.jj_rb_National_Channel_Manager__c=jj_rb_TestClass_Accrual.testUser().id;
        homecare.Name = 'Homecare pharma';
        homecare.jj_rb_SAP_Vendor_Number__c = '7578';
        homecare.Account_type__c = jj_rb_TestClass_Accrual.accountTypeCreator('Home Care Provider','Homacare provider');
        homecare.jj_rb_Credit_check_Validity_From__c = Date.today()-45;
        homecare.jj_rb_Credit_check_Validity_End__c = Date.today()-10;
        homecare.RecordTypeId = jj_rb_TestClass_Accrual.RecordTypeCreator('Account_Homecare',rectypid);
        insert homecare; 
        return homecare;
    }
      // Hospital Account
    public static Account HospitalCreators()
    {
       
        
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Hospital_vod','Account');
        Account customer = new Account();
        customer.jj_rb_National_Channel_Manager__c=jj_rb_TestClass_Accrual.testUser().id;
        customer.Name = 'Hospital'; 
        customer.Account_Type__c = jj_rb_TestClass_Accrual.accountTypeCreator('Hospital','Hospital');
        customer.jj_rb_NHS_Trust__c = jj_rb_TestClass_Accrual.NhstrustCreators().id;
        customer.RecordTypeId = jj_rb_TestClass_Accrual.RecordTypeCreator('Account_Hospital',rectypid);
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
    public static jj_rb_NHS_Trust__c NhstrustCreators()
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
        nhstrust.jj_rb_Region__c=jj_rb_TestClass_Accrual.regionCreator().Id;       
        insert nhstrust;  
        return nhstrust;
    }
      
    // Low vatcode
    public static jj_rb_VAT_Code__c vat; 
    public static jj_rb_VAT_Code__c  lowvatCodeCreators()
    {
        vat= new jj_rb_VAT_Code__c(); 
        vat.name = 'low VAT';
        vat.jj_rb_VAT__c = 5;    
        insert vat;
        return vat;
    }
     // Standard vatcode
    public static jj_rb_VAT_Code__c vat1; 
    public static jj_rb_VAT_Code__c  standardvatCodeCreators()
    {
        vat1= new jj_rb_VAT_Code__c(); 
        vat1.name = 'Standard VAT';
        vat1.jj_rb_VAT__c = 15;    
        insert vat1;
        return vat1;
    }
    
     //Product creator    Standard vatcode
    public static jj_rb_Rebate_Product__c product1;
    public static jj_rb_Rebate_Product__c rebateProductCreator()
    {       
        product1 = new jj_rb_Rebate_Product__c();
        product1.Name ='Triz150';
        product1.jj_rb_Description__c ='Triz - For cold and fever';
        product1.jj_rb_SAP_Material_Number__c ='9845511';
        product1.jj_rb_SAP_EAN_Code__c='96850';
        product1.jj_rb_IMS_Product_ID__c = '98564';
        product1.jj_rb_Unit_of_Measure__c='Pieces';
        product1.jj_rb_VAT_Code__c=jj_rb_TestClass_Accrual.standardvatCodeCreators().id;
        insert product1;
        return product1;
    }
    //Product creator    Lowvatcodewitn
    public static jj_rb_Rebate_Product__c product;
    public static jj_rb_Rebate_Product__c rebateProductCreators()
    {       
        product = new jj_rb_Rebate_Product__c();
        product.Name ='Triz';
        product.jj_rb_Description__c ='Triz - For cold';
        product.jj_rb_SAP_Material_Number__c ='98455';
        product.jj_rb_SAP_EAN_Code__c='96850';
        product.jj_rb_IMS_Product_ID__c = '98564';
        product.jj_rb_Unit_of_Measure__c='Pieces';
        product.jj_rb_VAT_Code__c=jj_rb_TestClass_Accrual.lowvatCodeCreators().id;
        insert product;
        return product;
    }
      
    //HCP CLaim creator
     public static jj_rb_Rebate_Claim__c HCPClaimCreators()
    {        
        jj_rb_Rebate_Claim__c HCPClaim= new jj_rb_Rebate_Claim__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Homecare Claim','jj_rb_Rebate_Claim__c');                    
        HCPClaim.jj_rb_Customer__c=jj_rb_TestClass_Accrual.homecareaccountCreators().id;
        HCPClaim.jj_rb_Description__c='This is a hcp claim';
        HCPClaim.jj_rb_Status__c=jj_rb_TestClass_Accrual.customsettingCreator('Approved','Approved'); 
        HCPClaim.jj_rb_Month__c='february';
        HCPClaim.jj_rb_year__c='2014';  
        HCPClaim.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Claim_Homecare',rectypid); 
        insert HCPClaim;       
        return HCPClaim;
    }
    
    //HCP claim line item creator
    public static   jj_rb_Rebate_Claim_Line_Item__c HCPClaimlineitemCreators()
    {
        jj_rb_Rebate_Claim_Line_Item__c HCPClaimline= new jj_rb_Rebate_Claim_Line_Item__c(); 
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Homecare Claim','jj_rb_Rebate_Claim_Line_Item__c');                   
        HCPClaimline.jj_rb_Rebate_Claim__c=jj_rb_TestClass_Accrual.HCPClaimCreators().id;
        HCPClaimline.jj_rb_Unit_List_Price__c=1500.00;
        HCPClaimline.jj_rb_Unit_Contract_Price__c=1000.00;      
        HCPClaimline.jj_rb_Rebate_Product__c=Product.id;
        HCPClaimline.jj_rb_Hospital__c=jj_rb_TestClass_Accrual.HospitalCreators().id;
        HCPClaimline.jj_rb_Quantity__c=200.00;
        HCPClaimline.jj_rb_VAT_Code__c=vat.id;
        HCPClaimline.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Claim_LineItem_Homecare',rectypid); 
        insert HCPClaimline;
        return HCPClaimline;
    }
    
    //HCP claim line item creator
    public static   jj_rb_Rebate_Claim_Line_Item__c HCPClaimlineitemCreator()
    {
        jj_rb_Rebate_Claim_Line_Item__c HCPClaimline= new jj_rb_Rebate_Claim_Line_Item__c(); 
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Homecare Claim','jj_rb_Rebate_Claim_Line_Item__c');                   
        HCPClaimline.jj_rb_Rebate_Claim__c=jj_rb_TestClass_Accrual.HCPClaimCreators().id;
        HCPClaimline.jj_rb_Unit_List_Price__c=1500.00;
        HCPClaimline.jj_rb_Unit_Contract_Price__c=1000.00;      
        HCPClaimline.jj_rb_Rebate_Product__c=jj_rb_TestClass_Accrual.rebateProductCreator().id; 
        HCPClaimline.jj_rb_Hospital__c=jj_rb_TestClass_Accrual.HospitalCreators().id;
        HCPClaimline.jj_rb_Quantity__c=200.00;
        HCPClaimline.jj_rb_VAT_Code__c=vat1.id;
        HCPClaimline.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Claim_LineItem_Homecare',rectypid); 
        insert HCPClaimline;
        return HCPClaimline;
    }
    // Customer Master Data Request creator
    public static jj_rb_Master_Data_Request__c MDR_CustomerCreator()
    {   
        
       
        jj_rb_Master_Data_Request__c customer = new jj_rb_Master_Data_Request__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Homecare Customer Data Request','jj_rb_Master_Data_Request__c');  
        customer.ownerid=jj_rb_TestClass_Accrual.testUser().id;
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
    // Rebate Contract Creator
    public static jj_rb_Rebate_Contract__c rebateContractCreator()
    {
        
        
        jj_rb_Rebate_Contract__c RContract= new jj_rb_Rebate_Contract__c();   
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract__c');                                                   
        RContract.jj_rb_Customer__c=jj_rb_TestClass_Accrual.accountCreator().id; 
        RContract.RecordTypeId =jj_rb_TestClass_Accrual.RecordTypeCreator('Rebate_Contract_Retailer',rectypid);    
        RContract.jj_rb_Description__c='This is a contract';
        RContract.jj_rb_Status__c=jj_rb_TestClass_Accrual.customsettingCreator('Approved','Approved');
        RContract.jj_rb_National_Channel_Manager__c=jj_rb_TestClass_Accrual.testUser().id;
        insert RContract;
        return RContract;
    } 
   //Rebate Retailer contract Line Item Creator  with enddate>today
    public static jj_rb_Rebate_Contract_Line_Item__c rebateContractLineItemCreator1()
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract_Line_Item__c');                                                   
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=jj_rb_TestClass_Accrual.rebateContractCreator().id;
        Rebatecontractlineitem.RecordTypeId =jj_rb_TestClass_Accrual.RecordTypeCreator('Contract_LineItem_Retailer',rectypid);    
        Rebatecontractlineitem.jj_rb_Product__c=jj_rb_TestClass_Accrual.rebateProductCreators().id;
        Rebatecontractlineitem.jj_rb_Start_Date__c=Date.Today()-1;
        Rebatecontractlineitem.jj_rb_End_Date__c=Date.Today();
        Rebatecontractlineitem.jj_rb_Rebate__c=1500.00;
        Rebatecontractlineitem.jj_rb_Status__c=jj_rb_TestClass_Accrual.customsettingCreator('Approved','Approved'); 
        Rebatecontractlineitem.jj_rb_Is_Modified__c=false;      
        insert Rebatecontractlineitem;
        return Rebatecontractlineitem;
    }


    
    //tolerance creator
     public static jj_rb_Tolerance__c toleranceCreator()
    {
       jj_rb_Tolerance__c tolerance= new jj_rb_Tolerance__c();
        tolerance.jj_rb_Customer__c=jj_rb_TestClass_Accrual.homecareaccountCreators().id;
        tolerance.jj_rb_Product__c=product1.id; 
        tolerance.jj_rb_Quantity_Tolerance__c=100;  
        tolerance.jj_rb_Price_Tolerance__c=20;
        tolerance.jj_rb_Average_Quantity__c=0;
        insert tolerance;
        return tolerance;
    }*/   
    // Test method for avgQuantityCalc class
    /*static testMethod void jj_rb_avgQuantityCalc()
    {
        //User rebateUser = jj_rb_Test_BaseClass.setupUser();       
        test.StartTest();
        system.runAs(rebateUser) { 
        jj_rb_Test_BaseClass.setupRebateAnalystUser(rebateUser);     
        
        jj_rb_Rebate_Product__c products=product;
        jj_rb_Rebate_Claim__c hcpclaim= jj_rb_TestClass_Accrual.HCPClaimCreators();
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem= jj_rb_TestClass_Accrual.HCPClaimlineitemCreator();       
        
        List<jj_rb_Rebate_Claim__c> claimlist=[SELECT Id,Name,jj_rb_Claim_Date__c,jj_rb_Customer__c,
                                    (select id, name,jj_rb_Rebate_Product__r.name,jj_rb_Rebate_Product__c,
                                    jj_rb_Quantity__c from Rebate_Claim_Line_Items__r) FROM jj_rb_Rebate_Claim__c 
                                    where id=:hcpclaim.id];
                
        
        jj_rb_Tolerance__c tolerance= jj_rb_TestClass_Accrual.ToleranceCreator();       
       
        
        jj_rb_avgQuantityCalc obj= new jj_rb_avgQuantityCalc();
        Database.executeBatch(obj);
        obj.start(null);
        obj.execute(null,claimlist);
        obj.finish(null); 
        }
        test.StopTest(); 
    }*//*
      // Test method for class
    static testMethod void HCPAccrualCalc()
    {
        User testusers=testuser();      
        test.StartTest();
        system.runAs(testusers) { 
        jj_rb_Test_BaseClass.setupRebateAnalystUser(testusers); 
          
        Account acc=jj_rb_TestClass_Accrual.homecareaccountCreators();        
        jj_rb_Estimated_Rebate_Accrual__c estdAccrual=jj_rb_TestClass_Accrual.estimatedAccrualCreator();
        jj_rb_Rebate_Claim__c hcpclaim= jj_rb_TestClass_Accrual.HCPClaimCreators();
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem= jj_rb_TestClass_Accrual.HCPClaimlineitemCreators();
        List<jj_rb_Rebate_Claim__c> claimslists= [SELECT Id, Name, jj_rb_Claim_Date__c, jj_rb_Customer__c, 
                                                (select id, name, jj_rb_Rebate_Product__c, jj_rb_Quantity__c,
                                                 jj_rb_Net_Rebate__c from Rebate_Claim_Line_Items__r) 
                                                 FROM jj_rb_Rebate_Claim__c 
                                                 where id=:hcpclaim.id];
        
        List<account> acclist=[SELECT Id,jj_rb_IMS_Customer_Id__c,Account_Type__c,jj_rb_National_Channel_Manager__c,jj_rb_SAP_Customer_Number__c,Name,RecordTypeId FROM Account];
        jj_rb_HCPAccrualcalc obj= new jj_rb_HCPAccrualcalc();
        Database.executeBatch(obj);
        obj.start(null);
        
        jj_rb_Rebate_Accrual__c hcpaccrual=jj_rb_TestClass_Accrual.HCPAccrualCreator();
        jj_rb_Rebate_Accrual_Line_Item__c hcpaccruallineitem=jj_rb_TestClass_Accrual.HCPAccrualLineitemCreator();
        obj.execute(null,acclist);
        obj.finish(null);               
        jj_rb_RetailerAccrualCalc obj1= new jj_rb_RetailerAccrualCalc();    
        Database.executeBatch(obj1);
        }
        Test.stopTest();  
    }
    
      // Retailer Customer Master Data Request creator
    public static jj_rb_Master_Data_Request__c RetailerMDR_CustomerCreator()
    {   
        
        jj_rb_Master_Data_Request__c customer = new jj_rb_Master_Data_Request__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer Customer Data Request','jj_rb_Master_Data_Request__c');  
        customer.ownerid=jj_rb_TestClass_Accrual.testUser().id;
        customer.jj_rb_Total_Estimat_Rebate_Accrual__c=1500.00;
        customer.jj_rb_Business_Name__c = 'Boots PVT Ltd';  
        customer.jj_rb_Status__c = jj_rb_TestClass_Accrual.customsettingCreator('Approved','Approved'); 
        customer.jj_rb_SAP_Vendor_Number__c ='85236';
        customer.jj_rb_SAP_Customer_Number__c = '4568';
        customer.jj_rb_IMS_Customer_Id__c='52578';
        customer.RecordTypeId =jj_rb_TestClass_Accrual.RecordTypeCreator('Retailer_MDR',rectypid); 
        insert customer;
        return customer;
    }
    
        
     //Rebate Claim creator for february
    public static jj_rb_Rebate_Claim__c rebateClaimCreator()
    {
        jj_rb_Rebate_Claim__c RClaim= new jj_rb_Rebate_Claim__c(); 
        
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer Rebate Claim','jj_rb_Rebate_Claim__c');                
        RClaim.jj_rb_Customer__c=jj_rb_TestClass_Accrual.accountCreator().id;       
        RClaim.jj_rb_Description__c='This is a retailer claim';
        RClaim.jj_rb_Status__c=jj_rb_TestClass_Accrual.customsettingCreator('Approved','Approved');
        RClaim.jj_rb_Month__c='february';
        RClaim.jj_rb_year__c='2014'; 
        RClaim.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Rebate_Claim_Retailer',rectypid);   
        insert RClaim;       
        return RClaim;
    }
    //Rebate claim line item creator
    public static jj_rb_Rebate_Claim_Line_Item__c rebateClaimlineitemCreator()
    {
        jj_rb_Rebate_Claim_Line_Item__c RClaimline= new jj_rb_Rebate_Claim_Line_Item__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer Rebate Claim','jj_rb_Rebate_Claim_Line_Item__c');                                   
       
        RClaimline.jj_rb_Rebate_Claim__c=jj_rb_TestClass_Accrual.rebateClaimCreator().id;
        RClaimline.jj_rb_Rebate_Product__c=product.id; 
        RClaimline.jj_rb_Rebate_Per_Unit__c = 500.00;   
        RClaimline.jj_rb_Quantity__c=50;
        RClaimline.jj_rb_VAT_Code__c=Vat.id; 
        RClaimline.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Claim_LineItem_Retailer',rectypid);    
        insert RClaimline;
        return RClaimline;
    }
    //Retailer Estimated accrual creator
    public static jj_rb_Estimated_Rebate_Accrual__c RetailerestimatedAccrualCreator()
    {        
        jj_rb_Estimated_Rebate_Accrual__c EstimatedAccruals= new jj_rb_Estimated_Rebate_Accrual__c();
        EstimatedAccruals.jj_rb_Account__c=jj_rb_TestClass_Accrual.rebateContractCreator().jj_rb_customer__c;
        EstimatedAccruals.jj_rb_Rebate_Product__c=product.id; 
        EstimatedAccruals.jj_rb_Master_Data_Request__c=jj_rb_TestClass_Accrual.RetailerMDR_CustomerCreator().id;
        EstimatedAccruals.jj_rb_Estimated_Accrual__c=5000.00;
        insert EstimatedAccruals;
        return EstimatedAccruals;
    }
    
    // Test method for RetailerAccrualCalc class
    /*static testMethod void RetailerAccrualCalc()
    { 
        Account a=jj_rb_TestClass_Accrual.accountCreator();       
        jj_rb_Rebate_Contract__c Rcontracts = jj_rb_TestClass_Accrual.rebateContractCreator();
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem =jj_rb_TestClass_Accrual.rebateContractLineItemCreator1();
        
        List<jj_rb_Rebate_Contract_Line_Item__c>  listcons=[SELECT jj_rb_Rebate_Contract__r.jj_rb_Customer__c,jj_rb_Rebate_Contract__r.recordtypeid 
                                    FROM jj_rb_Rebate_Contract_Line_Item__c where jj_rb_End_Date__c >= today
                                    and jj_rb_Rebate_Contract__r.jj_rb_Customer__c != null];                                    
        
        System.assertEquals(1,listcons.size()); 
        
        jj_rb_Estimated_Rebate_Accrual__c estdAccruals=jj_rb_TestClass_Accrual.RetailerestimatedAccrualCreator();
       
        jj_rb_Rebate_Claim__c claims=jj_rb_TestClass_Accrual.rebateClaimCreator(); 
        jj_rb_Rebate_Claim_Line_Item__c RClaimlines=jj_rb_TestClass_Accrual.rebateClaimlineitemCreator();   
        
        List<jj_rb_Estimated_Rebate_Accrual__c> estimatedAccruallist=[select Id, Name, jj_rb_Estimated_Accrual__c,
                                                                    jj_rb_Rebate_Product__c, jj_rb_Account__c
                                                                    from jj_rb_Estimated_Rebate_Accrual__c
                                                                    where jj_rb_Account__c=:RcontractLineItem.jj_rb_Rebate_Contract__r.jj_rb_Customer__c];
                                                                      
        
        List<jj_rb_Rebate_Claim__c> claimlistretailer=[SELECT Id, Name, jj_rb_Claim_Date__c, jj_rb_Customer__c, 
                                                (select id, name, jj_rb_Rebate_Product__c, jj_rb_Quantity__c,
                                                        jj_rb_Net_Rebate__c from Rebate_Claim_Line_Items__r) 
                                                    FROM jj_rb_Rebate_Claim__c 
                                                    where id=:claims.id];
                                                           
        jj_rb_RetailerAccrualCalc obj= new jj_rb_RetailerAccrualCalc();    
        Database.executeBatch(obj);
        obj.start(null);
        obj.execute(null,listcons);
        obj.finish(null); 
    } */   /*
    //retailer Accrual Record creator
    public static jj_rb_Rebate_Accrual__c rebateAccrualCreator()
    {
               
        jj_rb_Rebate_Accrual__c accrualRecord= new jj_rb_Rebate_Accrual__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer Accrual','jj_rb_Rebate_Accrual__c');         
        accrualRecord.jj_rb_Customer__c=jj_rb_TestClass_Accrual.accountCreator().id;         
        accrualRecord.jj_rb_Month__c='May';
        accrualRecord.jj_rb_Customer_NCM__c=jj_rb_TestClass_Accrual.testUser().id;
        accrualRecord.jj_rb_Year__c='2014';
        accrualRecord.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Accrual_Retailer',rectypid); 
        accrualRecord.jj_rb_Status__c=jj_rb_TestClass_Accrual.customsettingCreator('Approved','Approved');
        insert accrualRecord;
        return accrualRecord;
    }
     //Homecare Accrual Record creator
    public static jj_rb_Rebate_Accrual__c HcpAccrualCreator()
    {
        
        jj_rb_Rebate_Accrual__c accrualRecord= new jj_rb_Rebate_Accrual__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Homecare Accrual','jj_rb_Rebate_Accrual__c');         
        accrualRecord.jj_rb_Customer__c=jj_rb_TestClass_Accrual.accountCreator().id;         
        accrualRecord.jj_rb_Month__c='May';
        accrualRecord.jj_rb_Customer_NCM__c=jj_rb_TestClass_Accrual.testUser().id;
        accrualRecord.jj_rb_Year__c='2014';
        accrualRecord.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Accrual_Homecare',rectypid); 
        accrualRecord.jj_rb_Status__c=jj_rb_TestClass_Accrual.customsettingCreator('Approved','Approved');
        insert accrualRecord;
        return accrualRecord;
    }
    // retailer accrual line item creator
    public static jj_rb_Rebate_Accrual_Line_Item__c rebateAccrualLineitemCreator()
    {
        jj_rb_Rebate_Accrual_Line_Item__c accrualLineitem= new jj_rb_Rebate_Accrual_Line_Item__c(); 
        accrualLineitem.jj_rb_Volume__c=500.00;
        accrualLineitem.jj_rb_Rebate_Accrual__c=jj_rb_TestClass_Accrual.rebateAccrualCreator().id;
        accrualLineitem.jj_rb_Net_Rebate_Accrual_Amount__c=1500.00;
        accrualLineitem.jj_rb_Product__c=jj_rb_TestClass_Accrual.rebateProductCreators().id;    
        accrualLineitem.Rebate_Adjustment__c=1000.00;      
        insert accrualLineitem;
        return accrualLineitem;
    }
     // HCP accrual line item creator
    public static jj_rb_Rebate_Accrual_Line_Item__c HCPAccrualLineitemCreator()
    {
        jj_rb_Rebate_Accrual_Line_Item__c accrualLineitem= new jj_rb_Rebate_Accrual_Line_Item__c(); 
        accrualLineitem.jj_rb_Volume__c=1500.00;
        accrualLineitem.jj_rb_Rebate_Accrual__c=jj_rb_TestClass_Accrual.rebateAccrualCreator().id;
        accrualLineitem.jj_rb_Net_Rebate_Accrual_Amount__c=2500.00;
        accrualLineitem.jj_rb_Product__c=product.id;     
        accrualLineitem.Rebate_Adjustment__c=15000.00;      
        insert accrualLineitem;
        return accrualLineitem;
    }
    //Retailer Accrual report creator
     public static jj_rb_Rebate_Accrual_Report__c rebateAccrualReportCreator()
    {
        jj_rb_Rebate_Accrual_Report__c accrualReport= new jj_rb_Rebate_Accrual_Report__c();
        String rectypid = jj_rb_TestClass_Accrual.getRecordtype('Retailer report','jj_rb_Rebate_Accrual_Report__c'); 
        accrualReport.jj_rb_Completed__c=True;
        accrualReport.jj_rb_Month__c=DateTime.now().format('MM');
        accrualReport.jj_rb_Year__c=DateTime.now().format('YYYY');    
        accrualReport.RecordTypeId=jj_rb_TestClass_Accrual.RecordTypeCreator('Accrual_Report_Retailer',rectypid); 
        insert accrualReport;
        return accrualReport;
    }
   
    // Retailer Accrual report lineitem creator
     public static jj_rb_Rebate_Accrual_Report_Line_Item__c rebateAccrualReportlineitemCreator()
    {
        jj_rb_Rebate_Accrual_Report_Line_Item__c accrualReportlineitem= new jj_rb_Rebate_Accrual_Report_Line_Item__c(); 
        accrualReportlineitem.jj_rb_Net_Rebate__c=1500.00;
        accrualReportlineitem.jj_rb_Quantity__c=50.00;
        accrualReportlineitem.jj_rb_Rebate_Accrual_Report__c=jj_rb_TestClass_Accrual.rebateAccrualReportCreator().id;  
        accrualReportlineitem.jj_rb_Rebate_Product__c=product.id;              
        insert accrualReportlineitem;
        return accrualReportlineitem;
    }
    
     // Test method for jj_rb_Accrual_Report_Generation class
    static testMethod void jj_rb_Accrual_Report_Generation()
    {   
        User testusers=testuser();      
        test.StartTest();
        system.runAs(testusers) { 
        jj_rb_Test_BaseClass.setupRebateAnalystUser(testusers); 
             
        //Retailer accrual records
        jj_rb_Rebate_Accrual__c retaileraccrual=jj_rb_TestClass_Accrual.rebateAccrualCreator();
        jj_rb_Rebate_Accrual_Line_Item__c Retaileraccruallineitem=jj_rb_TestClass_Accrual.rebateAccrualLineitemCreator();
        //Homecare accrual records
        jj_rb_Rebate_Accrual__c hcpaccrual=jj_rb_TestClass_Accrual.HCPAccrualCreator();
        jj_rb_Rebate_Accrual_Line_Item__c hcpaccruallineitem=jj_rb_TestClass_Accrual.HCPAccrualLineitemCreator();
         
        
        List<jj_rb_Rebate_Accrual_Line_Item__c> accruallinelist=[select Id, jj_rb_Product__c, jj_rb_Net_Rebate_Accrual_After_Adj__c,
                     jj_rb_Volume__c,jj_rb_Rebate_Accrual__r.RecordTypeId from jj_rb_Rebate_Accrual_Line_Item__c]; 
                     
               
        jj_rb_Accrual_Report_Generation obj= new jj_rb_Accrual_Report_Generation();
        Database.executeBatch(obj); 
        obj.start(null);
        obj.execute(null,accruallinelist);
        //Retailer report records
        jj_rb_Rebate_Accrual_Report__c Retaileraccrualreport=jj_rb_TestClass_Accrual.rebateAccrualReportCreator();
        jj_rb_Rebate_Accrual_Report_Line_Item__c Retaileraccrualreportlineitem=jj_rb_TestClass_Accrual.rebateAccrualReportlineitemCreator();
        obj.finish(null);
        }
        test.stopTest();
    }
    
    
    
*/

}