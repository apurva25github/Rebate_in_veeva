/**********************************************************************
 Name:  Rebate_MasterDataRequestConvert_After_Update Trigger
 Capgemini India Ltd 

 Purpose:
    Convert Master Date request into Account/Rebate Product.

 History:
 VERSION  AUTHOR            DATE              DETAIL                                 
 1.0      Apurva Prasade    06/02/2014        Created trigger

***********************************************************************/ 

trigger jj_rb_Rebate_MasterDataRequestConvert_After_Update on jj_rb_Master_Data_Request__c (after update) 
{
    // custom settings
    
        // Status    
    String statusApproved = jj_rb_Rebate_utils.getRebateLineItemStatus('Approved');
        // Record Type IDs
    id AccountRecordTypeID=jj_rb_Rebate_utils.getRecordTypeId('Retailer_MDR');
    ID ProductRecordTypeID=jj_rb_Rebate_utils.getRecordTypeId('Product_Data_Request');
    ID HCPRecordTypeID = jj_rb_Rebate_utils.getRecordTypeId('Homecare_MDR');
    ID HospitalRecordTypeID = jj_rb_Rebate_utils.getRecordTypeId('Hospital_Data_Request');    
    
        // Account Types
    String RetailerType = jj_rb_Rebate_utils.getAccountType('Retailer Type');    
    String HCPType = jj_rb_Rebate_utils.getAccountType('Home Care Provider');
    String HospitalType = jj_rb_Rebate_utils.getAccountType('Hospital');
        
    Account acc=new Account();
                
    List<jj_rb_Master_Data_Request__c> listUpdatedMDR = new List<jj_rb_Master_Data_Request__c>();
    List<jj_rb_Estimated_Rebate_Accrual__c> listUpdateERA = new List<jj_rb_Estimated_Rebate_Accrual__c>();
    List<jj_rb_Estimated_Rebate_Accrual__c> listId  = new List<jj_rb_Estimated_Rebate_Accrual__c>();
    List<jj_rb_NHS_Trust__c> listupdateNHSTrust = new list<jj_rb_NHS_Trust__c>();
    Map <id,Account> MapAccount = new Map<id,Account>();    
    Map <id,jj_rb_Rebate_Product__c> MapProduct = New Map<id,jj_rb_Rebate_Product__c>();
    Map <id,jj_rb_Estimated_Rebate_Accrual__c> MapERA = New Map<id,jj_rb_Estimated_Rebate_Accrual__c>();
    MAP <id,jj_rb_NHS_Trust__c> MapHNS = new MAP <id,jj_rb_NHS_Trust__c>();
    //Iterate over Newly updated Records in Master Data Request Object
    for(jj_rb_Master_Data_Request__c MDR:trigger.new)
    {
        System.debug('Trigger Working *********** '+MDR.RecordTypeId+' '+MDR.jj_rb_Business_Name__c+' '+MDR.jj_rb_Product_Name__c);
            // check status and Record type.
            // If the Record is of Account object then add Record in a List
            If(MDR.jj_rb_Status__c != trigger.oldMap.get(MDR.id).jj_rb_Status__c 
                        && MDR.jj_rb_Status__c == statusApproved 
                        && (MDR.RecordTypeId == AccountRecordTypeID 
                        || MDR.RecordTypeId == HCPRecordTypeID 
                        || MDR.RecordTypeId == HospitalRecordTypeID))
            { 
            
                acc.id = MDR.jj_rb_Rebate_Request_Change_For_ID__c;
                acc.Name = MDR.jj_rb_Business_Name__c;
                //acc.jj_rb_SAP_Customer_Number__c = MDR.jj_rb_SAP_Customer_Number__c;
                acc.jj_rb_National_Channel_Manager__c = MDR.jj_rb_National_Channel_Manager__c;                
                acc.jj_rb_SAP_Customer_Number__c = MDR.jj_rb_SAP_Customer_Number__c;
                acc.jj_rb_SAP_Vendor_Number__c = MDR.jj_rb_SAP_Vendor_Number__c;
                //acc.jj_rb_IMS_Customer_Id__c = MDR.jj_rb_IMS_Customer_Id__c;
                
                if(MDR.RecordTypeId == AccountRecordTypeID  )
                {
                    acc.jj_rb_IMS_Customer_Id__c = MDR.jj_rb_IMS_Customer_Id__c;
                    
                    acc.RecordTypeId = jj_rb_Rebate_utils.getRecordTypeId('Account_Retailer');
                }
                else if(MDR.RecordTypeId == HCPRecordTypeID)
                {
                    acc.jj_rb_Credit_check_Validity_From__c = MDR.jj_rb_Credit_check_Validity_From__c ;
                    acc.jj_rb_Credit_check_Validity_End__c = MDR.jj_rb_Credit_check_Validity_End__c;
                    acc.RecordTypeId = jj_rb_Rebate_utils.getRecordTypeId('Account_Homecare');
                }
                
               else if(MDR.RecordTypeId == HospitalRecordTypeID )
               {
                   acc.Type = HospitalType;
                   acc.RecordTypeId = jj_rb_Rebate_utils.getRecordTypeId('Account_Hospital');
                   acc.jj_rb_NHS_Trust__c = MDR.jj_rb_NHS_Trust__c;
               }
               
               MapAccount.put(MDR.Id, acc);
            }  
           
            // check status and Record type.
            // If the Record is of Rebate Product object then add Record in a List
            if(MDR.jj_rb_Status__c != trigger.oldMap.get(MDR.id).jj_rb_Status__c && MDR.jj_rb_Status__c == statusApproved && MDR.RecordTypeId == ProductRecordTypeID)
            {
                jj_rb_Rebate_Product__c product=new jj_rb_Rebate_Product__c();
                product.id = MDR.jj_rb_Rebate_Request_Change_For_ID__c;
                product.jj_rb_Description__c = MDR.jj_rb_SAP_Description__c;
                product.jj_rb_SAP_EAN_Code__c = MDR.jj_rb_SAP_EAN_Code__c;
                product.jj_rb_SAP_Material_Number__c = MDR.jj_rb_SAP_Material_Code__c;
                product.jj_rb_Unit_of_Measure__c = MDR.jj_rb_Unit_of_Measure__c;
                product.jj_rb_IMS_Product_ID__c = MDR.jj_rb_IMS_Product_ID__c;
                //product.OwnerId = jj_rb_Rebate_utils.getMasterDataOwnerID('Master Data Owner ID');
                product.jj_rb_VAT_Code__c = MDR.jj_rb_VAT_Code__c;
                //RebateProductList.add(product);
                MapProduct.put(MDR.id,product);
            }
    }
    
    if(MapAccount.size()>0)
    { 
        upsert(MapAccount.values());
        listId = [select id,jj_rB_Account__c,jj_rb_Master_Data_Request__c,jj_rb_Estimated_Accrual__c,jj_rb_Rebate_Product__c
                    from jj_rb_Estimated_Rebate_Accrual__c
                    where jj_rb_Master_Data_Request__c in : MapAccount.keySet()];
                   
        for(ID mdrId : MapAccount.keySet())
        {               
            Account a = MapAccount.get(mdrId);
            jj_rb_Master_Data_Request__c m = new jj_rb_Master_Data_Request__c(id=mdrId);
            m.jj_rb_Customer__c = a.Id;
            for(jj_rb_Estimated_Rebate_Accrual__c ERA : listId )
            {
                if(ERA.jj_rb_Master_Data_Request__c == mdrId)
                {
                    jj_rb_Estimated_Rebate_Accrual__c updateERA = new jj_rb_Estimated_Rebate_Accrual__c(id=ERA.id); 
                    updateERA.jj_rb_Account__c =  a.Id;
                    listUpdateERA.add(updateERA);
                }
            }
            listUpdatedMDR.add(m);
        }
        
    }
    List<Database.UpsertResult> listProduct = new List<Database.UpsertResult>();
    if(MapProduct.size()>0)
    {
        try{
        listProduct = Database.upsert(MapProduct.values());
        }
        catch(Exception e)
        {
                 
        }
        for(ID mdrid : MapProduct.keySet())
        {
            jj_rb_Rebate_Product__c RProduct = MapProduct.get(mdrid);
            jj_rb_Master_Data_Request__c m = new jj_rb_Master_Data_Request__c(id=mdrid);
            m.jj_rb_Rebate_Product__c = RProduct.Id;
            listUpdatedMDR.add(m);
        }
    }
    if(!listUpdatedMDR.isEmpty())
    {
        update listUpdatedMDR;
    } 
    if(!listUpdateERA.isEmpty())
    {
        update listUpdateERA ;
    }
    
}