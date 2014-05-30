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
     
  
     
   public void upload() 
   {  	 
   	
     system.debug('Document.body>>>' + document.body); 
     system.debug('Document Name>>>>' + document.Name);
     system.debug('Document type>>>>' + document.Type);
     
     
     if(invalidFile(document)) {
     	document.body = null;     	
     	return;
     }
     
     errorInUpload = false;
     showUploadMsg = true;
     	
     
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
        processErrorRows(invoiceWrapper);
     }  
     
     document.body = null;     
   } 
   
   
   private void uploadRecords(InvoiceWrapper invoiceWrapper)
   {          
          List<jj_rb_Rebate_Claim_Line_Item__c> claimLineItems = new List<jj_rb_Rebate_Claim_Line_Item__c>();         
          List<jj_rb_Rebate_Claim__c> claims = new List<jj_rb_Rebate_Claim__c>(); 
             
                  
          String homecareClaimRecordType = jj_rb_Rebate_Utils.getRecordTypeId('Claim_Homecare');
          String homecareCLIRecordType = jj_rb_Rebate_Utils.getRecordTypeId('Claim_LineItem_Homecare');
          
          Boolean hasRolledBack = false;
          
         
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
                                                  claimLineItem.jj_rb_Hospital__r.CODS_External_Id__c = invData.hospitalId;
                                                  claimLineItem.jj_rb_Rebate_Product__r = new jj_rb_Rebate_Product__c();
                                                  
                                                  if(String.isNotBlank(invData.productSAPMaterialNo))
                                                  	claimLineItem.jj_rb_Rebate_Product__r.jj_rb_SAP_Material_Number__c = invData.productSAPMaterialNo;
                                                  else	
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
                                                if(!hasRolledBack) {
                                                	Database.rollback(sp);
                                                	hasRolledBack = true;
                                                }	
                                                
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
                                 hasRolledBack = false;
                                 for(Database.SaveResult sr : sr2)
                                 {
                                         
                                         // if the claim record errors out, all the child claim line
                                         // items have to be marked with the error                                       
                                         if(!sr.isSuccess())
                                         {
                                                if(!hasRolledBack) {
                                                	Database.rollback(sp);
                                                	hasRolledBack = true;	
                                                }	
                                                
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
                                                       && (invData.productEANCode == errorClaimLineItem.jj_rb_Rebate_Product__r.jj_rb_SAP_EAN_Code__c
                                                           || invData.productSAPMaterialNo == errorClaimLineItem.jj_rb_Rebate_Product__r.jj_rb_SAP_Material_Number__c)) {
                                                        invData.errorMsg = errMsg;
                                                        InvoiceWrapper.errorRecords.add(invData); 
                                                }
                                            }
                                            
                                                
                                         }
                                         rowNum++;
                                 }                                         
          }              
}

	// process error rows
	private void processErrorRows(InvoiceWrapper invoiceWrapper)
	{
		errorInUpload = true;
		
		// get the error file
		String errorFile = 	prepareErrorFile(invoiceWrapper.csvHeader, invoiceWrapper.errorRecords);
		
		sendEmail(errorFile);		
	}
	
	private void sendEmail(String errorFile)
	{
		// send error email to current user
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
           
        // Create the email attachment
       	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
       	efa.setFileName('errorLog.csv');
       	efa.setBody(Blob.valueOf(errorFile)); 
       
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
	
	private String prepareErrorFile(List<String> csvHeader, List<InvoiceData> errorRows)
	{
		//prepare header of the error file
		String header = '';
		for(String col : csvHeader)
		{
			header += col + ',';
		}
		
		// add header for error column
		header = header.replaceAll('\n','').replaceAll('\r','');
		header += 'Error Message\n';
		
		// prepare body of the error file
		String body = '';
		for(InvoiceData invData : errorRows)
		{
			for(String col : invData.csvRow)
			{
				body += col + ',';
			}
			
			// add error message
			body = body.replaceAll('\r','');
			body += invData.errorMsg + '\n';
		}
		
		system.debug('Err File Header>>>>' + header);
		system.debug('Err File BodyBody>>>>' + body);
		
		return header + body;
	}
	   
   private InvoiceWrapper getMappedRecords(List<List<String>> csvRecords)
   {
                Integer rowNum = 0;
                List<InvoiceData> listInvData = new List<InvoiceData> ();
                Map<String, List<InvoiceData>> mapInvoiceWrapper =  new Map<String, List<InvoiceData>>();
                Map<String, Integer> mapHeader;
                InvoiceWrapper invoiceWrapper = new InvoiceWrapper();
                                
                try 
                {
                        // loop through the records in csv file and create a list of invoice data   
                        for(List<String> row : csvRecords)
                        {
                                InvoiceData invoiceData = new InvoiceData();
                                Boolean errorInRecord = false;
                                Exception ex;
                                
                                // skip the header row
                                if(rowNum == 0) {
                                        invoiceWrapper.csvHeader = row;
                                        mapHeader = prepareHeaderMap(row);
                                        system.debug('Header Map>>>>' + mapHeader);
                                        rownum++;
                                        continue;
                                }        
                                
                                System.debug('row>>>' + row);
                                
                                // set the csv row 
                                invoiceData.csvRow = row;
                                
                                try {
                                	//invoiceData.sapCustomerNo = (String)row[0];
                                	invoiceData.sapCustomerNo = (String) getValue(row, mapHeader.get('SAP Customer No'));
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.month = (String)row[1];
                                	invoiceData.month = (String)  getValue(row, mapHeader.get('Claim Month'));
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.year = (String)row[2];
                                	invoiceData.year = (String)  getValue(row, mapHeader.get('Claim Year')); 
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.hospitalId = (String) row[3];
                                	invoiceData.hospitalId = (String) getValue(row, mapHeader.get('Hospital Id'));
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.hospitalName =  (String)row[4];
                                	invoiceData.hospitalName =  (String)  getValue(row, mapHeader.get('Hospital Name'));
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.productEANCode = (String)row[5];
                                	invoiceData.productEANCode = (String)  getValue(row, mapHeader.get('Product EAN Code'));
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.productEANCode = (String)row[5];
                                	invoiceData.productSAPMaterialNo = (String)  getValue(row, mapHeader.get('SAP Material Number'));
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.productName = (String)row[6];
                                	invoiceData.productName = (String) getValue(row, mapHeader.get('Product Name'));
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                try {	
                                	//invoiceData.qty = Decimal.valueOf(row[7]);
                                	invoiceData.qty = Decimal.valueOf(getValue(row, mapHeader.get('Quantity'))); 
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                	
                                try {
	                                String unitListPrice = getValue(row, mapHeader.get('Unit List Price (pack)'));
	                                if(String.isNotBlank(unitListPrice))
	                                    invoiceData.unitListPrice = Decimal.valueOf(unitListPrice);
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {
	                                String unitContractPrice = getValue(row, mapHeader.get('Unit Contract Price (pack)'));
	                                if(String.isNotBlank(unitContractPrice))                                
	                                    invoiceData.unitContractPrice = Decimal.valueOf(unitContractPrice);
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {                                
	                                String unitRebate = getValue(row, mapHeader.get('Unit Rebate (pack)'));
	                                if(String.isNotBlank(unitRebate))
	                                    invoiceData.unitRebate = Decimal.valueOf(unitRebate);
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {
	                                String netRebate = getValue(row, mapHeader.get('Net Rebate'));
	                                if(String.isNotBlank(netRebate))                                
	                                    invoiceData.netRebate = Decimal.valueOf(netRebate);
                                } catch (Exception e) {errorInRecord = true; ex=e;}    
                                
                                try {
	                                String vatAmount = getValue(row, mapHeader.get('VAT Amount'));
	                                if(String.isNotBlank(vatAmount))                                
	                                    invoiceData.vatAmount = Decimal.valueOf(vatAmount);
	                            } catch (Exception e) {errorInRecord = true; ex=e;}        
                                
                                try {
                                	//invoiceData.vatCode = String.valueOf(row[13]);
                                	invoiceData.vatCode = String.valueOf(getValue(row, mapHeader.get('VAT Code')));
                                } catch (Exception e) {errorInRecord = true; ex=e;}	
								
								try {
	                                String grossRebate = getValue(row, mapHeader.get('Gross Rebate'));
	                                if(String.isNotBlank(grossRebate)) 
	                                	invoiceData.grossRebate = Decimal.valueOf(grossRebate);
                                } catch (Exception e) {errorInRecord = true; ex=e;}
                                
                                if (!errorInRecord)
                                	listInvData.add(invoiceData);
                                else
                                	{
                                		invoiceData.errorMsg = ex.getMessage();
                                		invoiceWrapper.errorRecords.add(invoiceData);  
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
   
   private Map<String, Integer> prepareHeaderMap(List<String> csvHeader)
   {
   	  Map<String, Integer> mapHeader = new Map<String, Integer>();
   	  Integer iCount = 0;
   	  for(String colHeader : csvHeader)
   	  {
   	  	 if(String.isNotBlank(colHeader))
   	  	 {
   	  	 	mapHeader.put(colHeader.trim(),iCount);
   	  	 }
   	  	 iCount++;
   	  }  	  
   	  return mapHeader;
   }  
   
   private String getValue(List<String> row, Integer index)
   {       
       if(index != null) {
        try {
        	return row[index].trim();
        } catch (Exception ex){
        	return null;
        }        
       } 
       else 
        return null;
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
}