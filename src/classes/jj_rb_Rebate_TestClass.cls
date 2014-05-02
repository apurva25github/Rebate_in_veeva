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
    public static Account accountCreator(String SAPCustNo,ID ncmid,String Name,string Phone,String email, 
                                            String SAPvendor, decimal Rebate_Accrual,String street, string city,
                                            string state,string country,string postal_code,String AccType,String imscustno)
    {
        Account customer = new Account();
        customer.jj_rb_SAP_Customer_Number__c = SAPCustNo;
        customer.jj_rb_National_Channel_Manager__c=ncmid;
        customer.Name = Name;          
        customer.jj_rb_SAP_Vendor_Number__c = SAPvendor;  
        customer.type =AccType;
        customer.jj_rb_IMS_Customer_Id__c=imscustno;
        insert customer; 
        return customer;
    }
    
     // Get Recordtypeid
    public static String getRecordtype(String recortypename)
    {
        list<Recordtype> Rectypid = [select id,name from Recordtype where name =: recortypename];
        if(Rectypid.size() != 0)
        {
            return Rectypid[0].id;
        }
        else
            return null;
    }
       
     // Homecare Account Creator
    public static Account homecareaccountCreator(String SAPCustNo,ID ncmid,String Name,string Phone,String email, 
                                            String SAPvendor,String street, string city,
                                            string state,string country,string postal_code,String AccType, Date creditfrom,Date creditend,String recordtypeid)
    {
        Account homecare = new Account();
        homecare.jj_rb_SAP_Customer_Number__c = SAPCustNo;
        homecare.jj_rb_National_Channel_Manager__c=ncmid;
        homecare.Name = Name;
        homecare.jj_rb_SAP_Vendor_Number__c = SAPvendor; 
        homecare.type =AccType;
        homecare.jj_rb_Credit_check_Validity_From__c=creditfrom;
        homecare.jj_rb_Credit_check_Validity_End__c=creditend;
        homecare.RecordTypeId=recordtypeid;
        insert homecare; 
        return homecare;
    }
       
     //HCP claim creator
     public static jj_rb_Rebate_Claim__c HCPClaimCreator(Id accountID,string Description, string status, String month,String year,String Recordtypeid)
    {        
        jj_rb_Rebate_Claim__c HCPClaim= new jj_rb_Rebate_Claim__c();                   
        HCPClaim.jj_rb_Customer__c=accountId;     
       // HCPClaim.OwnerId=OwnerId;
        HCPClaim.jj_rb_Description__c=Description;
        HCPClaim.jj_rb_Status__c=status;
        HCPClaim.jj_rb_Month__c=month;
        HCPClaim.jj_rb_year__c=year;  
        HCPClaim.RecordTypeId=Recordtypeid;  
        insert HCPClaim;       
        return HCPClaim;
    }
    
    // user data creator
    public static user userCreator(String alias, String LastName,String emailid, String username, String userlicense, String EmailEncodingKey, String TimeZoneSidKey,String LocaleSidKey,String LanguageLocaleKey, String ProfileId)
    {
        User u= new user();
        u.Alias=alias;
        u.LastName=LastName;
        u.Email=emailid;
        u.username=username;      
        u.EmailEncodingKey=EmailEncodingKey;
        u.TimeZoneSidKey=TimeZoneSidKey;
        u.LocaleSidKey=LocaleSidKey;
        u.LanguageLocaleKey=LanguageLocaleKey;       
        u.ProfileId=ProfileId;     
        insert u;
        return u;
    }
    
    // Rebate Contract Creator
    public static jj_rb_Rebate_Contract__c rebateContractCreator(Id accountID, string Description, string status, Id ncmid,String Recordtypeid)
    {
        jj_rb_Rebate_Contract__c RContract= new jj_rb_Rebate_Contract__c();                   
        RContract.jj_rb_Customer__c=accountId;
        RContract.RecordTypeId =Recordtypeid;
        RContract.jj_rb_Description__c=Description;
        RContract.jj_rb_Status__c=status;
        RContract.jj_rb_National_Channel_Manager__c=ncmid;         
        insert RContract;
        return RContract;
    }
    
    //Retailer buying group creator
    public static jj_rb_Retailer_Buying_Group__c retailerBGCreator(ID customerid)
    {
        jj_rb_Retailer_Buying_Group__c retailerBG= new jj_rb_Retailer_Buying_Group__c();                   
        retailerBG.jj_rb_Customer__c=customerid;        
        insert retailerBG;
        return retailerBG;
    }
    
    //Retailer buying group member creator
    public static jj_rb_Retailer_Buying_Group_Member__c retailerBGMemberCreator(ID customerid,ID retailerbgID)
    {
        jj_rb_Retailer_Buying_Group_Member__c retailerBGMember= new jj_rb_Retailer_Buying_Group_Member__c();                   
        retailerBGMember.jj_rb_Customer__c=customerid;  
        retailerBGMember.jj_rb_Lead_Retailers__c=retailerbgID; 
        try{    
            insert retailerBGMember;
        }
        catch(Exception e){}
        return retailerBGMember;
    }
    
    // HCP Contract Creator
    public static jj_rb_Rebate_Contract__c HCPContractCreator(Id productid, string Description, string status, Id ncmid,String Recordtypeid)
    {
        jj_rb_Rebate_Contract__c HCPContract= new jj_rb_Rebate_Contract__c();                   
        HCPContract.jj_rb_Product__c=productid;
        HCPContract.RecordTypeId =Recordtypeid;
        HCPContract.jj_rb_Description__c=Description;
        HCPContract.jj_rb_Status__c=status;
        HCPContract.jj_rb_National_Channel_Manager__c=ncmid;    
        HCPContract.RecordTypeId=Recordtypeid;   
        insert HCPContract;
        return HCPContract;
    }
    
   
    //HCP claim line item creator
    public static   jj_rb_Rebate_Claim_Line_Item__c HCPClaimlineitemCreator(Id cid,ID hospitalid, 
                                        Id Productid, Decimal listprice,Decimal unitprice, Integer quantity,
                                        Id vatid,String recordtypeid)
    {
        jj_rb_Rebate_Claim_Line_Item__c HCPClaimline= new jj_rb_Rebate_Claim_Line_Item__c();                   
        HCPClaimline.jj_rb_Rebate_Claim__c=cId;
        HCPClaimline.jj_rb_Unit_List_Price__c=listprice;
        HCPClaimline.jj_rb_Unit_Contract_Price__c=unitprice;      
        HCPClaimline.jj_rb_Rebate_Product__c=Productid;
        HCPClaimline.jj_rb_Hospital__c=hospitalid;
        HCPClaimline.jj_rb_Quantity__c=quantity;
        HCPClaimline.jj_rb_VAT_Code__c=vatid;
        HCPClaimline.RecordTypeId=recordtypeid;  
        insert HCPClaimline;
        return HCPClaimline;
    }
    
    
    //Rebate Claim creator
    public static jj_rb_Rebate_Claim__c rebateClaimCreator(Id accountID,string Description, string status, String month,String year,String Recordstypeid)
    {
        jj_rb_Rebate_Claim__c RClaim= new jj_rb_Rebate_Claim__c();                   
        RClaim.jj_rb_Customer__c=accountId;       
        RClaim.jj_rb_Description__c=Description;
        RClaim.jj_rb_Status__c=status;
        RClaim.jj_rb_Month__c=month;
        RClaim.jj_rb_year__c=year; 
        RClaim.RecordTypeId= Recordstypeid;    
        insert RClaim;       
        return RClaim;
    }   
    
    //Rebate claim line item creator
    public static   jj_rb_Rebate_Claim_Line_Item__c rebateClaimlineitemCreator(Id cid, 
                                        Id Productid, Decimal Rebate, Decimal quantity,
                                        Id vatid,String Recordstypeid)
    {
        jj_rb_Rebate_Claim_Line_Item__c RClaimline= new jj_rb_Rebate_Claim_Line_Item__c();                   
        RClaimline.jj_rb_Rebate_Claim__c=cId;
        RClaimline.jj_rb_Rebate_Product__c=Productid; 
        RClaimline.jj_rb_Rebate_Per_Unit__c = Rebate;   
        RClaimline.jj_rb_Quantity__c=quantity;
        RClaimline.jj_rb_VAT_Code__c=vatid; 
        RClaimline.RecordTypeId= Recordstypeid; 
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
    //Rebate Retailer contract Line Item Creator  
    public static jj_rb_Rebate_Contract_Line_Item__c rebateContractLineItemCreator(Id customerID, Id productID, Date sdate,Date edate,Decimal rebate,String status, boolean ismodified,String Recordtypeid)
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=customerID;
        Rebatecontractlineitem.RecordTypeId =Recordtypeid;
        Rebatecontractlineitem.jj_rb_Product__c=productID;
        Rebatecontractlineitem.jj_rb_Start_Date__c=sdate;
        Rebatecontractlineitem.jj_rb_End_Date__c=edate;
        Rebatecontractlineitem.jj_rb_Rebate__c=rebate;
        Rebatecontractlineitem.jj_rb_Status__c=status;  
        Rebatecontractlineitem.jj_rb_Is_Modified__c=ismodified;      
        insert Rebatecontractlineitem;
        return Rebatecontractlineitem;
    }
    
    // Region creator
     public static jj_rb_Region__c regionCreator(String name,String description)
    {
        jj_rb_Region__c region= new jj_rb_Region__c();
        region.Name=name;
        region.jj_rb_Description__c=description;  
        insert region;
        return region;
    }
    
    //tolerance creator
     public static jj_rb_Tolerance__c toleranceCreator(ID customer,Id productid,Integer quantitytol ,Integer pricetol,Integer avgQty)
    {
       jj_rb_Tolerance__c tolerance= new jj_rb_Tolerance__c();
        tolerance.jj_rb_Customer__c=customer;
        tolerance.jj_rb_Product__c=productid;         
        tolerance.jj_rb_Quantity_Tolerance__c=quantitytol;  
        tolerance.jj_rb_Price_Tolerance__c=pricetol;
        tolerance.jj_rb_Average_Quantity__c=avgQty;
        insert tolerance;
        return tolerance;
    }
    
    
    //HCP  contract Line Item Creator  
    public static jj_rb_Rebate_Contract_Line_Item__c HCPContractLineItemCreator(Id customerID, Id Regionid, Date sdate,Date edate,Decimal rebate,String status, boolean ismodified,String Recordtypeid)
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=customerID;
        Rebatecontractlineitem.RecordTypeId =Recordtypeid;
        Rebatecontractlineitem.jj_rb_Region__c=Regionid;
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
    
    //Rebate Accrual Record creator
    public static jj_rb_Rebate_Accrual__c rebateAccrualCreator(ID customerid,String month,String year,
                                                         ID NCMid,String recordtypeid,String Status)
    {
        jj_rb_Rebate_Accrual__c accrualRecord= new jj_rb_Rebate_Accrual__c(); 
        accrualRecord.jj_rb_Customer__c=customerid;
        
        accrualRecord.jj_rb_Month__c=month;
        accrualRecord.jj_rb_Customer_NCM__c=NCMid;
        accrualRecord.jj_rb_Year__c=year;
        accrualRecord.RecordTypeId=recordtypeid;
        accrualRecord.jj_rb_Status__c=status;
        insert accrualRecord;
        return accrualRecord;
    }
    // Rebate accrual line item creator
    public static jj_rb_Rebate_Accrual_Line_Item__c rebateAccrualLineitemCreator(ID accrualid,Decimal volumes,
                                                                Decimal amount,ID productid,Decimal rebateadjustment,
                                                                Decimal rebateamount)
    {
        jj_rb_Rebate_Accrual_Line_Item__c accrualLineitem= new jj_rb_Rebate_Accrual_Line_Item__c(); 
        accrualLineitem.jj_rb_Volume__c=volumes;
        accrualLineitem.jj_rb_Rebate_Accrual__c=accrualid;
        accrualLineitem.jj_rb_Net_Rebate_Accrual_Amount__c=amount;
        accrualLineitem.jj_rb_Product__c=productid;      
        accrualLineitem.Rebate_Adjustment__c=rebateadjustment;      
        insert accrualLineitem;
        return accrualLineitem;
    }
    
    // Accrual report creator
     public static jj_rb_Rebate_Accrual_Report__c rebateAccrualReportCreator(Boolean completed,String month, String year,String Recordtypeid)
    {
        jj_rb_Rebate_Accrual_Report__c accrualReport= new jj_rb_Rebate_Accrual_Report__c(); 
        accrualReport.jj_rb_Completed__c=completed;
        accrualReport.jj_rb_Month__c=month;
        accrualReport.jj_rb_Year__c=year;    
        accrualReport.RecordTypeId=Recordtypeid;  
        insert accrualReport;
        return accrualReport;
    }
    
    // Accrual report lineitem creator
     public static jj_rb_Rebate_Accrual_Report_Line_Item__c rebateAccrualReportlineitemCreator(Decimal netrebate,Decimal quantity, ID accrualreport,ID productid)
    {
        jj_rb_Rebate_Accrual_Report_Line_Item__c accrualReportlineitem= new jj_rb_Rebate_Accrual_Report_Line_Item__c(); 
        accrualReportlineitem.jj_rb_Net_Rebate__c=netrebate;
        accrualReportlineitem.jj_rb_Quantity__c=quantity;
        accrualReportlineitem.jj_rb_Rebate_Accrual_Report__c=accrualreport;  
        accrualReportlineitem.jj_rb_Rebate_Product__c=productid;  
              
        insert accrualReportlineitem;
        return accrualReportlineitem;
    }
    
    // IMS salesdata creator
    public static jj_rb_IMS_Sales_Data__c imsSalesdataCreator(ID id,String SAPcustomerno,String SAPMaterialcode,String Imscustomer,string imsCustomerno, String month,String year, String imsProno, Id productid, String productname, Decimal Volume)
    {
        jj_rb_IMS_Sales_Data__c imsdata= new jj_rb_IMS_Sales_Data__c();
        
        imsdata.jj_rb_Customer__c=id;        
        imsdata.jj_rb_IMS_Customer__c= Imscustomer;
        imsdata.jj_rb_IMS_Customer_Number__c=imsCustomerno;
        imsdata.jj_rb_IMS_Data_Month__c=month;
        imsdata.jj_rb_IMS_Data_Year__c=year;
        imsdata.jj_rb_IMS_Product_Number__c=imsProno;
        imsdata.jj_rb_Product__c=productid;      
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
    }
    
    /*//Returns the MasterDataOwner's ID
    public static String MasterDataOwner_creator(String name,String OwnerID)
    {
        jj_rb_Master_Data_OwnerID__c own = new jj_rb_Master_Data_OwnerID__c();
        own.name = name;
        own.jj_rb_Owner_ID__c = OwnerID;
        insert own;
        return own.jj_rb_Owner_ID__c;
    }*/
    //Returns the Account Type For Specified Record    
    public static  String accountTypeCreator(String name,String Acc_type)
    {
        jj_rb_account_type__c accType= new jj_rb_account_type__c();
        accType.name=name;
        accType.jj_rb_Account_Type__c=Acc_type;
        insert accType;
        return accType.jj_rb_Account_Type__c;        
    }
         
    // Customer Master Data Request creator
    public static jj_rb_Master_Data_Request__c MDR_CustomerCreator(String Ownid,Integer totalestimateaccrual,
                                                                    String SAPCustNo,
                                                                    String Name,   
                                                                    String status , 
                                                                    String SAPvendor,                                                                                                                                    
                                                                    string recordtype)
    {
        
        jj_rb_Master_Data_Request__c customer = new jj_rb_Master_Data_Request__c();
        customer.ownerid=Ownid;       
        customer.jj_rb_Total_Estimat_Rebate_Accrual__c=totalestimateaccrual;
        customer.jj_rb_Business_Name__c = Name;  
        customer.jj_rb_Status__c = status;   
        customer.jj_rb_SAP_Vendor_Number__c = SAPvendor;
        customer.jj_rb_SAP_Customer_Number__c = SAPCustNo; 
        customer.RecordTypeId = recordtype;
        insert customer;
        return customer;
    }
    
    //Estimated accrual creator
    public static jj_rb_Estimated_Rebate_Accrual__c estimatedAccrualCreator(ID customerid,id mdrid,Id productid, Decimal estimatedAccrual)
    {
        
        jj_rb_Estimated_Rebate_Accrual__c EstimatedAccruals= new jj_rb_Estimated_Rebate_Accrual__c();
        EstimatedAccruals.jj_rb_Account__c=customerid;
        EstimatedAccruals.jj_rb_Rebate_Product__c=productid;
        EstimatedAccruals.jj_rb_Master_Data_Request__c=MDRid;
        EstimatedAccruals.jj_rb_Estimated_Accrual__c=estimatedAccrual;
        insert EstimatedAccruals;
        return EstimatedAccruals;
    }
    
    //Product Master Data Request Creator
    public static jj_rb_Master_Data_Request__c MDR_ProductCreator(String Ownid,string Status,String Description,string SKU,String Material,string Unit_of_measure,string recordtype,string IMSProductID,id VAT)
    {
        
        jj_rb_Master_Data_Request__c product=new jj_rb_Master_Data_Request__c();
        product.ownerid=Ownid;
        
        product.jj_rb_SAP_Description__c = Description;
        product.jj_rb_SAP_EAN_Code__c = SKU;
        product.jj_rb_SAP_Material_Code__c = Material;
        product.jj_rb_Unit_of_Measure__c = Unit_of_measure;
        product.RecordTypeId = recordtype;
        product.jj_rb_IMS_Product_ID__c = IMSProductID;
        product.jj_rb_VAT_code__c = VAT; 
        insert product;
        return product;
    }
    
    //hospital account creator
      public static Account hospitalaccountCreator(String SAPCustNo,ID nhsid,String Name,string Phone,String email, 
                                            String SAPvendor, String street, string city,
                                            string state,string country,string postal_code,String AccType,String Recordtype)
    {
        Account hospital= new Account();
        hospital.jj_rb_SAP_Customer_Number__c = SAPCustNo;       
        hospital.Name = Name;          
        hospital.jj_rb_SAP_Vendor_Number__c = SAPvendor;
        hospital.jj_rb_NHS_Trust__c=nhsid;
        hospital.RecordTypeId=Recordtype;       
        hospital.type =AccType;
        insert hospital;  
        return hospital;
    }
    
    // NHS Trust creator
     public static jj_rb_NHS_Trust__c NhstrustCreator(String BCity,ID regionid,String Bcountry,string Bphone,String Bpostalid, 
                                            String state, String street, String nhstrustid)
    {
        jj_rb_NHS_Trust__c nhstrust= new jj_rb_NHS_Trust__c();
        nhstrust.jj_rb_Business_City__c=BCity;
        nhstrust.jj_rb_Business_Country__c=Bcountry;
        nhstrust.jj_rb_Business_Phone__c=Bphone;
        nhstrust.jj_rb_Business_Postal_Code__c=Bpostalid;
        nhstrust.jj_rb_Business_State__c=state;
        nhstrust.jj_rb_Business_Street__c=street;
        nhstrust.jj_rb_NHS_Trust_ID__c=nhstrustid;
        nhstrust.jj_rb_Region__c=regionid;
       
        insert nhstrust;  
        return nhstrust;
    } 
    
    //test method for Rebate claim line item validations
    static testMethod void jj_rb_Rebate_claim_validation()
    {
        //Account typerecords
        String Retailertype = jj_rb_Rebate_TestClass.accountTypeCreator('Retailer Type','Retailer');   
        string Status_approved = StatusCreator('Approved');
        string Status_new = StatusCreator('new');
        String rectypid = jj_rb_Rebate_TestClass.getRecordtype('Claim_Homecare');
        String RetailerRebateClaimRT =jj_rb_Rebate_TestClass.getRecordtype('Rebate_Claim_Retailer');
        String RetailerclaimlineitemRT =jj_rb_Rebate_TestClass.getRecordtype('Claim_LineItem_Retailer');
        List<Profile> p = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='divyakasani@gmail.com',EmailEncodingKey='UTF-8', LastName='Testinguser', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=p[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='jnjuserfordev@testorg.com',UserRoleId='00EU0000000YjHB' );       
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert u;
        }
       
        Account a = jj_rb_Rebate_TestClass.accountCreator('0002',u.id,'Test Account','2145639875','mangadivya.kasani@capgemini.com','8009',1000.00,'street','city','state','country','534301',Retailertype,'MSC5236');               
        Account a1 = jj_rb_Rebate_TestClass.accountCreator('0003',u.id,'sample Account','2145639','mangadivya@capgemini.com','800',1100.00,'test street','test city','test state','test country','4301',Retailertype,'IMS584');          
            
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat0');
        jj_rb_VAT_Code__c vatcode1=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat10');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *60', 'This is Product Description', '1234567', '123','pieces','IMS2343',vatcode.id);
        jj_rb_Rebate_Product__c newProducts = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *600', 'This is Product Description', '34567', '12','pieces','IMS23',vatcode.id);            
        jj_rb_Rebate_Claim__c claim=jj_rb_Rebate_TestClass.rebateClaimCreator(a.id,'This is a claim',Status_new,'april', '2014',RetailerRebateClaimRT);        
        jj_rb_Rebate_Claim__c newclaim=jj_rb_Rebate_TestClass.rebateClaimCreator(a1.id,'This is a new claim',Status_new,'may', '2015',RetailerRebateClaimRT);       
       
        upsert claim;
        upsert newclaim;
        jj_rb_Rebate_Claim__c claim1=jj_rb_Rebate_TestClass.rebateClaimCreator(a.id,'This is a claim',Status_new,'june', '2014',RetailerRebateClaimRT);      
        try{
            Upsert claim1;
        }catch(Exception e){            
            
        }
            
    }
    // Test method for Rebateclaimlineitem validation
    static testMethod void jj_rb_Rebate_claimLineitem_validation()
    {
        String Retailercontract =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer Contract','01211000000CmNR');
        String homecarecontract =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Home care Provider contract','01211000000Cntd');
        String retailercontractlines =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer contract line item','01211000000CnwX');
        String homecarecontractlines =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('HCP Contract line item','01211000000CnwD');
        String homecareClaim =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim','01211000000Cpfn');
        String homecareClaimlineitem =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim line item','01211000000Cpwo');  
        String hospitalAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Hospital','01211000000Cnx6'); 
        String RetailerRebateClaimRT =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer Rebate Claim','01211000000Ck8K');
        String RetailerclaimlineitemRT =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer claim line item','01211000000Ck8e');
        String HomeCareType = jj_rb_Rebate_TestClass.accountTypeCreator('Home Care Provider','Home care provider');
        String Hospitaltype = jj_rb_Rebate_TestClass.accountTypeCreator('Hospital','Hospital'); 
        String Retailertype = jj_rb_Rebate_TestClass.accountTypeCreator('Retailer Type','Retailer');   
        string Status_approved = StatusCreator('Approved');
        string Status_new = StatusCreator('new');
        String homecareAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Homecare','01211000000CpUV');
        List<Profile> profile = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User user = new User(Alias = 'sforce', Email='salesforce@jnj.com',EmailEncodingKey='UTF-8', LastName='Indirectuser', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=profile[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='Indirectuserforjnj@testorg.com',UserRoleId='00E11000000FC1j' );       
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert user;
        }
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(20,'StandardVCode');
        jj_rb_VAT_Code__c vatcode1=  jj_rb_Rebate_TestClass.vatCodeCreator(120,'lowVCode');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Product', 'This is a Description of product', '1234567', '123','pieces','IMSP85369',vatcode.id);
        jj_rb_Rebate_Product__c sampleProduct = jj_rb_Rebate_TestClass.rebateProductCreator('sampleProduct', 'This is a Description of sample product', '8525369', '456','pieces','IMS56789',vatcode1.id);
        
        upsert Products;
        
        Account acc = jj_rb_Rebate_TestClass.accountCreator('1110',user.id,'retailer account data','1234567890','accountuser@jnj.com','90000',15000.00,'account street',' accountcity','accountstate','accountcountry','258963',Retailertype,'IMSC78956');  
        upsert acc;
        // retailer records
        jj_rb_Rebate_Contract__c contracts = jj_rb_Rebate_TestClass.rebateContractCreator(acc.Id, 'This is a retailer contract description',Status_approved,user.id,Retailercontract );
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem = rebateContractLineItemCreator(contracts.id,Products.id,date.parse('1/4/2014'),Date.parse('25/4/2014'),100.00,Status_approved ,True,retailercontractlines );
        
        jj_rb_Rebate_Claim__c claim=jj_rb_Rebate_TestClass.rebateClaimCreator(acc.id,'This is a claim Description',Status_approved,'april', '2014',RetailerRebateClaimRT);    
        jj_rb_Rebate_Claim_Line_Item__c RClaimline=jj_rb_Rebate_TestClass.rebateClaimlineitemCreator(claim.id,Products.id,500.00, 50.00,vatcode.id,RetailerclaimlineitemRT);
        jj_rb_Rebate_Claim_Line_Item__c RClaimlinenew=jj_rb_Rebate_TestClass.rebateClaimlineitemCreator(claim.id,sampleProduct.id,1500.00, 150.00,vatcode1.id,RetailerclaimlineitemRT);
        
        jj_rb_IMS_Sales_Data__c imsdata=jj_rb_Rebate_TestClass.imsSalesdataCreator(acc.id,'12345','1234567','IMS5847','IMSC78956','04','2014','IMSP85369',Products.id,'Risperdal 1mg *60',500.00);
        
        jj_rb_Retailer_Buying_Group__c Retailerbg=jj_rb_Rebate_TestClass.retailerBGCreator(acc.id);
       
        jj_rb_Retailer_Buying_Group_Member__c retailerbgMemberold=jj_rb_Rebate_TestClass.retailerBGMemberCreator(acc.id,Retailerbg.id);
        
        jj_rb_Retailer_Buying_Group_Member__c retailerbgMemberold1=jj_rb_Rebate_TestClass.retailerBGMemberCreator(acc.id,Retailerbg.id);
        jj_rb_Tolerance__c tolerance= jj_rb_Rebate_TestClass.ToleranceCreator(acc.id,Products.id,20,10,135);
        upsert Retailerbg;
        upsert retailerbgMemberold;
        //   upsert retailerbgMemberold1;
        
        
        //Homecare records
        jj_rb_Region__c regions=jj_rb_Rebate_TestClass.regionCreator('hyderabad','This is a region in AP');
        jj_rb_NHS_Trust__c nhstrust=jj_rb_Rebate_TestClass.NhstrustCreator('Test Trust',regions.id,'India','9874569852', '532586','andhrapradesh','Street1','32434');
        upsert regions;
        upsert nhstrust;
        Account HCPaccounttoday = jj_rb_Rebate_TestClass.homecareaccountCreator('3002', user.id,'todayhcpaccount','9632587410','todayhcp@jnjorg.com','1562','accStreet','acccity','accState','acccountry','56985',HomeCareType,Date.today()-5,Date.today(),homecareAccountRType);  
        Account Hospitalacc = jj_rb_Rebate_TestClass.hospitalaccountCreator('0101',nhstrust.id,'Hospital Test Account','3145639875','hospitalinap@org.in','0001','hospitalstreet','hospitalcity','ap','country','534301',HospitalType,hospitalAccountRType);                  
        upsert Hospitalacc;
        jj_rb_Rebate_Contract__c HCPcontracts = jj_rb_Rebate_TestClass.HCPContractCreator(Products.id, 'This is contract description', Status_approved,user.id,homecarecontract);    
        jj_rb_Rebate_Contract_Line_Item__c HCPcontractLineItem =jj_rb_Rebate_TestClass.HCPContractLineItemCreator(HCPcontracts.id,regions.id,date.parse('01/01/2014'),date.parse('30/01/2014'),100.00,Status_approved,false,homecarecontractlines);
        upsert HCPcontracts;
        upsert HCPcontractLineItem;
        jj_rb_Rebate_Claim__c hcpclaim= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPaccounttoday.id,'This is homecare claim',Status_approved,'january','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem= HCPClaimlineitemCreator(hcpclaim.id,Hospitalacc.id,Products.id,1500.00,1100.00,100,vatcode.id,homecareClaimlineitem);        
        
        jj_rb_Rebate_Claim__c hcpclaimfeb= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPaccounttoday.id,'This is homecare claim',Status_approved,'february','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitemfeb= HCPClaimlineitemCreator(hcpclaim.id,Hospitalacc.id,Products.id,2500.00,1200.00,200,vatcode.id,homecareClaimlineitem);
        
        jj_rb_Rebate_Claim__c hcpclaimmarch= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPaccounttoday.id,'This is homecare claim',Status_approved,'march','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitemmarch= HCPClaimlineitemCreator(hcpclaim.id,Hospitalacc.id,Products.id,3500.00,1500.00,300,vatcode.id,homecareClaimlineitem);
        
      
        
                
        Test.StartTest(); 
        upsert RClaimline;
        upsert RClaimlinenew;       
        RClaimline.jj_rb_Calculated_rebate_price__c=RcontractLineItem.jj_rb_Rebate__c;
        RClaimline.jj_rb_Assoc_Contract_Line_Item__c=RcontractLineItem.id;
        RClaimline.jj_rb_Calculated_quantity__c=imsdata.jj_rb_IMS_Volume__c;
        RClaimline.jj_rb_Assoc_IMS_Sales_Data__c=imsdata.id;    
        RClaimline.jj_rb_Tolerance_Failed_Qty__c=true;
        update RClaimline;
        upsert hcpclaimmarch;
        upsert claimlineitemmarch;  
        upsert hcpclaimfeb;
        upsert claimlineitemfeb;
       
        upsert hcpclaim;
        upsert claimlineitem; 
                   
        Test.StopTest();      
      
    }
    
    // testmethod for jj_rb_RebateAccrualCalcScheduler class
    
    static testMethod void RebateAccrualCalcScheduler()
    {
        Test.startTest();
        String CRON_EXP = '0 0 0 1 1 ? 2025';  
        String jobId = System.schedule('testScheduledApex', CRON_EXP, new jj_rb_RebateAccrualCalcScheduler() );
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];

        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
    
      // Test method for avgQuantityCalc class
    static testMethod void jj_rb_avgQuantityCalc()
    {
        string Status_approved = StatusCreator('Approved');
        String homecareClaim =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim','01211000000Cpfn');
        
        String homecareClaimlineitem =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim line item','01211000000Cpwo');  
        String hospitalAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Hospital','01211000000Cnx6'); 
        
        String HomeCareType = jj_rb_Rebate_TestClass.accountTypeCreator('Home Care Provider','Home care provider');
        String Hospitaltype = jj_rb_Rebate_TestClass.accountTypeCreator('Hospital','Hospital'); 
        String Retailertype = jj_rb_Rebate_TestClass.accountTypeCreator('Retailer Type','Retailer');
        String homecareAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Homecare','01211000000CpUV');
        List<Profile> profile = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User user = new User(Alias = 'service', Email='service@jnj.com',EmailEncodingKey='UTF-8', LastName='Indirectservice', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=profile[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='Indirectserviceforjnj@testorg.com',UserRoleId='00E11000000FC1j' );       
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert user;
        }
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(20,'StandardVCode');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Product', 'This is a Description of product', '1234567', '123','pieces','IMS1234',vatcode.id);   

        Account HCPaccount = jj_rb_Rebate_TestClass.homecareaccountCreator('2003', user.id,'hcpaccount','9493479132','hcpaccountnew@jnjorg.com','5003','HCPaccStreet','HCPacccity','HCPaccState','HCPacccountry','12584',HomeCareType,Date.today()-10,Date.today()+1,homecareAccountRType);
        upsert HCPaccount;
       
        
        jj_rb_Tolerance__c tolerance= jj_rb_Rebate_TestClass.ToleranceCreator(HCPaccount.id,Products.id,20,10,135);
        upsert tolerance;
        
          
        //Homecare records
        jj_rb_Region__c regions=jj_rb_Rebate_TestClass.regionCreator('hyderabad','This is a region in AP');
        jj_rb_NHS_Trust__c nhstrust=jj_rb_Rebate_TestClass.NhstrustCreator('Test Trust',regions.id,'India','9874569852', '532586','andhrapradesh','Street1','32434');
        upsert regions;
        upsert nhstrust;
        Account Hospitalacc1 = jj_rb_Rebate_TestClass.hospitalaccountCreator('9856',nhstrust.id,'Hospital sample Account','9856325698','hospitalinkarnataka@org.in','9635','hospitalsamplestreet','hospitalsamplecity','karnataka','samplecountry','98563',HospitalType,hospitalAccountRType);
        Account HCPaccounttoday = jj_rb_Rebate_TestClass.homecareaccountCreator('3002', user.id,'todayhcpaccount','9632587410','todayhcp@jnjorg.com','1562','accStreet','acccity','accState','acccountry','56985',HomeCareType,Date.today()-5,Date.today(),homecareAccountRType);  
        Account Hospitalacc = jj_rb_Rebate_TestClass.hospitalaccountCreator('0101',nhstrust.id,'Hospital Test Account','3145639875','hospitalinap@org.in','0001','hospitalstreet','hospitalcity','ap','country','534301',HospitalType,hospitalAccountRType);                  
        upsert Hospitalacc;
        
        jj_rb_Rebate_Claim__c hcpclaim= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPaccounttoday.id,'This is homecare claim',Status_approved,'january','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem= HCPClaimlineitemCreator(hcpclaim.id,Hospitalacc.id,Products.id,1500.00,1100.00,100,vatcode.id,homecareClaimlineitem);        
        
        jj_rb_Rebate_Claim__c hcpclaimfeb= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPaccounttoday.id,'This is homecare claim',Status_approved,'february','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitemfeb= HCPClaimlineitemCreator(hcpclaim.id,Hospitalacc.id,Products.id,2500.00,1200.00,200,vatcode.id,homecareClaimlineitem);
        
        jj_rb_Rebate_Claim__c hcpclaimmarch= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPaccounttoday.id,'This is homecare claim',Status_approved,'march','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitemmarch= HCPClaimlineitemCreator(hcpclaim.id,Hospitalacc.id,Products.id,3500.00,1500.00,300,vatcode.id,homecareClaimlineitem);
        
        
        List<jj_rb_Rebate_Claim__c> claimlist=[SELECT Id,Name,jj_rb_Claim_Date__c,jj_rb_Customer__c,(select id, name,jj_rb_Rebate_Product__r.name,jj_rb_Rebate_Product__c,jj_rb_Quantity__c from Rebate_Claim_Line_Items__r) FROM jj_rb_Rebate_Claim__c where jj_rb_Claim_Date__c = LAST_N_DAYS:1460 AND jj_rb_Status__c =:status_approved AND jj_rb_Claim_Date__c < today AND jj_rb_Customer__c!=null AND RecordTypeId=:homecareClaim order by jj_rb_Claim_Date__c desc];
        
        jj_rb_avgQuantityCalc obj= new jj_rb_avgQuantityCalc();     
        Database.executeBatch(obj);
        obj.start(null);
        obj.execute(null,claimlist);
        obj.finish(null);  
        obj.calAvgQuantity(claimlist);
        
           
        
    }
  
    static testMethod void jj_rb_handler()
    {
        String Retailercontract =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer Contract','01211000000CmNR');
        String homecarecontract =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Home care Provider contract','01211000000Cntd');
        String retailercontractlines =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer contract line item','01211000000CnwX');
        String homecarecontractlines =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('HCP Contract line item','01211000000CnwD');
        String homecareClaim =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim','01211000000Cpfn');
        String homecareClaimlineitem =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim line item','01211000000Cpwo');  
        String hospitalAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Hospital','01211000000Cnx6'); 
        
        String HomeCareType = jj_rb_Rebate_TestClass.accountTypeCreator('Home Care Provider','Home care provider');
        String Hospitaltype = jj_rb_Rebate_TestClass.accountTypeCreator('Hospital','Hospital'); 
        String Retailertype = jj_rb_Rebate_TestClass.accountTypeCreator('Retailer Type','Retailer');   
        string Status_approved = StatusCreator('Approved');
        string Status_new = StatusCreator('new');
        String homecareAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Homecare','01211000000CpUV');
        
        
        
        jj_rb_Region__c region1=jj_rb_Rebate_TestClass.regionCreator('bangalore','This is a region in Karnataka');
        jj_rb_NHS_Trust__c nhstrust1=jj_rb_Rebate_TestClass.NhstrustCreator('sample Trust',region1.id,'India','9853698745', '325698','karnataka','samllStreet','98745');
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(20,'StandardVCode');
        jj_rb_VAT_Code__c vatcode1=  jj_rb_Rebate_TestClass.vatCodeCreator(120,'lowVCode');
        jj_rb_Rebate_Product__c sampleProduct = jj_rb_Rebate_TestClass.rebateProductCreator('sampleProduct', 'This is a Description of sample product', '8525369', '456','pieces','IMS56789',vatcode1.id); 
        List<Profile> profile = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User user = new User(Alias = 'service', Email='service@jnj.com',EmailEncodingKey='UTF-8', LastName='Indirectservice', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=profile[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='Indirectserviceforjnj@testorg.com',UserRoleId='00E11000000FC1j' );       
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert user;
        }
        
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Product', 'This is a Description of product', '1234567', '123','pieces','IMS1234',vatcode.id);   
        Account HCPaccount = jj_rb_Rebate_TestClass.homecareaccountCreator('2003', user.id,'hcpaccount','9493479132','hcpaccountnew@jnjorg.com','5003','HCPaccStreet','HCPacccity','HCPaccState','HCPacccountry','12584',HomeCareType,Date.today()-10,Date.today()+1,homecareAccountRType);
        upsert HCPaccount;
        Account Hospitalacc1 = jj_rb_Rebate_TestClass.hospitalaccountCreator('9856',nhstrust1.id,'Hospital sample Account','9856325698','hospitalinkarnataka@org.in','9635','hospitalsamplestreet','hospitalsamplecity','karnataka','samplecountry','98563',HospitalType,hospitalAccountRType);
        
        jj_rb_Tolerance__c tolerance= jj_rb_Rebate_TestClass.ToleranceCreator(HCPaccount.id,Products.id,20,10,135);
        upsert tolerance;
        
        jj_rb_Rebate_Contract__c HCPcontracts1 = jj_rb_Rebate_TestClass.HCPContractCreator(Products.id, 'This is homecarecontract description', Status_new,user.id,homecarecontract);    
        jj_rb_Rebate_Contract_Line_Item__c HCPcontractLineItem1 =jj_rb_Rebate_TestClass.HCPContractLineItemCreator(HCPcontracts1.id,region1.id,date.parse('01/02/2014'),date.parse('20/02/2014'),100.00,Status_approved,false,homecarecontractlines);
        
        jj_rb_Rebate_Claim__c hcpclaim1= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPaccount.id,'This is homecare sample claim',Status_approved,'february','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem1= HCPClaimlineitemCreator(hcpclaim1.id,Hospitalacc1.id,Products.id,1500.00,1100.00,1100,vatcode.id,homecareClaimlineitem);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitemnew= HCPClaimlineitemCreator(hcpclaim1.id,Hospitalacc1.id,Products.id,1500.00,1100.00,1100,vatcode.id,homecareClaimlineitem);
        
        jj_rb_Region__c region2=jj_rb_Rebate_TestClass.regionCreator('mumbai','This is a region in mumbai');
        jj_rb_NHS_Trust__c nhstrust2=jj_rb_Rebate_TestClass.NhstrustCreator('new Trust',region2.id,'India','8523654789', '96325','mumbai','mumbaiStreet','98562');
        Account HCPacc2 = jj_rb_Rebate_TestClass.accountCreator('9856',user.id,'HCPnew Account','98523654878','hcpnewaccount@org.com','7895',10000.00,'newstreet','newcity','newstate','newcountry','358952',HomeCareType,'ims09384');
        Account Hospitalacc2 = jj_rb_Rebate_TestClass.hospitalaccountCreator('9856',nhstrust2.id,'Hospital new Account','3698521456','hospitalinmumbai@org.in','9635','hospitalsamplestreet','hospitalsamplecity','karnataka','samplecountry','96582',HospitalType,hospitalAccountRType);
        jj_rb_Rebate_Contract__c HCPcontracts2 = jj_rb_Rebate_TestClass.HCPContractCreator(Products.id, 'This is homecarenew contract description', Status_approved,user.id,homecarecontract);    
        jj_rb_Rebate_Contract_Line_Item__c HCPcontractLineItem2 =jj_rb_Rebate_TestClass.HCPContractLineItemCreator(HCPcontracts2.id,region1.id,date.parse('01/03/2014'),date.parse('30/03/2014'),100.00,Status_approved,false,homecarecontractlines);
        
        jj_rb_Rebate_Claim__c hcpclaim2= jj_rb_Rebate_TestClass.HCPClaimCreator(HCPacc2.id,'This is homecare provide claim',Status_approved,'march','2014',homecareClaim);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem2= HCPClaimlineitemCreator(hcpclaim2.id,Hospitalacc1.id,sampleProduct.id,1500.00,1100.00,1100,vatcode1.id,homecareClaimlineitem);
        
        //Retailer account records
        Account a = jj_rb_Rebate_TestClass.accountCreator('0200',user.id,'Retailer Test Account','8523698540','Retaileraccount@capgemini.com','2002',11000.00,'Retailerstreet','Retailercity','Retailerstate','Retailercountry','745698',Retailertype,'ims5847');
        
        
        //Retailer contract records
        jj_rb_Rebate_Contract__c Rcontracts = jj_rb_Rebate_TestClass.rebateContractCreator(a.Id, 'This is contract description', Status_approved,user.id,Retailercontract);    
        jj_rb_Rebate_Contract__c Rcontracts1 = jj_rb_Rebate_TestClass.rebateContractCreator(a.Id, 'This is contract description', Status_approved,user.id,Retailercontract);    
        
        
        jj_rb_Rebate_Product__c Productforretailer = jj_rb_Rebate_TestClass.rebateProductCreator('retailerproduct', 'This is Product Description', '589632', '658','piece','IMS52525',vatcode.id);
        jj_rb_Rebate_Product__c Products1 = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *6000', 'This is a new Product Description', '12345678', '12325','piece','IMS2978',vatcode.id);
        
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem = rebateContractLineItemCreator(Rcontracts.id,Productforretailer.id,date.today(),date.today()+2,100.00,'Modified',True,retailercontractlines );
        //  jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem1 = rebateContractLineItemCreator(Rcontracts.id,Products.id,date.Today()+11,date.Today()+20,100.00,'New',True,retailercontractlines );
        // jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem2 = rebateContractLineItemCreator(Rcontracts.id,Products1.id,date.today(),date.today()+22,100.00,'Modified',True,retailercontractlines );
        //  jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem3 = rebateContractLineItemCreator(Rcontracts.id,Products1.id,date.Today()+26,date.Today()+30,100.00,'New',True,retailercontractlines );        
        
    }
    
     // Test method for homecare notification class
    static testMethod void jj_rb_homecarenotification()
    {
        String HomeCareType = jj_rb_Rebate_TestClass.accountTypeCreator('Home Care Provider','Home care provider');
        
        String homecareAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Homecare','01211000000CpUV'); 
        List<Profile> profile = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User user = new User(Alias = 'sales', Email='sale@jnj.com',EmailEncodingKey='UTF-8', LastName='Indirectsales', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=profile[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='Indirectsalesforjnj@testorg.com',UserRoleId='00E11000000FC1j' );       
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert user;
        }
        Account HCPaccounttoday = jj_rb_Rebate_TestClass.homecareaccountCreator('3002', user.id,'todayhcpaccount','9632587410','todayhcp@jnjorg.com','1562','accStreet','acccity','accState','acccountry','56985',HomeCareType,Date.today()-5,Date.today(),homecareAccountRType);
        Account HCPaccount2weeks = jj_rb_Rebate_TestClass.homecareaccountCreator('2003',user.id,'2weeksHomecareAccount','69853652140','twoweekshomecareaccount@org.com','4523','homecarestreettwoweek','homecarecitytwoweek','homecarestatetwoweek','homecarecountrytwoweek','852336',HomeCareType,date.today(),Date.today()+14,homecareAccountRType);
        Account HCPaccount2months = jj_rb_Rebate_TestClass.homecareaccountCreator('30000',user.id,'2monthsHomecare Account','7894561230','twomonthhomecareaccount@org.com','6589','homecarestreettwomonths','homecarecitytwomonths','homecarestatetwomonths','homecarecountrytwomonths','6958',HomeCareType,date.today(),Date.today()+60,homecareAccountRType);
        test.startTest();
        upsert HCPaccounttoday;
        upsert HCPaccount2weeks;
        upsert HCPaccount2months;
        test.stopTest();
        jj_rb_Homecare_notification obj= new jj_rb_Homecare_notification();
        Database.executeBatch(obj);
        
    }
    
     // Test method for  jj_rb_Accrual_Report_Generation class
    static testMethod void jj_rb_Accrual_Report_Generation()
    {
        String HomeCareType = jj_rb_Rebate_TestClass.accountTypeCreator('Home Care Provider','Home care provider');
        String RetailerAccrualRecordType = jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Accrual Retailer','01211000000Cpwy');
        String HCPAccrualRecordType = jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Accrual HCP','01211000000Cpx3');
        string Status_approved = StatusCreator('Approved');
        
      
        String retaileraccrualreportRcType= jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Report Retailer','01211000000Cq0R');
        String hcpaccrualreportRcType= jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Report HCP','01211000000Cq0g');
        
        String RetialerReportType = jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Report Retailer','01211000000Cq0R');
        String HCPReportType = jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Report HCP','01211000000Cq0g');
        String Retailertype = jj_rb_Rebate_TestClass.accountTypeCreator('Retailer Type','Retailer'); 
        String homecareAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Homecare','01211000000CpUV');
        
        List<Profile> p = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='divyakasani@gmail.com',EmailEncodingKey='UTF-8', LastName='Testinguser', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=p[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='jnjuserfordev@testorg.com',UserRoleId='00E11000000FC1j' );       
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert u;
        }
        Account HCPaccount = jj_rb_Rebate_TestClass.homecareaccountCreator('3002', u.id,'hcpaccount','9493479132','hcpaccountnew@jnjorg.com','5003','HCPaccStreet','HCPacccity','HCPaccState','HCPacccountry','12584',HomeCareType,Date.today()-10,Date.today()+1,homecareAccountRType);
        upsert HCPaccount;
        Account a = jj_rb_Rebate_TestClass.accountCreator('0002',u.id,'Test Account','2145639875','mangadivya.kasani@capgemini.com','8009',1000.00,'street','city','state','country','534301',Retailertype,'IMS8478');  
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(20,'StandardVCode');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('new Product', 'This is a Description of product', '47859', '123','pieces','IMS12345',vatcode.id);
       
        
        //Retailer and hcp accrual records
        jj_rb_Rebate_Accrual__c retaileraccrual=jj_rb_Rebate_TestClass.rebateAccrualCreator(a.id, '04', '2014', u.id,RetailerAccrualRecordType,Status_approved);
        jj_rb_Rebate_Accrual__c hcpaccrual=jj_rb_Rebate_TestClass.rebateAccrualCreator(HCPaccount.id,'04', '2014', u.id,HCPAccrualRecordType,Status_approved);
        
        //retailer and hcp accrual line items rcords;
        jj_rb_Rebate_Accrual_Line_Item__c Retaileraccruallineitem=jj_rb_Rebate_TestClass.rebateAccrualLineitemCreator(retaileraccrual.id,10.0,500.00,Products.id,400.00,100.00);
        jj_rb_Rebate_Accrual_Line_Item__c hcpaccruallineitem=jj_rb_Rebate_TestClass.rebateAccrualLineitemCreator(hcpaccrual.id,210.0,1500.00,Products.id,1400.00,1100.00);
        upsert retaileraccrual;
        upsert hcpaccrual;
        upsert Retaileraccruallineitem;
        upsert hcpaccruallineitem;
        List<jj_rb_Rebate_Accrual_Line_Item__c> accruallistquery=[select Id, jj_rb_Product__c, jj_rb_Net_Rebate_Accrual_After_Adj__c, 
                                                                        jj_rb_Volume__c,jj_rb_Rebate_Accrual__r.RecordTypeId 
                                                                    from jj_rb_Rebate_Accrual_Line_Item__c 
                                                                    where jj_rb_Rebate_Accrual__r.jj_rb_Status__c = 'Approved'                                                                   
                                                                    order by jj_rb_Product__c];
        
        jj_rb_Rebate_Accrual_Report__c Retaileraccrualreport=jj_rb_Rebate_TestClass.rebateAccrualReportCreator(True,DateTime.now().format('MM'),DateTime.now().format('YYYY'),retaileraccrualreportRcType);
        jj_rb_Rebate_Accrual_Report_Line_Item__c Retaileraccrualreportlineitem=jj_rb_Rebate_TestClass.rebateAccrualReportlineitemCreator(1500.00,50.00,Retaileraccrualreport.id,Products.id);
        
        jj_rb_Rebate_Accrual_Report__c hcpaccrualreport=jj_rb_Rebate_TestClass.rebateAccrualReportCreator(True,DateTime.now().format('MM'),DateTime.now().format('YYYY'),hcpaccrualreportRcType);
        jj_rb_Rebate_Accrual_Report_Line_Item__c hcpaccrualreportlineitem=jj_rb_Rebate_TestClass.rebateAccrualReportlineitemCreator(1500.00,50.00,hcpaccrualreport.id,Products.id);
        
        
        test.startTest();
        upsert Retaileraccrualreport;
        upsert Retaileraccrualreportlineitem;
        upsert hcpaccrualreport;
        upsert hcpaccrualreportlineitem;
        test.stopTest();
        
        jj_rb_Accrual_Report_Generation obj= new jj_rb_Accrual_Report_Generation();    
        Database.executeBatch(obj);
        obj.start(null);
        obj.execute(null,accruallistquery);
        obj.finish(null);  
        
    }
    
      // Test method for  jj_rb_rebateAccrualBaseClass class,RetailerAccrual and HCPAccrualcal classes 
    static testMethod void jj_rb_rebateAccrualBaseClass()
    {
        //retailer contracts
        string Status_approved = StatusCreator('Approved');
        String Retailertype = jj_rb_Rebate_TestClass.accountTypeCreator('Retailer Type','Retailer');   
        String retailercontractlines =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer contract line item','01211000000CnwX');
        String Retailercontract =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer Contract','01211000000CmNR');
      
        string Status_new = jj_rb_Rebate_TestClass.customsettingCreator('New','New');
        String RetailerAccrualRecordType = jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Accrual Retailer','01211000000Cpwy');
        
        String Cust_RecordTyp =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer Customer Master Data Request','01211000000CjaX');
        String RetailerRebateClaimRT =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer Rebate Claim','01211000000Ck8K');
        String RetailerclaimlineitemRT =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer claim line item','01211000000Ck8e');
        String hospitalAccountRType=jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Account Hospital','01211000000Cnx6');
        String homecareClaim =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim','01211000000Cpfn');
        String homecareClaimlineitem =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Homecare claim line item','01211000000Cpwo');
        
        List<Profile> profile = [select id, name from Profile where  name = 'System Administrator' limit 1]; 
        User user = new User(Alias = 'retailer', Email='retailer@jnj.com',EmailEncodingKey='UTF-8', LastName='Indirectretailer', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=profile[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='Indirectretailerjnj@testorg.com',UserRoleId='00E11000000FC1j' );
        System.runAs ( new User(Id = UserInfo.getUserId()) )
        {
           insert user;
        }
        Account acc = jj_rb_Rebate_TestClass.accountCreator('0369',user.id,'Retailer Test Account','8745698523','retailertestaccount@org.com','8745',20000.00,'retailerstreet','retailercity','retailerstate','retailercountry','74568',retailertype,'ims5847569');
        
        
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(20,'StandardVCode');
        jj_rb_VAT_Code__c vatcode1=  jj_rb_Rebate_TestClass.vatCodeCreator(500,'Vat1');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Product', 'This is a Description of product', '1234567', '123','pieces','IMS1234',vatcode.id);
        jj_rb_Rebate_Product__c Products1 = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *600', 'This is Product Description', '12345678', '1234','pieces','IMS23434',vatcode1.id);
        
        jj_rb_Rebate_Contract__c Rcontracts = jj_rb_Rebate_TestClass.rebateContractCreator(acc.Id, 'This is contract description', Status_approved,user.id,Retailercontract);
        jj_rb_Rebate_Contract_Line_Item__c RcontractLineItem = rebateContractLineItemCreator(Rcontracts.id,Products.id,date.today(),date.today()+5,100.00,Status_approved,True,retailercontractlines );
        upsert Rcontracts;
        upsert RcontractLineItem;
        
        List<jj_rb_Rebate_Contract_Line_Item__c>  listcons=[SELECT jj_rb_Rebate_Contract__r.jj_rb_Customer__c,jj_rb_Rebate_Contract__r.recordtypeid FROM jj_rb_Rebate_Contract_Line_Item__c where jj_rb_End_Date__c >= today and jj_rb_Rebate_Contract__r.jj_rb_Customer__c != null and jj_rb_Rebate_Contract__r.recordtypeid =: Retailercontract];
        System.assertEquals(1,listcons.size());    
        List<Account> listAccount = [select Id,Name, jj_rb_National_Channel_Manager__c,
                                             jj_rb_SAP_Customer_Number__c, jj_rb_SAP_Vendor_Number__c 
                                            from Account where id=:RcontractLineItem.jj_rb_Rebate_Contract__r.jj_rb_Customer__c];
        
        
        //jj_rb_Master_Data_OwnerID__c rc=[select id from jj_rb_Master_Data_OwnerID__c where name='OwnerID'];
        /*jj_rb_Master_Data_Request__c NewCust = jj_rb_Rebate_TestClass.MDR_CustomerCreator('00511000000uQ6h',2,'9006','Boots Ltd',Status_new,'65892',Cust_RecordTyp);
        jj_rb_Estimated_Rebate_Accrual__c estdAccrual=jj_rb_Rebate_TestClass.estimatedAccrualCreator(acc.id,NewCust.id,Products.id,500.00);
        
        upsert estdAccrual;
        List<jj_rb_Estimated_Rebate_Accrual__c> listEstimatedAccruals=[select Id, Name, jj_rb_Estimated_Accrual__c,jj_rb_Rebate_Product__c, jj_rb_Account__c
                                                                        from jj_rb_Estimated_Rebate_Accrual__c
                                                                        where jj_rb_Account__c=:RcontractLineItem.jj_rb_Rebate_Contract__r.jj_rb_Customer__c];*/
        //System.assertEquals(0,listEstimatedAccruals.size() );                                                                 
        jj_rb_Rebate_Claim__c claim=jj_rb_Rebate_TestClass.rebateClaimCreator(RcontractLineItem.jj_rb_Rebate_Contract__r.jj_rb_Customer__c,'This is a  claim',Status_Approved,'january', '2014',RetailerRebateClaimRT);
        jj_rb_Rebate_Claim_Line_Item__c claimlineitem=jj_rb_Rebate_TestClass.rebateClaimlineitemCreator(claim.id, Products.id, 100.00, 500.00, vatcode.id,RetailerclaimlineitemRT);
        
        test.startTest();
        upsert claim;
        upsert claimlineitem;        
        test.stopTest();
        
        
        List<jj_rb_Rebate_Claim__c> claimlists=[SELECT Id, Name, jj_rb_Claim_Date__c, jj_rb_Customer__c, 
                                                    (select id, name, jj_rb_Rebate_Product__c, jj_rb_Quantity__c,
                                                            jj_rb_Net_Rebate__c from Rebate_Claim_Line_Items__r) 
                                                        FROM jj_rb_Rebate_Claim__c 
                                                        where jj_rb_Claim_Date__c = LAST_N_DAYS:730
                                                        and recordtypeid =:RetailerRebateClaimRT 
                                                         and jj_rb_Status__c =:Status_approved];
                                                   
        //System.assertEquals(1,claimlists.size() );                                               
        jj_rb_HCPAccrualcalc obj= new jj_rb_HCPAccrualcalc();
        Database.executeBatch(obj);

                       
        jj_rb_RetailerAccrualCalc obj1= new jj_rb_RetailerAccrualCalc();    
        Database.executeBatch(obj1);
        jj_rb_Accrual_Actions ob= new jj_rb_Accrual_Actions();
        jj_rb_Accrual_Actions.executeCalcBatch();
        jj_rb_Accrual_Actions.createBatchReport();
        
    }
    
    
    //Test method for jj_rb_Estimated_Accrual_after_insert Trigger
    static testMethod void jj_rb_Estimated_Accrual_after_insertTest()
    {
        String retailertype=jj_rb_Rebate_TestClass.accountTypeCreator('Retailer Type','Retailer'); 
        List<Profile> p = [select id, name from Profile where  name = 'System Administrator' limit 1];
        User u = new User(Alias = 'standt', Email='divyakasani@gmail.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId=p[0].id,TimeZoneSidKey='America/Los_Angeles', UserName='jnjuser@testorg.com',UserRoleId='00E11000000FC1j' );
        Account a = jj_rb_Rebate_TestClass.accountCreator('0002',u.id,'Test Account','2145639875','mangadivya.kasani@capgemini.com','8009',1000.00,'street','city','state','country','534301',retailertype,'ims584722');  
        jj_rb_VAT_Code__c vatcode=  jj_rb_Rebate_TestClass.vatCodeCreator(50,'Vat0');
        jj_rb_VAT_Code__c vatcode1=  jj_rb_Rebate_TestClass.vatCodeCreator(500,'Vat1');
        jj_rb_Rebate_Product__c Products = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *60', 'This is Product Description', '1234567', '123','pieces','IMS2343',vatcode.id);        
        jj_rb_Rebate_Product__c Products1 = jj_rb_Rebate_TestClass.rebateProductCreator('Risperdal 1mg *600', 'This is Product Description', '12345678', '1234','pieces','IMS23434',vatcode1.id);                
        // Custom setting records for status and record types
        string Status_new = jj_rb_Rebate_TestClass.customsettingCreator('New','New');
        //jj_rb_Master_Data_OwnerID__c rc=[select id from jj_rb_Master_Data_OwnerID__c where name='OwnerID'];
        String Cust_RecordTyp =jj_rb_Rebate_TestClass.MDReocrdTypeCreator('Retailer Customer Master Data Request','01211000000CjaX');        
        
        // MDR record
       // jj_rb_Master_Data_Request__c NewCust = jj_rb_Rebate_TestClass.MDR_CustomerCreator('00511000000uQ6h',2,'9006','Boots Ltd',Status_new,'23659',Cust_RecordTyp);
        
        //Estimated RA records with different products
        //jj_rb_Estimated_Rebate_Accrual__c estdAccrual=jj_rb_Rebate_TestClass.estimatedAccrualCreator(a.id,NewCust.id,Products.id,500.00); 
       
       // jj_rb_Estimated_Rebate_Accrual__c estdAccrual2=jj_rb_Rebate_TestClass.estimatedAccrualCreator(a.id,NewCust.id,Products1.id,500.00); 
      
        exception e;
        test.startTest();
        try{
        //upsert estdAccrual;
       
        //upsert estdAccrual2;
      
        }
        catch(Exception ex)
        {
            e=ex;
        }
        test.stopTest();
    }
   
}