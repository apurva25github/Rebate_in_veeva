@isTest
public class jj_rb_Rebate_TestClass{
/**********************************************************************
 Name: Rebate_Claim_validation Test Class
 Capgemini India Ltd 

 Purpose:
  It is used for Testing the Rebate_Contract and Rebate_contract_line_items Validations

 History:
 VERSION      AUTHOR            DATE              DETAIL                                 
 1.0      MangaDivya Kasani     21/2/2014       Created class

***********************************************************************/

    // Account Creator
    public static Account accountCreator(String SAPCustNo,String Name,string Phone,String email, String SAPvendor, decimal Rebate_Accrual,String street, string city,string state,string country,string postal_code)
    {
        Account customer = new Account();
        customer.jj_rb_SAP_Customer_Number__c = SAPCustNo;
        customer.Name = Name;
        customer.Phone = phone;
        customer.jj_rb_Email__c = email;  
        customer.jj_rb_SAP_Vendor_Number__c = SAPvendor;
        //customer.jj_rb_Estimated_Rebate_Accrual__c = Rebate_Accrual;
        customer.BillingState = state;
        customer.BillingStreet = street;
        customer.BillingCity = city;
        customer.BillingCountry = country;
        customer.BillingPostalCode = postal_code;
        //customer.ParentId = 
        insert customer;
        return customer;
    }
    
    // Rebate Contract Creator
    public static jj_rb_Rebate_Contract__c rebateContractCreator(Id accountID, string Description, string status, Id ncmid)
    {
        jj_rb_Rebate_Contract__c RContract= new jj_rb_Rebate_Contract__c();                   
        RContract.jj_rb_Customer__c=accountId;
        RContract.jj_rb_Description__c=Description;
        RContract.jj_rb_Status__c=status;
        RContract.jj_rb_National_Channel_Manager__c=ncmid;         
        insert RContract;
        return RContract;
    }
    
    
    //Rebate Claim creator
    public static jj_rb_Rebate_Claim__c rebateClaimCreator(Id accountID, string Description, string status, String month,String year)
    {
        jj_rb_Rebate_Claim__c RClaim= new jj_rb_Rebate_Claim__c();                   
        RClaim.jj_rb_Customer__c=accountId;
        RClaim.jj_rb_Description__c=Description;
        RClaim.jj_rb_Status__c=status;
        RClaim.jj_rb_Month__c=month;
        RClaim.jj_rb_year__c=year;         
        insert RClaim;
        return RClaim;
    }
    
    //
    public static   jj_rb_Rebate_Claim_Line_Item__c rebateClaimlineitemCreator(Id cid, Id Productid, Decimal Rebate, Decimal quantity,
                                                                 Id vatid )
    {
        jj_rb_Rebate_Claim_Line_Item__c RClaimline= new jj_rb_Rebate_Claim_Line_Item__c();                   
        RClaimline.jj_rb_Rebate_Claim__c=cId;
        RClaimline.jj_rb_Rebate_Product__c=Productid;
        RClaimline.jj_rb_Rebate_Per_Unit__c=Rebate;
        RClaimline.jj_rb_Quantity__c=quantity;
        RClaimline.jj_rb_VAT_Code__c=vatid; 
        //RClaimline.jj_rb_Calculated_rebate_price__c=calRebate;
       // RClaimline.jj_rb_Calculated_quantity__c=calQuantity;
       // RClaimline.jj_rb_DIfference_in_rebate_price__c=diffRebate;
        //RClaimline.jj_rb_Difference_in_Quantity__c=DiffQuantity ;        
        insert RClaimline;
        return RClaimline;
    }
    
