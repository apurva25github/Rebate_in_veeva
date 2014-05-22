/**
 *      @author Bart Geens
 *      @date   04/04/2004
        @description    Class for handling IMS loading jobs, based on ATL job mechanism

        Modification Log:
        ------------------------------------------------------------------------------------------------------
        Developer                   Date                Description
        ------------------------------------------------------------------------------------------------------
        Bart Geens                  04/04/2014          Original Version IMS Load
 */
 public with sharing class jj_rb_IMS_Job_Async implements Database.Batchable<String>, Database.Stateful {


    private final Integer MAX_BATCH_SIZE = 200;
    private String sJobId;
    private String sJobName;
    private String sIMSFileName;
    private String sNotificationEmailAddress;
    private String sCsvContent;
    private Map<String, String> mIMSFiles;
    private Integer iErrorCount = 0;

    //Remember header row
    private Integer iBatchCount = 0;
    private List<String> lHeaderRow;

    public jj_rb_IMS_Job_Async(String JobId, String JobName, String NotificationEmailAddress, Map<String, String> IMSFiles)
    {
        sJobId = JobId;
        sJobName = JobName;
        sNotificationEmailAddress = NotificationEmailAddress;
        mIMSFiles = IMSFiles;
    }

    //Generate list in start method, list will be the input for the execute method
    public Iterable<String> start(Database.batchableContext batchableContext)
    {
        if(mIMSFiles.size() > 0)
        {
            //Get first key loaded into private variables (only way to pass variable to execute method apart from extending the custom iterator)
            for(String sKey : mIMSFiles.keySet())
            {
                sIMSFileName = sKey;
                sCsvContent = mIMSFiles.get(sKey);
                break; //Only need first iteration, for-loop is the easiest to access map contents
            }
            
            //Remove entry from map
            mIMSFiles.remove(sIMSFileName);

            return new jj_CSVIterator(sCsvContent, '\n');
        }
        else {
            return null;
        }
        
    }

    public void execute(Database.BatchableContext BC, List<String> lRowsAsString) {
        if(lRowsAsString != null) {
            //Parse CSV lines into nested lists
            List<List<String>> lLines = parseCSV(lRowsAsString);
            
            System.debug('Number of lines to process: ' + lLines.size());
    
            //List of batches and batch itself
            List<List<jj_rb_IMS_Sales_Data__c>> IMSUpsertList = new List<List<jj_rb_IMS_Sales_Data__c>>();
            List<jj_rb_IMS_Sales_Data__c> lBatch;   
            //Init error list
            Map<String, String> oErrorMap = new Map<String, String>();
            
    
            if(lLines.size() > 0)
            {
                //Set first data row index
                Integer iFirstDataRow = 0;
                
                //Assume first row to be header row (only in first batch)
                if(iBatchCount == 0)
                {
                    lHeaderRow = lLines.get(0);
                    iFirstDataRow = 1;
                }
                else
                {
                    iFirstDataRow = 0;
                }

                System.debug('Number of lines: ' + lLines.size());
                System.debug('Max batch size: ' + MAX_BATCH_SIZE);              
                System.debug('Header size: ' + lHeaderRow.size());
                System.debug('Current batch: ' + iBatchCount);
                System.debug('Start loading at row: ' + iFirstDataRow);
                
                //Validate field names
                for(String sFieldName : lHeaderRow)
                {
                	if(!(sFieldName == 'Outlet Type' || sFieldName == 'Customer Name' || sFieldName == 'IMS Customer Id' || sFieldName == 'Product Name' || sFieldName == 'Product Info' || sFieldName == 'IMS Product Id' || sFieldName == 'Month' || sFieldName == 'Year' || sFieldName == 'Qty'))
                    //if(!(sFieldName == 'Type' || sFieldName == 'IMS Customer Id' || sFieldName == 'Customer Name' || sFieldName == 'IMS Product Id' || sFieldName == 'Product Name' || sFieldName == 'Product Description' || sFieldName == 'Month' || sFieldName == 'Year' || sFieldName == 'Quantity'))
                    {
                        //ABORT, FIELD NOT SUPPORTED
                        throw new InvaliderHeaderException(sFieldName + ' is not a valid field name for loading IMS records');
                    }
                }
                
                //Right away increment batch count
                iBatchCount++;
                
                //Start at next row
                for (Integer i = iFirstDataRow; i < lLines.size(); i++) {
                    
                    //Init next batch if applicable
                    if(math.mod(i-1, MAX_BATCH_SIZE) == 0 || i == iFirstDataRow)
                    {
                        lBatch = new List<jj_rb_IMS_Sales_Data__c>();
                        System.debug('New batch created');
                    }
    
                    //Create IMS object and populate it
                    jj_rb_IMS_Sales_Data__c oIMS = new jj_rb_IMS_Sales_Data__c();
                    Boolean hasError = false; 
                    String badQuantity = '';
                    for (Integer j = 0; j < lLines.get(i).size(); j++) {

                        String myField = '';
                        String myData = '';
                        System.debug (myField+': '+lLines.get(i).get(j));
                        
                        if (lHeaderRow.get(j) == 'Outlet Type') {
                            myField = '';
                        } else if (lHeaderRow.get(j) == 'IMS Customer Id') {
                            myField = 'jj_rb_IMS_Customer_Number__c';
                            oIMS.put(myField, lLines.get(i).get(j));                            
                        } else if (lHeaderRow.get(j) == 'Customer Name') {
                            myField = 'jj_rb_IMS_Customer__c';
                            oIMS.put(myField, lLines.get(i).get(j));                            
                        } else if (lHeaderRow.get(j) == 'IMS Product Id') {
                            myField = 'jj_rb_IMS_Product_Number__c';
                            oIMS.put(myField, lLines.get(i).get(j));                            
                        } else if (lHeaderRow.get(j) == 'Product Name') {
                            myField = 'jj_rb_Product_Name__c';
                            oIMS.put(myField, lLines.get(i).get(j));      
                        } else if (lHeaderRow.get(j) == 'Product Info') {
                            myField = '';
                        } else if (lHeaderRow.get(j) == 'Month') {
                            myField = 'jj_rb_IMS_Data_Month__c';
                            oIMS.put(myField, String.valueof(lLines.get(i).get(j)));
                        } else if (lHeaderRow.get(j) == 'Year') {
                            myField = 'jj_rb_IMS_Data_Year__c';
                            oIMS.put(myField, String.valueof(lLines.get(i).get(j)));
                        } else if (lHeaderRow.get(j) == 'Qty') {
                            myField = 'jj_rb_IMS_Volume__c';
                            Integer x = 0;
                            try {
							  x = Integer.valueof(lLines.get(i).get(j));
							}
							Catch (exception e) {
	                            hasError = true;
	                            badQuantity = lLines.get(i).get(j);
							}
                            oIMS.put(myField, x);                            
                        }
                        
                        if (myField != '') {
                            System.debug (myField+': '+lLines.get(i).get(j));
                        }   
                    }
                    
                    if (!hasError) {
	                    // generate external id & add to current batch
	                    String extid = oIMS.jj_rb_IMS_Customer_Number__c+'-'+oIMS.jj_rb_IMS_Product_Number__c+'-'+oIMS.jj_rb_IMS_Data_Month__c+'-'+oIMS.jj_rb_IMS_Data_Year__c;
	                    oIMS.jj_rb_Dataload_External_id__c = extid;
	                    
	                    lBatch.add(oIMS);
                    } else {
                    	// Add to error list
                    	oErrorMap.put('error on line '+i, 'Invalid quantity: '+badQuantity);
                    }
    
                    //Add batch if completed or at end of lines list (check next record, so from a list index perspective that becomes i -1 +1 = i)
                    if((math.mod(i, MAX_BATCH_SIZE) == 0 && i != iFirstDataRow) || (i+1) == lLines.size() )
                    {
                        IMSUpsertList.add(lBatch);
                        System.debug('\nBatch ' + IMSUpsertList.size() + ' added\n');
                    }
                }
            }
            
            //Upsert objects
            for(List<jj_rb_IMS_Sales_Data__c> lBatchForUpsert : IMSUpsertList)
            {
                Database.Upsertresult[] arrResults = Database.upsert(lBatchForUpsert, false);
                
                for(Integer i = 0; i < arrResults.size(); i++)
                {
                    Database.Upsertresult oUpsertresult = arrResults[i];
                    if(!(oUpsertresult.success))
                    {
                        Database.Error[] arrErrors = oUpsertresult.errors;
                        System.debug('Errors found');
                        
                        //Get record for which things went wrong (assuming errors are in same order as inputs)
                        jj_rb_IMS_Sales_Data__c oIMSRec = lBatchForUpsert.get(i);
                        oErrorMap.put(oIMSRec.jj_rb_Dataload_External_id__c, arrErrors[0].getMessage());
                    }
                }
            }
            
            //Write possible errors back to job record
            if(oErrorMap.size() > 0)
            {
                iErrorCount += oErrorMap.size();
                
                Datetime myDateTime = Datetime.now();
                String sCsvName= sIMSFileName + '-' + String.valueof(iBatchCount) + '-' + myDateTime.format('yyyymmddHHmmss') + '-errors.txt';
                String sHeader = '"Id","Error Message"\n';
                String sFinal = sHeader;
                
                for (String sId : oErrorMap.keySet()) {
                    String sRecord = '"' + sId + '","' + oErrorMap.get(sId) + '"\n';
                    sFinal = sFinal + sRecord;
                }
                
                blob oCsvBlob = Blob.valueOf(sFinal);
                
                Attachment oAttachment = new Attachment();
                oAttachment.Body = oCsvBlob;
                oAttachment.ContentType = 'txt';
                oAttachment.Name = sCsvName;
                oAttachment.ParentId = sJobId;
                insert oAttachment;
            }
        }
    }
 

    public void finish(Database.BatchableContext BC) {
        
        String sEmailBody = '';

        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob oAsyncApexJob = [
            SELECT Id, Status, ExtendedStatus, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob 
            WHERE Id = :BC.getJobId()];
        
        //Init object for update
        jj_rb_Rebate_IMS_Job__c oIMSJob = [select Id, jj_rb_Remaining_Files__c, jj_rb_System_Message__c from jj_rb_Rebate_IMS_Job__c where id = :sJobId];
        
        System.debug('Job status: ' + oAsyncApexJob.Status);

        //If not completed succesfully set error message
        if(oAsyncApexJob.ExtendedStatus != null && oAsyncApexJob.ExtendedStatus != 'null')
        {
            if(oIMSJob.jj_rb_System_Message__c != null && oIMSJob.jj_rb_System_Message__c.length() > 0) {
                oIMSJob.jj_rb_System_Message__c = oIMSJob.jj_rb_System_Message__c + '\n' + sIMSFileName + ': ' + oAsyncApexJob.ExtendedStatus;
            }
            else
            {
                oIMSJob.jj_rb_System_Message__c = sIMSFileName + ': ' + oAsyncApexJob.ExtendedStatus;
            }
            
            sEmailBody += 'IMS job "' + sJobName + '" (file "' + sIMSFileName + '") failed\r\n';
            sEmailBody += sIMSFileName + ': ' + oAsyncApexJob.ExtendedStatus;
        }
        
        //If data errors set standard error message and complete mail content
        if(iErrorCount > 0)
        {
            if(oIMSJob.jj_rb_System_Message__c != null && oIMSJob.jj_rb_System_Message__c.length() > 0) {
                oIMSJob.jj_rb_System_Message__c = oIMSJob.jj_rb_System_Message__c + '\n' + sIMSFileName + ': ' + String.valueof(iErrorCount) + ' data errors, please check bad file(s) attached';
            }
            else
            {
                oIMSJob.jj_rb_System_Message__c = sIMSFileName + ': ' + String.valueof(iErrorCount) + ' data errors, please check error text file(s) attached';
            }
            
            sEmailBody += 'IMS job "' + sJobName + '" (file "' + sIMSFileName + '") not processed successfully\r\n';
            sEmailBody += '\t' + String.valueof(iErrorCount) + ' data errors, please check error text file(s) attached';
        }
        else
        {
            sEmailBody = 'IMS job "' + sJobName + '" (file "' + sIMSFileName + '") processed successfully';
        }
        // Set email subject correctly, taking Database & data format errors into account
        String sEmailSubjectStatus = '';
		if ((iErrorCount > 0) || (oAsyncApexJob.NumberOfErrors > 0 )) {
	            sEmailSubjectStatus = 'Failed';
	    } else {
	            sEmailSubjectStatus = 'Completed';
	    }
        
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses;
        if(sNotificationEmailAddress==null) {
            toAddresses = new String[] {oAsyncApexJob.CreatedBy.Email};
        }
        else {
            toAddresses = new String[] {oAsyncApexJob.CreatedBy.Email, sNotificationEmailAddress};
        }
        mail.setToAddresses(toAddresses);
        mail.setSubject('IMS job "' + sJobName + '" finished with status ' + sEmailSubjectStatus);
        mail.setPlainTextBody('The IMS job "' + sJobName + '" for file "' + sIMSFileName + '" processed ' + oAsyncApexJob.TotalJobItems + ' batches with '+ (oAsyncApexJob.NumberOfErrors + iErrorCount) + ' failures');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       

        //Decrement file counter (for showing user what's pending)
        oIMSJob.jj_rb_Remaining_Files__c--;
        
        System.debug('Remaining files: ' + mIMSFiles.size());

        //Check if additional files to be loaded, if 0 then mark job completed      
        if(mIMSFiles.size() == 0) {
            if(oIMSJob.jj_rb_System_Message__c == null) {
                System.debug('Set processed');
                oIMSJob.jj_rb_Status__c = 'Processed';
            }
            else {
                System.debug('Set failed');
                oIMSJob.jj_rb_Status__c = 'Failed';
            }
        }
        
        //Update job before launching next
        update oIMSJob;
        
        //If remaining records ==> invoke next
        if(mIMSFiles.size() > 0) {
            //Start next batch
            System.debug('Start new batch');
            jj_rb_IMS_Job_Async oNextIMSJob = new jj_rb_IMS_Job_Async(sJobId, sJobName, sNotificationEmailAddress, mIMSFiles);
            Database.executeBatch(oNextIMSJob);
        }
    }



    private List<List<String>> parseCSV(List<String> lines) {
        
        System.debug('Number of lines to process: ' + lines.size());
        
        String BOM = EncodingUtil.base64decode('77u/').toString();
        
         //Init lists
        List<List<String>> allFields = new List<List<String>>();
        
        for(String line : lines)
        {
            //Check for BOM
            if(line.startsWith(BOM))
            {
                System.debug('BOM found and removed');
                line = line.replace(BOM, '');
            }
            
            // replace instances where a double quote begins a field containing a comma
            // in this case you get a double quote followed by a doubled double quote
            // do this for beginning and end of a field
            line = line.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
            
            // now replace all remaining double quotes - we do this so that we can reconstruct
            // fields with commas inside assuming they begin and end with a double quote
            line = line.replaceAll('""','DBLQT');
            
            // check for blank CSV lines (only commas)
            if (line.replaceAll(',','').trim().length() == 0) break;
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field : fields) {
                
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"').removeStart('"').removeEnd('"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    System.debug('End of composite field detected');
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"').removeStart('"').removeEnd('"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"').removeStart('"').removeEnd('"'));
                }
            }

            allFields.add(cleanFields);
        }

        return allFields;       
    }
    
    public class InvaliderHeaderException extends Exception {}
}