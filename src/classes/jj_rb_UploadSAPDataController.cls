public with sharing class jj_rb_UploadSAPDataController {
    public jj_rb_UploadSAPDataController(ApexPages.StandardController controller) {

    }
    Public Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
   
    Public Pagereference Savedoc()
    {
		
		String emailAddress = UserInfo.getUserEmail();
		jj_rb_Rebate_SAP_Job__c job = new jj_rb_Rebate_SAP_Job__c();
		job.jj_rb_Notification_Email__c = emailAddress;
  		job.jj_rb_Status__c = 'Ready';
  		insert job;
  		
        Attachment a = new Attachment(parentId = job.Id, name=myfile.name, body = myfile.body);
         
        /* insert the attachment */
        insert a;
        
        jj_rb_SAP_Job_Submit.ProcessJob(job.Id);
        
        
        String ObjectPrefix = jj_rb_Rebate_SAP_Job__c.sObjectType.getDescribe().getKeyPrefix();
              
        PageReference p = new PageReference('/'+ObjectPrefix);
        p.setRedirect(true);
  
        return p;  
    }   

}