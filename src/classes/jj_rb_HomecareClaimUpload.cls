/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  15/04/2014
     @description  Controller class of the Homecare upload page 
 
     Function: Handles the controller logic for the Homecare upload page.
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    15/04/2014      Original Version
 */
public class jj_rb_HomecareClaimUpload extends jj_rb_HomecareUploadBaseClass {
    public Boolean showUploadMsg {get; set;}
    public Boolean errorInUpload {get; set;}
    public String MSG_INVALID_FILE = 'Invalid file selected for upload. Please select a .CSV file.';
    
    public  Document document {
        get { 
          if (document == null)
            document = new Document();  
          return document;
        }
        set;
     } 
     
   //constructor
   public jj_rb_HomecareClaimUpload()
   {}
   
   public jj_rb_HomecareClaimUpload(Apexpages.StandardController con)
   {  } 
   
   public jj_rb_HomecareClaimUpload(Apexpages.StandardSetController con)  
   {   }
   
   // function to validate the file being uploaded.
   public Boolean invalidFile(Document doc)
   {
   	if(String.isBlank(doc.Name)) {
   		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, MSG_INVALID_FILE));
   		return true;  
   	}	 	
   	if(!doc.Name.toUpperCase().contains('.CSV')) {
   		Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, MSG_INVALID_FILE));
   		return true;
   	}	
   	return false;	
   }
     
   public void upload() 
   {  	 
   	
     system.debug('Document.body>>>' + document.body); 
     system.debug('Document Name>>>>' + document.Name);
     system.debug('Document type>>>>' + document.Type);
     errorInUpload = false;
     showUploadMsg = true;
     
     if(invalidFile(document)) {
     	document.body = null;     	
     	return;
     }
     	
     
     // parse the records and get all the rows for all the columns
     List<List<String>> listParsedCSV = parseCSV(document.body.toString(), false);
     
     // map these parsed records to the wrapper object
     InvoiceWrapper invoiceWrapper = getMappedRecords(listParsedCSV); 
     
     system.debug('invoiceWrapper>>>>' + invoiceWrapper); 
      
     // upload the mapped records, if no error records are available
     if (invoiceWrapper.errorRecords.isEmpty() && invoiceWrapper.mapInvoiceData != null)
     {
        // upload the records   
        uploadRecords(invoiceWrapper);
     }
     
     if (!invoiceWrapper.errorRecords.isEmpty()) {
        // process the error records
        processErrorRecords(invoiceWrapper.errorRecords);
     }  
     
     document.body = null;     
   } 
   
   
   private void uploadRecords(InvoiceWrapper invoiceWrapper)
   {          
          List<jj_rb_Rebate_Claim_Line_Item__c> claimLineItems = new List<jj_rb_Rebate_Claim_Line_Item__c>();         
          List<jj_rb_Rebate_Claim__c> claims = new List<jj_rb_Rebate_Claim__c>(); 
             
                  
          String homecareClaimRecordType = jj_rb_Rebate_Utils.getRecordTypeId('Claim_Homecare');
          String homecareCLIRecordType = jj_rb_Rebate_Utils.getRecordTypeId('Claim_LineItem_Homecare');
          
         
          Map<String, List<InvoiceData>> mapInvData; 
          try {
                mapInvData = invoiceWrapper.mapInvoiceData;
                if(mapInvData != null)
                {
                        for(String uniqueKey : mapInvData.KeySet())
                        {
                                List<InvoiceData> listInvData = mapInvData.get(uniqueKey);
                                
                                if (listInvData != null && !listInvData.isEmpty())
                                {
                                        // create a claim record
                                        List<String> uniqueKeys = uniqueKey.split('_');
                                        String sapCustomerNo = uniqueKeys[0];
                                        String month = uniqueKeys[1];
                                        String year = uniqueKeys[2];
                                        
                                        jj_rb_Rebate_Claim__c claim = new jj_rb_Rebate_Claim__c();
                                        claim.jj_rb_Dataload_external_Id__c = uniqueKey;
                                        claim.jj_rb_Customer__r = new Account();                                
                                        claim.jj_rb_Customer__r.jj_rb_SAP_Customer_Number__c = sapCustomerNo;
                                        
                                        // if month value specified as a single charachter,
                                        // append 0 to it.
                                        if(String.isNotBlank(month) && month.length() == 1)
                                            month = '0' + month;
                                            
                                        claim.jj_rb_Month__c = month;
                                        claim.jj_rb_Year__c = year;                                     
                                        claim.RecordTypeId = homecareClaimRecordType; 
                                        claims.add(claim);
                                        
                                        for(InvoiceData invData : listInvData)
                                        {
                                                  // create claim line item records
                                                  jj_rb_Rebate_Claim_Line_Item__c claimLineItem = new jj_rb_Rebate_Claim_Line_Item__c();                  
                                                  claimLineItem.jj_rb_Rebate_Claim__r = new jj_rb_Rebate_Claim__c();
                                                  claimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Dataload_external_Id__c = uniqueKey;
                                                  claimLineItem.jj_rb_Hospital__r = new Account();
                                                  //claimLineItem.jj_rb_Hospital__r.jj_rb_iConnect_ID__c = invData.hospitalId;
                                                  claimLineItem.jj_rb_Hospital__r.CODS_External_Id__c = invData.hospitalId;
                                                  claimLineItem.jj_rb_Rebate_Product__r = new jj_rb_Rebate_Product__c();
                                                  claimLineItem.jj_rb_Rebate_Product__r.jj_rb_SAP_EAN_Code__c = invData.productEANCode;
                                                  claimLineItem.jj_rb_Quantity__c = invData.qty;
                                                  claimLineItem.jj_rb_Unit_List_Price__c = invData.unitListPrice;
                                                  claimLineItem.jj_rb_Unit_Contract_Price__c = invData.unitContractPrice;
                                                  claimLineItem.jj_rb_Rebate_Per_Unit__c = invData.unitRebate; 
                                                  
                                                  claimLineItem.jj_rb_VAT_Code__r = new jj_rb_VAT_Code__c();
                                                  claimLineItem.jj_rb_VAT_Code__r.jj_rb_VAT_External_Id__c = invData.vatCode;
                                                  claimLineItem.RecordTypeId = homecareCLIRecordType;
                                                  claimLineItems.add(claimLineItem); 
                                        }                               
                                }
                        } // for ends 
                        
                         system.debug('claims>>>>>' + claims);
                         system.debug('claimLineItems>>>>>' + claimLineItems);                                           
                }
          }
          catch(Exception ex)
          {
                Apexpages.addMessages(ex);
          }
          
          if(!claims.isEmpty())
          {         	
                                Integer rowNum=0;
                                Savepoint sp = Database.setSavepoint();
                         
                                Database.SaveResult[] sr1;
                                Database.SaveResult[] sr2;                       
                                
                                
                                // insert claims first
                                try {
                                    sr1 = Database.insert(claims, false);
                                }
                                catch (Exception ex) {}    
                                
                                jj_rb_Rebate_Claim__c errorClaim;
                                for(Database.SaveResult sr : sr1)
                                 {
                                         
                                         // if the claim record errors out, all the child claim line
                                         // items have to be marked with the error                                       
                                         if(!sr.isSuccess())
                                         {
                                                Database.rollback(sp);
                                                
                                                errorClaim = claims[rowNum];
                                                
                                                // create the error message string
                                                String errMsg = '';
                                                for(Database.Error err : sr.getErrors())
                                            {
                                                errMsg += err.getStatusCode() + ': ' + err.getMessage();                                                
                                            }
                                                                                
                                                // find all the child inv data record and put the error msg
                                                List<InvoiceData> listInvData = mapInvData.get(errorClaim.jj_rb_Dataload_external_Id__c);
                                                system.debug('listInvData>>>' + listInvData); 
                                                for(InvoiceData invData : listInvData)
                                                {
                                                        invData.errorMsg = errMsg;
                                                        InvoiceWrapper.errorRecords.add(invData);
                                                }
                                         }
                                         rowNum++;
                                 }
                                 
                                 // if claims error out, exit the method
                                 if(!InvoiceWrapper.errorRecords.isEmpty())
                                     return;
                                 
                                 // insert claim line items next
                                 try {                                    
                                    sr2 = Database.insert(claimLineItems, false);
                                }
                                catch (Exception ex) {}
                                 
                                 // process all claim line item error records
                                 rowNum = 0;
                                 for(Database.SaveResult sr : sr2)
                                 {
                                         
                                         // if the claim record errors out, all the child claim line
                                         // items have to be marked with the error                                       
                                         if(!sr.isSuccess())
                                         {
                                                Database.rollback(sp);
                                                
                                                // create the error message string
                                                String errMsg = '';
                                                for(Database.Error err : sr.getErrors())
                                            {
                                                errMsg += err.getStatusCode() + ': ' + err.getMessage();                                                
                                            }
                                            
                                            // find the associated wrapper record 
                                            jj_rb_Rebate_Claim_Line_Item__c errorClaimLineItem = claimLineItems[rowNum];
                                            System.debug('Rownum>>>' + rowNum);
                                            system.debug('errorClaimLineItem >>>>' + errorClaimLineItem);
                                            
                                            // get all the wrapper records for this line items parent claim
                                            List<InvoiceData> listErrorInvData = mapInvData.get(errorClaimLineItem.jj_rb_Rebate_Claim__r.jj_rb_Dataload_external_Id__c);
                                            system.debug('listErrorInvData >>>>' + listErrorInvData );
                                            
                                            for(InvoiceData invData : listErrorInvData)
                                            {
                                                if(invData.hospitalId == errorClaimLineItem.jj_rb_Hospital__r.CODS_External_Id__c
                                                                && invData.productEANCode == errorClaimLineItem.jj_rb_Rebate_Product__r.jj_rb_SAP_EAN_Code__c) {
                                                        invData.errorMsg = errMsg;
                                                        InvoiceWrapper.errorRecords.add(invData);
                                                }
                                            }
                                            
                                                
                                         }
                                         rowNum++;
                                 }                                         
          }              
}

