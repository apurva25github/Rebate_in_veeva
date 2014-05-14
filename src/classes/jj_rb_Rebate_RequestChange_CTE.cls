public class jj_rb_Rebate_RequestChange_CTE 
    {
        private jj_rb_Rebate_Product__c rebateProduct;
        public jj_rb_Master_Data_Request__c MDR {get; set;}
        String RetailerType = jj_rb_Rebate_Utils.getAccountType('Retailer Type');    
        String HCPType = jj_rb_Rebate_Utils.getAccountType('Home Care Provider');
        String HospitalType = jj_rb_Rebate_Utils.getAccountType('Hospital');
        id retailerID = jj_rb_Rebate_Utils.getRecordTypeId('Account_Retailer');
        id hcpID = jj_rb_Rebate_Utils.getRecordTypeId('Account_Homecare');
        id hospID = jj_rb_Rebate_Utils.getRecordTypeId('Account_Hospital');
        
        // Controlls visibility of fields on VF page
        public boolean showSAP_customer {get; set;}
        public boolean showSAP_vendor{get; set;}
        public boolean showIMS_id {get; set;}
        public boolean showhospital_ids {get; set;}
        public boolean showHCP_dates {get; set;}
        public boolean showNCM {get; set;}
        public boolean showRegion{get; set;}
        public Account customer;    
        ApexPages.StandardController controller;
        
        
        public jj_rb_Rebate_RequestChange_CTE(ApexPages.StandardController controller) 
        {
            this.controller=controller; 
        }
        
        // this function runs at page load
        public void ProductPageLoad()
        {
            rebateProduct = (jj_rb_Rebate_Product__c)controller.getRecord();
           // query the rebate product
           rebateProduct = [select Id, name,
                                        jj_rb_Description__c, 
                                        jj_rb_SAP_Material_Number__c,
                                        jj_rb_SAP_EAN_Code__c,
                                        jj_rb_Unit_of_Measure__c,jj_rb_IMS_Product_ID__c,jj_rb_VAT_Code__c 
                            from jj_rb_Rebate_Product__c where id = :rebateProduct.Id limit 1];
            
            MDR = new jj_rb_Master_Data_Request__c();   
            MDR.jj_rb_Rebate_Request_Change_For_ID__c = rebateProduct.id;    
            MDR.jj_rb_Product_Name__c =  rebateProduct.Name;
            MDR.jj_rb_SAP_Description__c = rebateProduct.jj_rb_Description__c;
            MDR.jj_rb_SAP_Material_Code__c = rebateProduct.jj_rb_SAP_Material_Number__c;
            MDR.jj_rb_SAP_EAN_Code__c = rebateProduct.jj_rb_SAP_EAN_Code__c; 
            MDR.jj_rb_Unit_of_Measure__c = rebateProduct.jj_rb_Unit_of_Measure__c;
            MDR.jj_rb_IMS_Product_ID__c = rebateProduct.jj_rb_IMS_Product_ID__c;
            MDR.jj_rb_VAT_Code__c =rebateProduct.jj_rb_VAT_Code__c;
            MDR.RecordTypeId = jj_rb_Rebate_Utils.getRecordTypeId('Product_Data_Request');  
        } 
        
       
        public void AccountPageLoad()
        {
            // get the record being changed
            customer = (Account)controller.getRecord();
            customer = [select id ,name, jj_rb_SAP_Customer_Number__c,
                       jj_rb_National_Channel_Manager__c,RecordTypeId,
                        jj_rb_Credit_check_Validity_End__c,jj_rb_Credit_check_Validity_From__c,
                        jj_rb_SAP_Vendor_Number__c,jj_rb_IMS_Customer_Id__c,
                        Primary_Parent_vod__c,Account_Type__c,jj_rb_Region__c
                       FROM Account
                       Where id =: customer.id limit 1];
             MDR = new jj_rb_Master_Data_Request__c();
            MDR.jj_rb_Rebate_Request_Change_For_ID__c = customer.Id;
            MDR.jj_rb_Business_Name__c = customer.Name;
            MDR.jj_rb_National_Channel_Manager__c = customer.jj_rb_National_Channel_Manager__c;            
            MDR.jj_rb_IMS_Customer_Id__c = customer.jj_rb_IMS_Customer_Id__c;
            //MDR.jj_rb_IMS_Customer_Id__c = customer.jj_rb_IMS_Customer_Id__c;
            if(customer.RecordTypeId == retailerID)
            {
                showSAP_customer = true;
                showSAP_vendor = true;
                showhospital_ids = false;
                showIMS_id = true;
                showHCP_dates = false;
                showNCM = true;
                showRegion = false;
                MDR.jj_rb_SAP_Customer_Number__c=customer.jj_rb_SAP_Customer_Number__c;
                MDR.jj_rb_SAP_Vendor_Number__c = customer.jj_rb_SAP_Vendor_Number__c;
                MDR.RecordTypeId = jj_rb_Rebate_Utils.getRecordTypeId('Retailer_MDR');
            }
            else if(customer.RecordTypeId == hcpID)
            {
                showIMS_id = false;
                showSAP_customer = true;
                showSAP_vendor = false;
                showhospital_ids = false;
                showHCP_dates = true;
                showNCM = true;
                showRegion = false;
                MDR.jj_rb_SAP_Customer_Number__c=customer.jj_rb_SAP_Customer_Number__c;
                MDR.jj_rb_Credit_check_Validity_From__c = customer.jj_rb_Credit_check_Validity_From__c;
                MDR.jj_rb_Credit_check_Validity_End__c = customer.jj_rb_Credit_check_Validity_End__c;
            
                MDR.RecordTypeId = jj_rb_Rebate_Utils.getRecordTypeId('Homecare_MDR');
            }
            else if(customer.RecordTypeId == hospID)
            {
                showSAP_customer = false; 
                showSAP_vendor = false;
                showhospital_ids = true;
                showIMS_id = false;
                showHCP_dates  = false;
                showNCM = false;
                showRegion = true;
                MDR.jj_rb_Region__c = customer.jj_rb_Region__c;
                MDR.RecordTypeId = jj_rb_Rebate_Utils.getRecordTypeId('Hospital_Data_Request');
                
            }
        }
        // Click event handler for the submit for approval button
        // on the product change
        public pageReference submitForChange()
        {
           try{
                insert(MDR);
            }
            catch(Exception e)
            {                
                 return null;        
            }
            if(customer != null)
            {
            List <jj_rb_Estimated_Rebate_Accrual__c> listERA = new list<jj_rb_Estimated_Rebate_Accrual__c>();
            List <jj_rb_Estimated_Rebate_Accrual__c> updateERA = new list<jj_rb_Estimated_Rebate_Accrual__c>();
            listERA = [select id,jj_rb_Master_Data_request__c,jj_rb_account__c 
                       from jj_rb_Estimated_Rebate_Accrual__c
                       where jj_rb_account__c =: customer.id];
            for(jj_rb_Estimated_Rebate_Accrual__c ERA : listERA) 
            {
                ERA.jj_rb_Master_Data_request__c = MDR.id;
                updateERA.add(ERA);
            }
            update updateERA;
            }
            
            
            // redirect to the detail page of the master data request record
            Pagereference p =  new ApexPages.StandardController(MDR).view(); 
            p.setRedirect(true);
            return p;
        }
        
        //Cancel Changes.
        //Back to the Detail Page.
        public pageReference Cancel()
        {
            PageReference can = controller.cancel();
            return can;
        }
    }