    //Rebate Product Creator
    public static jj_rb_Rebate_Product__c rebateProductCreator(String name,String Description, String SapMaterial, String skunumber,String unit,string IMSProduct,ID vatid)
    {
        jj_rb_Rebate_Product__c product= new jj_rb_Rebate_Product__c();
        product.Name=name;
        product.jj_rb_Description__c=Description;
        product.jj_rb_SAP_Material_Number__c =SapMaterial;
        product.jj_rb_SAP_EAN_Code__c=skunumber;
        product.jj_rb_IMS_Product_ID__c = IMSProduct;
        product.jj_rb_Unit_of_Measure__c=unit;
        product.jj_rb_VAT_Code__c=vatid;
        insert product;
        return product;
    }
    //Rebate contract Line Item Creator  
    public static jj_rb_Rebate_Contract_Line_Item__c rebateContractLineItemCreator(Id customerID, Id productID, Date sdate,Date edate,Decimal rebate,String status, boolean ismodified)
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=customerID;
        Rebatecontractlineitem.jj_rb_Product__c=productID;
        Rebatecontractlineitem.jj_rb_Start_Date__c=sdate;
        Rebatecontractlineitem.jj_rb_End_Date__c=edate;
        Rebatecontractlineitem.jj_rb_Rebate__c=rebate;
        Rebatecontractlineitem.jj_rb_Status__c=status;  
        Rebatecontractlineitem.jj_rb_Is_Modified__c=ismodified;      
        insert Rebatecontractlineitem;
        return Rebatecontractlineitem;
    }
    // Vat code creator
    public static jj_rb_VAT_Code__c vatCodeCreator(Decimal vatpercent,String name)
    {
        jj_rb_VAT_Code__c vat= new jj_rb_VAT_Code__c(); 
        vat.name= name;
        vat.jj_rb_VAT__c=vatpercent;    
        insert vat;
        return vat;
    }
    
    // IMS salesdata creator
    public static jj_rb_IMS_Sales_Data__c imsSalesdataCreator(ID id,String Imscustomer,string imsCustomerno, String month,String year, String imsProno, Id productid, String productname, Decimal Volume)
    {
        jj_rb_IMS_Sales_Data__c imsdata= new jj_rb_IMS_Sales_Data__c();
        
        imsdata.jj_rb_Customer__c=id;
        imsdata.jj_rb_IMS_Customer__c= Imscustomer;
        imsdata.jj_rb_IMS_Customer_Number__c=imsCustomerno;
        imsdata.jj_rb_IMS_Data_Month__c=month;
        imsdata.jj_rb_IMS_Data_Year__c=year;
        imsdata.jj_rb_IMS_Product_Number__c=imsProno;
        imsdata.jj_rb_Product__c=productid;
        //imsdata.jj_rb_IMS_Product_Info__c=;
        imsdata.jj_rb_Product_Name__c=productname;
        imsdata.jj_rb_IMS_Volume__c=Volume;
        insert imsdata;
        return imsdata;
    }
    
    public static string customsettingCreator(String name,String Status)
    {
        jj_rb_Rebate_Contract_Line_Item_Status__c Statuscustomsetting = new jj_rb_Rebate_Contract_Line_Item_Status__c();
        Statuscustomsetting.name = name;
        Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c = Status;
        insert Statuscustomsetting;
        return Statuscustomsetting.jj_rb_Rebate_Line_Item_Status__c;
    }
    
    //returns status for MDR Records
    public static  String StatusCreator(String status)
    {
        list<jj_rb_Rebate_Contract_Line_Item_Status__c> statusList = [select jj_rb_Rebate_Line_Item_Status__c
                                                                from jj_rb_Rebate_Contract_Line_Item_Status__c
                                                                where name =: status];
        if(!statusList.isEmpty())
            return statusList[0].jj_rb_Rebate_Line_Item_Status__c;
        
        return null;
    }
   
   
    //Returns the recordTypeId for the specified record type name
    public static String MDReocrdTypeCreator(String recordTypeName,string RecortypID)
    {
        jj_rb_Master_Data_RecordTypes__c RecordType = new jj_rb_Master_Data_RecordTypes__c();
        RecordType.name = recordTypeName;
        RecordType.jj_rb_RecordTypeId__c = RecortypID;
        insert RecordType;
        return RecordType.jj_rb_RecordTypeId__c;
        /*List<jj_rb_Master_Data_RecordTypes__c> listRecordTypes = [SELECT jj_rb_RecordTypeId__c 
                                                            FROM jj_rb_Master_Data_RecordTypes__c 
                                                            WHERE name =: recordTypeName];
        if(!listRecordTypes.isEmpty())
            return listRecordTypes[0].jj_rb_RecordTypeId__c;
        return null; */
    }
    
    /*
    //Returns the MasterDataOwner's ID
    public static String MasterDataOwner_creator(String name,String OwnerID)
    {
        jj_rb_Master_Data_OwnerID__c own = new jj_rb_Master_Data_OwnerID__c();
        own.name = name;
        own.jj_rb_Owner_ID__c = OwnerID;
        insert own;
        return own.jj_rb_Owner_ID__c;
/*
        list<jj_rb_Master_Data_OwnerID__c> OwnIDList = [select jj_rb_Owner_ID__c 
                                                        from jj_rb_Master_Data_OwnerID__c 
                                                        where name =: OwnerID];
        
        if(!OwnIDList.isEmpty())
            return OwnIDList[0].jj_rb_Owner_ID__c ;
        
        return null;
    }*/
    
    
    //Returns the Account Type For Specified Record    
    public static  String accountTypeCreator(String Acc_type)
    {
         list<jj_rb_account_type__c> ListAccType = [select jj_rb_Account_Type__c 
                                                     from jj_rb_account_type__c
                                                     where name =: Acc_type];
                                                     
         if(!ListAccType.isEmpty())
             return ListAccType[0].jj_rb_Account_Type__c;
        
         return null;
    }
    
    // user data creator
    public static user userCreator(String alias, String LastName,String emailid, String username, String userlicense, String EmailEncodingKey, String TimeZoneSidKey,String LocaleSidKey,String LanguageLocaleKey, String ProfileId)
    {
        User u= new user();
        u.Alias=alias;
        u.LastName=LastName;
        u.Email=emailid;
        u.username=username;
        //u.usertype=userlicense;
        u.EmailEncodingKey=EmailEncodingKey;
        u.TimeZoneSidKey=TimeZoneSidKey;
        u.LocaleSidKey=LocaleSidKey;
        u.LanguageLocaleKey=LanguageLocaleKey;       
        u.ProfileId=ProfileId;     
        insert u;
        return u;
    }
    
    // Customer Master Data Request creator
    public static jj_rb_Master_Data_Request__c MDR_CustomerCreator(String Ownid,
                                                                    String SAPCustNo,
                                                                    String Name,
                                                                    string Phone,
                                                                    String email,
                                                                    String status , 
                                                                    String SAPvendor, 
                                                                    decimal Rebate_Accrual,
                                                                    String street, string city,string state,string country,string postal_code,
                                                                    string recordtype)
    {
        
        jj_rb_Master_Data_Request__c customer = new jj_rb_Master_Data_Request__c();
        customer.ownerid=Ownid;
        //customer.jj_rb_SAP_Customer_Number__c = SAPCustNo;
        customer.jj_rb_Business_Name__c = Name;
        customer.jj_rb_Business_Phone__c = phone;
        customer.jj_rb_Email__c = email;
        customer.jj_rb_Status__c = status;   
        customer.jj_rb_SAP_Vendor_Number__c = SAPvendor;
        customer.jj_rb_SAP_Customer_Number__c = SAPCustNo;
        //customer.jj_rb_Estimated_Rebate_Accrual__c = Rebate_Accrual;
        customer.jj_rb_Business_State__c = state;
        customer.jj_rb_Business_Street__c = street;
        customer.jj_rb_Business_City__c = city;
        customer.jj_rb_Business_Country__c = country;
        customer.jj_rb_Business_Postal_Code__c = postal_code;
        //MDR.jj_rb_Parent_Customer__c=accountID;
        customer.RecordTypeId = recordtype;
        insert customer;
        return customer;
    }
    
    //Product Master Data Request Creator
    public static jj_rb_Master_Data_Request__c MDR_ProductCreator(String Ownid,string Status,String Description,string SKU,String Material,string Unit_of_measure,string recordtype,string IMSProductID)
    {
        
        jj_rb_Master_Data_Request__c product=new jj_rb_Master_Data_Request__c();
        product.ownerid=Ownid;
        product.jj_rb_SAP_Description__c = Description;
        product.jj_rb_SAP_EAN_Code__c = SKU;
        product.jj_rb_SAP_Material_Code__c = Material;
        product.jj_rb_Unit_of_Measure__c = Unit_of_measure;
        product.RecordTypeId = recordtype;
        product.jj_rb_IMS_Product_ID__c = IMSProductID;
        insert product;
        return product;
    }
    /*
    private String formatDate(Date dateValue, String format)
    {
        DateTime dt = DateTime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
        return dt.format(format);
    }
    
     private List<jj_rb_Rebate_Contract_Line_Item__c> getMapList(Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapCLI, String ncmUser)
     {
        List<jj_rb_Rebate_Contract_Line_Item__c> listLineItems;
        if(mapCLI.containsKey(ncmUser))
        {
            listLineItems = mapCLI.get(ncmUser);
        } 
        else 
        {
          listLineItems = new List<jj_rb_Rebate_Contract_Line_Item__c>(); 
        }
       return listLineItems;
    }
    
    private String createTable(List<jj_rb_Rebate_Contract_Line_Item__c> lineItems)
    {
        String body = '';
        body += '<table border="1"><tr><td><b>Contract</b></td><td><b>Line Item No</b></td><td><b>Product</b></td><td><b> Rebate Value </b></td> <td><b> Start Date  </b></td> <td><b> End Date </b></td></tr>';
        for(jj_rb_Rebate_Contract_Line_Item__c li : lineItems)
        {
            body += '<tr><td>' + li.jj_rb_Rebate_Contract__r.Name + '</td><td>' + li.name + '</td><td>' + li.jj_rb_Product__r.name + '</td><td>' + li.jj_rb_Rebate__c + '</td><td>' + formatDate(li.jj_rb_Start_Date__c,'dd/MM/yyyy') + '</td><td>' + formatDate(li.jj_rb_End_Date__c,'dd/MM/yyyy') + '</td></tr>';
        }
        body += '</table>'; 
        return body;    
    }
    
*/
        
    //Test Method for Master data Conver Trigger (jj_rb_Rebate_MasterDataRequestConvert_After_Update).
    
    static testmethod void Test_Master_Data_Request_convert_trigger()
    {
       /* string Status_new = jj_rb_Rebate_TestClass.customsettingCreator('New','New');
        string Status_approved = jj_rb_Rebate_TestClass.customsettingCreator('Approved','Approved');
        //String Record_Owner = jj_rb_Rebate_TestClass.MasterDataOwner_creator('Master Data Owner ID','00511000000uQ6h');
        String Cust_RecordTyp =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer_MDR','01211000000CjaX');
        System.debug(Cust_RecordTyp);
        String Prod_RecordTyp = jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Product_Data_Request','01211000000CjaY');
        // Insert Records With Different Record Types
        //jj_rb_Master_Data_Request__c NewCust = jj_rb_Rebate_TestClass.MDR_CustomerCreator(Record_Owner,'9006','Boots Ltd','97457865','boots@uk.com',Status_new,'0878',12.00,'1 Thane Road West','Nottingham','UK','UK','UKNG901BS',Cust_RecordTyp);
        //jj_rb_Master_Data_Request__c NewProduct = jj_rb_Rebate_TestClass.MDR_ProductCreator(Record_Owner,Status_new,'Daktarin Cream 30mg','97842','4015','Pieces',Prod_RecordTyp,'6754');
        jj_rb_Rebate_Product__c product=new jj_rb_Rebate_Product__c();
        
        test.startTest();
        // Update Records
        NewCust.jj_rb_Status__c = Status_approved;
        update NewCust;
        NewProduct.jj_rb_Status__c = Status_approved;
        update NewProduct;
        test.stopTest();*/
    }
    
    //Test Method for Contract Close Procedure
    static testmethod void Test_closeContract()
    {
        //Create Data to create Contract
        string Status_approved = StatusCreator('Approved');
        List<Profile> p = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='jnjuser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=p[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='jnjuser@testorg.com');       
        Account acc = jj_rb_Rebate_TestClass.accountCreator('1006','Pharma','1231231234','sales@pharma.com','5005',12.00,'101 Thane','New York','UK','UK','UKNG901BS'); 
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat0');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *60', 'This is Product Description', '1234567', '123','piece','IMS1212',vatcode.id);
        jj_rb_Rebate_Product__c Products1 = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *6000', 'This is a new Product Description', '12345678', '12325','piece','IMS2978',vatcode.id);
        jj_rb_Rebate_Contract__c Newcontract = jj_rb_Rebate_TestClass.rebateContractCreator(acc.Id, 'This is contract description', Status_approved,u.id);
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem1 = rebateContractLineItemCreator(Newcontract.id,Products.id,date.today(),date.today()+2,100.00,'Modified',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem2 = rebateContractLineItemCreator(Newcontract.id,Products.id,date.Today()+11,date.Today()+20,100.00,'New',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem3= rebateContractLineItemCreator(Newcontract.id,Products1.id,date.today(),date.today()+22,100.00,'Modified',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem4 = rebateContractLineItemCreator(Newcontract.id,Products1.id,date.Today()+26,date.Today()+30,100.00,'New',True );         
        
        // Call standard controller.
        ApexPages.StandardController sc_contract =  new ApexPages.StandardController(Newcontract);
        
        // Call VF extension
        jj_rb_Close_contract Close_cte = new jj_rb_Close_contract(sc_contract);
        
        //Call VF pages with Newly inserted Record ID
        PageReference pgref = new PageReference('jj_rb_Close_Rebate_Contract');
        pgref.getParameters().put('id',string.valueOf(Newcontract.id));
        test.setCurrentPage(pgref);
        Close_cte.close_contract();
  
    }
    //Test Method for Request Change VF page Extension (jj_rb_Rebate_RequestChange_CTE)
    
    static testmethod void Test_RequestChange_CTE()
    {
        /*
        string Status_approved = jj_rb_Rebate_TestClass.customsettingCreator('Approved','Approved');
        String Record_Owner = jj_rb_Rebate_TestClass.MasterDataOwner_creator('Master Data Owner ID','00511000000uQ6h');
        String Cust_RecordTyp =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer_MDR','01211000000CjaX');
        System.debug(Cust_RecordTyp);
        String Prod_RecordTyp = jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Product_Data_Request','01211000000CjaY');
        // Insert Records With Different Record Types
        jj_rb_Master_Data_Request__c NewCust = jj_rb_Rebate_TestClass.MDR_CustomerCreator(Record_Owner,'9006','Boots Ltd','97457865','boots@uk.com',Status_approved,'0878',12.00,'1 Thane Road West','Nottingham','UK','UK','UKNG901BS',Cust_RecordTyp);
        jj_rb_Master_Data_Request__c NewProduct = jj_rb_Rebate_TestClass.MDR_ProductCreator(Record_Owner,Status_approved,'Daktarin Cream 30mg','97842','4015','Pieces',Prod_RecordTyp,'6754');
        
        Account acc = new Account(); 
        acc = jj_rb_Rebate_TestClass.accountCreator('1006','Pharma','1231231234','sales@pharma.com','5005',12.00,'101 Thane','New York','UK','UK','UKNG901BS');
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat0');
        jj_rb_Rebate_Product__c product = new jj_rb_Rebate_Product__c();
        product = jj_rb_Rebate_TestClass.rebateProductCreator('ABC', 'ABC 30mg', '12587', '9878', 'Pieces','IMS1010',vatcode.id);
        
        // Call standard controller.
        ApexPages.StandardController sc_customer =  new ApexPages.StandardController(acc);
        ApexPages.StandardController sc_product =  new ApexPages.StandardController(product);
        
        // Call VF extension
        jj_rb_Rebate_RequestChange_CTE Request_change_customer = new jj_rb_Rebate_RequestChange_CTE(sc_customer);
        jj_rb_Rebate_RequestChange_CTE Request_change_product = new jj_rb_Rebate_RequestChange_CTE(sc_product);
        
        //Call VF pages with Newly inserted Record ID
        PageReference pgref = new PageReference('jj_rb_Rebate_Account_RequestChange');
        pgref.getParameters().put('id',string.valueOf(acc.id));
        test.setCurrentPage(pgref);
        PageReference pageref = new PageReference('jj_rb_Rebate_Product_RequestChange');
        pageref.getParameters().put('id',string.valueOf(product.id));
        Test.setCurrentPage(pageref);
        
        // Call Extension methods
        Request_change_customer.AccountPageLoad();
        Request_change_product.ProductPageLoad();
        Request_change_customer.submitForChange();
        Request_change_product.Cancel();
        
        // Assert New values using assert function
        jj_rb_Master_Data_Request__c MDR = [select jj_rb_Business_Name__c from jj_rb_Master_Data_Request__c where jj_rb_Business_Name__c =: acc.name];
        System.assertEquals('Pharma',MDR.jj_rb_Business_Name__c) ;
        */
    }
    
    static testMethod void RebateContractAfterUpdate()
    {
        string Status_new = StatusCreator('new');
        string Status_approved = StatusCreator('Approved');
        List<Profile> p = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='jnjuser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=p[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='jnjuser@testorg.com');
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat0');
        Account a = jj_rb_Rebate_TestClass.accountCreator('0200','Test Account','2145639875','mangadivya.kasani@capgemini.com','8077',1000.00,'street','city','state','country','534301');
        jj_rb_Rebate_Contract__c contracts = jj_rb_Rebate_TestClass.rebateContractCreator(a.Id, 'This is contract description', Status_approved,u.id);    
        jj_rb_Rebate_Contract__c contracts1 = jj_rb_Rebate_TestClass.rebateContractCreator(a.Id, 'This is contract description', Status_approved,u.id);    
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *60', 'This is Product Description', '1234567', '123','piece','IMS1212',vatcode.id);
        jj_rb_Rebate_Product__c Products1 = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *6000', 'This is a new Product Description', '12345678', '12325','piece','IMS2978',vatcode.id);
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem = rebateContractLineItemCreator(contracts.id,Products.id,date.today(),date.today()+2,100.00,'Modified',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem1 = rebateContractLineItemCreator(contracts.id,Products.id,date.Today()+11,date.Today()+20,100.00,'New',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem2 = rebateContractLineItemCreator(contracts.id,Products1.id,date.today(),date.today()+22,100.00,'Modified',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem3 = rebateContractLineItemCreator(contracts.id,Products1.id,date.Today()+26,date.Today()+30,100.00,'New',True );         
        Test.startTest();
        insert u;
        upsert RcontractLineItem ;
        upsert RcontractLineItem1; 
        upsert RcontractLineItem2;
        upsert RcontractLineItem3;      
        RcontractLineItem.jj_rb_Status__c=contracts.jj_rb_Status__c;
        exception e;
        try
        {
            update contracts ;
        }
        catch(exception ex)
        {
            e=ex;
        }
        RcontractLineItem1.jj_rb_Status__c=Status_new;
         
        try
        {
            update contracts ;
        }
        catch(exception ex)
        {
            e=ex;
        }
        Test.stopTest();
    } 
    
      static testMethod void jj_rb_Contract_notifications()
    {   
        List<Profile> p = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='divyakasani@gmail.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=p[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='jnjuser@testorg.com' );
        System.runAs ( new User(Id = UserInfo.getUserId()) ) 
        {
           insert u;
        }
        Account a = jj_rb_Rebate_TestClass.accountCreator('0002','Test Account','2145639875','mangadivya.kasani@capgemini.com','8009',1000.00,'street','city','state','country','534301');
        jj_rb_Rebate_Contract__c contracts = jj_rb_Rebate_TestClass.rebateContractCreator(a.Id, 'This is contract description', 'Approved',u.id);    
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat0');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *60', 'This is Product Description', '1234567', '123','pieces','IMS2343',vatcode.id);
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem = rebateContractLineItemCreator(contracts.id,Products.id,date.Today(),Date.Today()+14,100.00,'Modified',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem1 = rebateContractLineItemCreator(contracts.id,Products.id,date.Today(),Date.Today()+60,100.00,'Modified',True );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem2 = rebateContractLineItemCreator(contracts.id,Products.id,date.Today()-1,Date.Today(),100.00,'Modified',True );
        upsert RcontractLineItem; 
        upsert RcontractLineItem1;
        upsert RcontractLineItem2;  
          
        
        jj_rb_Contract_notifications notification= new jj_rb_Contract_notifications();
        Database.executeBatch(notification);  
        
    }
    static testMethod void jj_rb_Rebate_claim_LineItem_validation()
    {
        string Status_new = StatusCreator('new');
        Account a = jj_rb_Rebate_TestClass.accountCreator('0002','Test Account','2145639875','mangadivya.kasani@capgemini.com','8009',1000.00,'street','city','state','country','534301');  
        Account a1 = jj_rb_Rebate_TestClass.accountCreator('0003','sample Account','2145639','mangadivya@capgemini.com','800',1100.00,'test street','test city','test state','test country','4301');          
        List<Profile> p = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='divyakasani@gmail.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=p[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='jnjuser@testorg.com');
       System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert u;
        }
       
        jj_rb_Rebate_Contract__c contracts = jj_rb_Rebate_TestClass.rebateContractCreator(a.Id, 'This is contract description', 'Approved',u.id);    
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat0');
        jj_rb_VAT_Code__c vatcode1=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat10');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *60', 'This is Product Description', '1234567', '123','pieces','IMS2343',vatcode.id);
        
        jj_rb_IMS_Sales_Data__c salesdata= jj_rb_Rebate_TestClass.imsSalesdataCreator(a.id,'123456','2356','march','2014', '69875', Products .id, 'Triz', 200);
        jj_rb_Rebate_Contract__c contract = jj_rb_Rebate_TestClass.rebateContractCreator(a.Id, 'This is contract description', 'Approved',u.id);    
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem = rebateContractLineItemCreator(contracts.id,Products.id,date.parse('1/3/2014'),Date.parse('25/3/2014'),100.00,'Modified',True );
        jj_rb_Rebate_Claim__c claim=jj_rb_Rebate_TestClass.rebateClaimCreator(a.id,'This is a claim',Status_new,'march', '2014' );
        jj_rb_Rebate_Claim__c newclaim=jj_rb_Rebate_TestClass.rebateClaimCreator(a.id,'This is a new claim',Status_new,'april', '2015' );
        jj_rb_Rebate_Claim_Line_Item__c RClaimline=jj_rb_Rebate_TestClass.rebateClaimlineitemCreator(claim.id,Products.id, 500.00, 50,vatcode.id);  
        jj_rb_Rebate_Claim_Line_Item__c RClaimline1=jj_rb_Rebate_TestClass.rebateClaimlineitemCreator(claim.id,Products.id, 500.00, 50,vatcode1.id);  
       // jj_rb_Rebate_Claim__c claim1=jj_rb_Rebate_TestClass.rebateClaimCreator(a.id,'This is a claim',Status_new,'march', '2016' );
        //jj_rb_Rebate_Claim__c newclaim1=jj_rb_Rebate_TestClass.rebateClaimCreator(a.id,'This is a new claim',Status_new,'march', '2016' );
        
        Exception e;
        test.startTest();
        try
        {
           
           upsert RClaimline1;
                 
        }
        catch(Exception ex)
        {
             ex=e;  
        }
        test.stopTest();
    }
    
    
    
    
    /*static testMethod void emailnotify()
    {           
        jj_rb_Rebate_notification_OnTheDay email= new  jj_rb_Rebate_notification_OnTheDay();
        Database.executeBatch(email);
    }
    static testMethod void emailnotifytwoweeks()
    {             
        jj_rb_Rebate_notification_Before_2Weeks notify= new jj_rb_Rebate_notification_Before_2Weeks();
        Database.executeBatch(notify);
                  

    }
    static testMethod void emailNotifyBeforeTwomonths()
    {   
       
        jj_rb_Rebate_notification_Before_2Months notifytwomonths= new jj_rb_Rebate_notification_Before_2Months();
        Database.executeBatch(notifytwomonths);        
    }
    
  
    
    static testMethod void  jj_rb_Rebate_Contract_Email_schedule()
    {
        Test.startTest();
        String schedule = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('jj_rb_Contract_Expiry_Job', schedule ,new jj_rb_Rebate_Contract_Email_schedule() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(schedule , ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();            

    }
    static testMethod void  jj_rb_Rebate_Contract_schedule_2months()
    {
        Test.startTest();
        String schedule = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('jj_rb_Contract_Expiry_Jobs', schedule ,new jj_rb_Rebate_Contract_schedule_2months() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(schedule , ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();            

    }
    
    static testMethod void  jj_rb_Rebate_Contract_schedule_2weeks()
    {
        Test.startTest();
        String schedule = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('jj_rb_Contract_Expiry_Jobs_week', schedule ,new jj_rb_Rebate_Contract_schedule_2weeks() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(schedule , ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();            

    }*/
    

}