// this method processes the error records
   private void processErrorRecords(List<InvoiceData> listErrorRows)
   {
           errorInUpload = true;           
           for(InvoiceData errorRow : listErrorRows)
           {
                        system.debug('Error row>>>>' + errorRow);
           }
           
           String body = '';
           body = 'SAP Customer No,Claim Month,Claim Year,Hospital Id,Hospital Name,Product EAN Code,Product Name,Quantity,Unit List Price,Unit Contract Price,Unit Rebate Price,Net Rebate,VAT Amount,VAT Code,Gross Rebate, Error Message\n';
           for(InvoiceData errorRow : listErrorRows)
           {
                  body += errorRow.sapCustomerNo + ',' + errorRow.month + ',' + errorRow.year + ',' + errorRow.hospitalId + ',' + errorRow.hospitalName + ',' + errorRow.productEANCode + ',' + errorRow.productName + ',' + errorRow.qty + ',' + errorRow.unitListPrice + ',' + errorRow.unitContractPrice + ',' + errorRow.unitRebate + ',' + errorRow.netRebate + ',' + errorRow.vatAmount + ','+ errorRow.vatCode + ',' + errorRow.grossRebate + ',' + errorRow.errorMsg + '\n';    
           }
           
           // send error email to current user
           Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
           
           // Create the email attachment
       Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
       efa.setFileName('errorLog.csv');
       efa.setBody(Blob.valueOf(body)); 
       
       List<String> toAddresses = new List<String> {UserInfo.getUserEmail()};
       
       // Sets the paramaters of the email
       email.setSubject('Homecare claim upload error report');
       email.setToAddresses( toAddresses );
       email.setPlainTextBody('Hello,\n\nPlease find attached the Homecare claim upload error report.\n\nRegards,\nRebate Management');

       email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

       // Sends the email
       Messaging.SendEmailResult [] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
   }
   
   private InvoiceWrapper getMappedRecords(List<List<String>> csvRecords)
   {
                Integer rowNum = 0;
                List<InvoiceData> listInvData = new List<InvoiceData> ();
                Map<String, List<InvoiceData>> mapInvoiceWrapper =  new Map<String, List<InvoiceData>>();
                InvoiceWrapper invoiceWrapper = new InvoiceWrapper();
                                
                try 
                {
                        // loop through the records in csv file and create a list of invoice data   
                        for(List<String> row : csvRecords)
                        {
                                InvoiceData wrapper = new InvoiceData();
                                Boolean errorInRecord = false;
                                Exception ex;
                                
                                // skip the header row
                                if(rowNum == 0) {
                                        invoiceWrapper.csvHeader = row;
                                        rownum++;
                                        continue;
                                }        
                                
                                System.debug('row>>>' + row);
                                try {
                                	wrapper.sapCustomerNo = (String)row[0];
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	wrapper.month = (String)row[1];
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	wrapper.year = (String)row[2];
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	wrapper.hospitalId = (String)row[3];
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	wrapper.hospitalName =  (String)row[4];
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	wrapper.productEANCode = (String)row[5];
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	wrapper.productName = (String)row[6];
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	wrapper.qty = Integer.valueOf(row[7]);
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                	
                                try {
	                                if(String.isNotBlank(row[8].trim()))
	                                    wrapper.unitListPrice = Decimal.valueOf(row[8].trim());
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {
	                                if(String.isNotBlank(row[9].trim()))                                
	                                    wrapper.unitContractPrice = Decimal.valueOf(row[9].trim());
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {                                
	                                if(String.isNotBlank(row[10].trim()))
	                                    wrapper.unitRebate = Decimal.valueOf(row[10].trim());
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {
	                                if(String.isNotBlank(row[11].trim()))                                
	                                    wrapper.netRebate = Decimal.valueOf(row[11].trim());
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {
	                                if(String.isNotBlank(row[12].trim()))                                
	                                    wrapper.vatAmount = Decimal.valueOf(row[12].trim());
	                            } catch (Exception e) {errorInRecord = true; ex=e;}        
                                
                                try {
                                	wrapper.vatCode = String.valueOf(row[13]);
                                } catch (Exception e) {errorInRecord = true; ex=e;}	
								
								try {
	                                if(String.isNotBlank(row[14].trim())) 
	                                	wrapper.grossRebate = Decimal.valueOf(row[14].trim());
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                if (!errorInRecord)
                                	listInvData.add(wrapper);
                                else
                                	{
                                		wrapper.errorMsg = ex.getMessage();
                                		invoiceWrapper.errorRecords.add(wrapper);  
                                	}	
                                
                                rowNum++;       
                        }
                        
                        // create a map of unique key - > customer No_Month_Year and claim line items
                        for(InvoiceData invData : listInvData)
                        {
                                if(String.isNotBlank(invData.sapCustomerNo) 
                                                && String.isNotBlank(invData.month) 
                                                && String.isNotBlank(invData.year))     {
                                         
                                        // unique key
                                        String uniqueKey =      invData.sapCustomerNo + '_' + invData.month + '_' + invData.year;
                                        
                                        if(mapInvoiceWrapper.containsKey(uniqueKey)){
                                                List<InvoiceData> lWrapper = mapInvoiceWrapper.get(uniqueKey);
                                                lWrapper.add(invData);
                                                mapInvoiceWrapper.put(uniqueKey, lWrapper);
                                        } else {
                                                mapInvoiceWrapper.put(uniqueKey, new List<InvoiceData>{invData});
                                        }        
                                } else {
                                        invData.errorMsg = 'SAP Customer No or Month or Year is missing';
                                        invoiceWrapper.errorRecords.add(invData);                                       
                                }
                        }       
                        invoiceWrapper.mapInvoiceData = mapInvoiceWrapper;
                        invoiceWrapper.allRecords = listInvData;
                        
                } 
                catch (Exception ex)
                {
                        Apexpages.addMessages(ex); 
                } 
                return invoiceWrapper;           
   }
   
   
  
   
}