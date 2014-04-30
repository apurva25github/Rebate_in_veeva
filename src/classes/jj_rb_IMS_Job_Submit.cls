/**
 *      @author Bart Geens
 *      @date   22/04/2014
        @description    Class for handling validation steps before submitting an IMS loading job

        Modification Log:
        ------------------------------------------------------------------------------------------------------
        Developer					Date				Description
        ------------------------------------------------------------------------------------------------------
        Bart Geens				22/04/2014			Original Version 
 */
 
global with sharing class jj_rb_IMS_Job_Submit {
    WebService static String ProcessJob(Id JobId)
    {
    	
    	Datetime myDateTime = Datetime.now();
		List<jj_rb_Rebate_IMS_Job__c> oJobs = [select Id, Name, jj_rb_Status__c, jj_rb_Notification_Email__c from jj_rb_Rebate_IMS_Job__c where  jj_rb_Status__c = 'Ready' and Id=:JobId];
		//jj_rb_IMS_Load__c oJob = [select Id, Name, jj_rb_Status__c, jj_rb_Notification_Email__c from jj_rb_IMS_Load__c where Id=:JobId];
		//Get csv attachments linked to this ATL job
		if(oJobs.isEmpty()){
    		throw new jj_rb_ApplicationException('Error: Job is not "Ready"');
		}
		jj_rb_Rebate_IMS_Job__c oJob = oJobs[0];
		
		List<Attachment> lAttachments = [select Id, Name, Body from Attachment Where ParentId = :JobId And Name like '%csv'];
		 
		//If no error message is returned job is concidered to be valid
		String sValidationResult = ValidateJob(oJob);
		
		if(sValidationResult == '')
		{
			//Set job in progress
			oJob.jj_rb_Status__c = 'In Progress';
			oJob.jj_rb_Remaining_Files__c = lAttachments.size();
			update oJob;
			 
			//Create map with files
			Map<String, String> mIMSFiles = new Map<String, String>();
			 
			for(Attachment oAttachment : lAttachments) {
			       mIMSFiles.put(oAttachment.Name, oAttachment.body.toString());
			}
			 
			jj_rb_IMS_Job_Async oATLJob = new jj_rb_IMS_Job_Async(oJob.Id, oJob.Name, oJob.jj_rb_Notification_Email__c, mIMSFiles);
			ID batchprocessid = Database.executeBatch(oATLJob);
			
		} 

		return sValidationResult;
    }
    
    private static String ValidateJob(jj_rb_Rebate_IMS_Job__c theJob)
    {
		//Get all attachments linked to this IMS job
		List<Attachment> lAttachments = [select Id, Name, Body from Attachment Where ParentId = :theJob.Id And Name like '%csv'];
		
		if(lAttachments.size() > 0) {		
    		return '';
		} else {
			return 'At least one csv file has to be linked to the job to be able to proceed';
		}
    }
    
    public class jj_rb_ApplicationException extends Exception {}
    
}