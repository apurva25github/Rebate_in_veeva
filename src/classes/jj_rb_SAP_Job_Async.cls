/**
 *      @author Bart Geens
 *      @date   04/04/2004
        @description    Class for handling SAP loading jobs, based on ATL job mechanism

        Modification Log:
        ------------------------------------------------------------------------------------------------------
        Developer                   Date                Description
        ------------------------------------------------------------------------------------------------------
        Bart Geens                  24/04/2014          Original Version SAP Load
 */
public with sharing class jj_rb_SAP_Job_Async implements Database.Batchable<String>, Database.Stateful {

    private final Integer MAX_BATCH_SIZE = 200;
    private String sJobId;
    private String sJobName;
    private String sSAPFileName;
    private String sNotificationEmailAddress;
    private String sCsvContent;
    private Map<String, String> mSAPFiles;
    private Integer iErrorCount = 0;

    //Remember header row
    private Integer iBatchCount = 0;
    private List<String> lHeaderRow;

    public jj_rb_SAP_Job_Async(String JobId, String JobName, String NotificationEmailAddress, Map<String, String> SAPFiles)
    {
        sJobId = JobId;
        sJobName = JobName;
        sNotificationEmailAddress = NotificationEmailAddress;
        mSAPFiles = SAPFiles;
    }

    //Generate list in start method, list will be the input for the execute method
    public Iterable<String> start(Database.batchableContext batchableContext)
    {
        if(mSAPFiles.size() > 0)
        {
            //Get first key loaded into private variables (only way to pass variable to execute method apart from extending the custom iterator)
            for(String sKey : mSAPFiles.keySet())
            {
                sSAPFileName = sKey;
                sCsvContent = mSAPFiles.get(sKey);
                break; //Only need first iteration, for-loop is the easiest to access map contents
            }
            
            //Remove entry from map
            mSAPFiles.remove(sSAPFileName);

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
            List<List<jj_rb_SAP_Sales_Data__c>> SAPUpsertList = new List<List<jj_rb_SAP_Sales_Data__c>>();
            List<jj_rb_SAP_Sales_Data__c> lBatch;   
    
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
                    if(!(sFieldName == 'SAP Material No' || sFieldName == 'SAP Customer Id' || sFieldName == 'Net Trade Sales' || sFieldName == 'Invoice Qty' || sFieldName == 'Invoice Type' || sFieldName == 'Month' || sFieldName == 'Year'))
                    {
                        //ABORT, FIELD NOT SUPPORTED
                        throw new InvaliderHeaderException(sFieldName + ' is not a valid field name for loading SAP records');
                    }
                }
                
                //Right away increment batch count
                iBatchCount++;
                
                //Start at next row
                for (Integer i = iFirstDataRow; i < lLines.size(); i++) {
                    
                    //Init next batch if applicable
                    if(math.mod(i-1, MAX_BATCH_SIZE) == 0 || i == iFirstDataRow)
                    {
                        lBatch = new List<jj_rb_SAP_Sales_Data__c>();
                        System.debug('New batch created');
                    }
    
                    //Create SAP object and populate it
                    jj_rb_SAP_Sales_Data__c oSAP = new jj_rb_SAP_Sales_Data__c();
                    
                    for (Integer j = 0; j < lLines.get(i).size(); j++) {

                        String myField = '';
                        String myData = '';
                        System.debug (myField+': '+lLines.get(i).get(j));
                        if (lHeaderRow.get(j) == 'Invoice Type') {
                            myField = '';
                        } else if (lHeaderRow.get(j) == 'SAP Customer Id') {
                            myField = 'jj_rb_SAP_Customer_ID__c';
                            oSAP.put(myField, lLines.get(i).get(j));                            
                        } else if (lHeaderRow.get(j) == 'SAP Material No') {
                            myField = 'jj_rb_SAP_Material_No__c';
                            oSAP.put(myField, lLines.get(i).get(j));                            
                        } else if (lHeaderRow.get(j) == 'Net Trade Sales') {
                            myField = 'jj_rb_Net_Trade_Sales__c';
                            oSAP.put(myField,Integer.valueof(lLines.get(i).get(j)));                                 
                        } else if (lHeaderRow.get(j) == 'Invoice Qty') {
                            myField = 'jj_rb_Invoice_Qty__c';
                            oSAP.put(myField,Integer.valueof(lLines.get(i).get(j)));                                 
                        } else if (lHeaderRow.get(j) == 'Month') {
                            myField = 'jj_rb_month__c';
                            oSAP.put(myField,Integer.valueof(lLines.get(i).get(j)));                                 
                        } else if (lHeaderRow.get(j) == 'Year') {
                            myField = 'jj_rb_Year__c';
                            oSAP.put(myField,Integer.valueof(lLines.get(i).get(j)));                                  
                        } else if (lHeaderRow.get(j) == 'Year') {
                            myField = 'jj_rb_SAP_Data_Year__c';
                            //oSAP.put(myField, Integer.valueof(lLines.get(i).get(j)));                            
                            oSAP.put(myField,'2014');                            
                        } 
                        
                        if (myField != '') {
                            System.debug (myField+': '+lLines.get(i).get(j));
                        }   
                    }
                    
                    //Add to current batch
                    lBatch.add(oSAP);
    
                    //Add batch if completed or at end of lines list (check next record, so from a list index perspective that becomes i -1 +1 = i)
                    if((math.mod(i, MAX_BATCH_SIZE) == 0 && i != iFirstDataRow) || (i+1) == lLines.size() )
                    {
                        SAPUpsertList.add(lBatch);
                        System.debug('\nBatch ' + SAPUpsertList.size() + ' added\n');
                    }
                }
            }
            
            //Init error list
            Map<String, String> oErrorMap = new Map<String, String>();
            
            //Upsert objects
            for(List<jj_rb_SAP_Sales_Data__c> lBatchForUpsert : SAPUpsertList)
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
                        jj_rb_SAP_Sales_Data__c oSAPRec = lBatchForUpsert.get(i);
                        oErrorMap.put(oSAPRec.Id, arrErrors[0].getMessage());
                    }
                }
            }
            
            //Write possible errors back to job record
            if(oErrorMap.size() > 0)
            {
                iErrorCount += oErrorMap.size();
                
                Datetime myDateTime = Datetime.now();
                String sCsvName= sSAPFileName + '-' + String.valueof(iBatchCount) + '-' + myDateTime.format('yyyymmddHHmmss') + '.bad';
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
        jj_rb_Rebate_SAP_Job__c oSAPJob = [select Id, jj_rb_Remaining_Files__c, jj_rb_System_Message__c from jj_rb_Rebate_SAP_Job__c where id = :sJobId];
        
        System.debug('Job status: ' + oAsyncApexJob.Status);

        //If not completed succesfully set error message
        if(oAsyncApexJob.ExtendedStatus != null && oAsyncApexJob.ExtendedStatus != 'null')
        {
            if(oSAPJob.jj_rb_System_Message__c != null && oSAPJob.jj_rb_System_Message__c.length() > 0) {
                oSAPJob.jj_rb_System_Message__c = oSAPJob.jj_rb_System_Message__c + '\n' + sSAPFileName + ': ' + oAsyncApexJob.ExtendedStatus;
            }
            else
            {
                oSAPJob.jj_rb_System_Message__c = sSAPFileName + ': ' + oAsyncApexJob.ExtendedStatus;
            }
            
            sEmailBody += 'SAP job "' + sJobName + '" (file "' + sSAPFileName + '") failed\r\n';
            sEmailBody += sSAPFileName + ': ' + oAsyncApexJob.ExtendedStatus;
        }
        
        //If data errors set standard error message and complete mail content
        if(iErrorCount > 0)
        {
            if(oSAPJob.jj_rb_System_Message__c != null && oSAPJob.jj_rb_System_Message__c.length() > 0) {
                oSAPJob.jj_rb_System_Message__c = oSAPJob.jj_rb_System_Message__c + '\n' + sSAPFileName + ': ' + String.valueof(iErrorCount) + ' data errors, please check bad file(s) attached';
            }
            else
            {
                oSAPJob.jj_rb_System_Message__c = sSAPFileName + ': ' + String.valueof(iErrorCount) + ' data errors, please check bad file(s) attached';
            }
            
            sEmailBody += 'SAP job "' + sJobName + '" (file "' + sSAPFileName + '") not processed successfully\r\n';
            sEmailBody += '\t' + String.valueof(iErrorCount) + ' data errors, please check bad file(s) attached';
        }
        else
        {
            sEmailBody = 'SAP job "' + sJobName + '" (file "' + sSAPFileName + '") processed successfully';
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
        mail.setSubject('SAP job "' + sJobName + '" finished with status ' + oAsyncApexJob.Status);
        mail.setPlainTextBody('The SAP job "' + sJobName + '" for file "' + sSAPFileName + '" processed ' + oAsyncApexJob.TotalJobItems + ' batches with '+ oAsyncApexJob.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });       

        //Decrement file counter (for showing user what's pending)
        oSAPJob.jj_rb_Remaining_Files__c--;
        
        System.debug('Remaining files: ' + mSAPFiles.size());

        //Check if additional files to be loaded, if 0 then mark job completed      
        if(mSAPFiles.size() == 0) {
            if(oSAPJob.jj_rb_System_Message__c == null) {
                System.debug('Set processed');
                oSAPJob.jj_rb_Status__c = 'Processed';
            }
            else {
                System.debug('Set failed');
                oSAPJob.jj_rb_Status__c = 'Failed';
            }
        }
        
        //Update job before launching next
        update oSAPJob;
        
        //If remaining records ==> invoke next
        if(mSAPFiles.size() > 0) {
            //Start next batch
            System.debug('Start new batch');
            jj_rb_SAP_Job_Async oNextSAPJob = new jj_rb_SAP_Job_Async(sJobId, sJobName, sNotificationEmailAddress, mSAPFiles);
            Database.executeBatch(oNextSAPJob);
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