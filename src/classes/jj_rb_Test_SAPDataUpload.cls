/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  1/05/2014
     @description  Test class for the SAP Data Upload page and batch process
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    1/05/2014      Original Version
 */

@IsTest
private class jj_rb_Test_SAPDataUpload {
	static testMethod void testSAPDataUpload() {  
		 //setup data
		 User u = jj_rb_Test_BaseClass.setupUser();
		 	 
		 // start test
		 Test.startTest();
		 
		 system.runas(u) {
			 setupData(u);
			 
			 jj_rb_UploadSAPDataController controller = new jj_rb_UploadSAPDataController(new ApexPages.Standardcontroller(new jj_rb_Rebate_SAP_Job__c()));
			 
			 // positive case
			 controller.myfile = new Attachment();
			 controller.myfile.name = 'testfile.csv';
			 controller.myfile.Body = setupGoodSAPFile();  
			 controller.Savedoc();
			 
			 // negative case
			 controller.myfile = new Attachment();
			 controller.myfile.name = 'testfile2.csv';
			 controller.myfile.Body = setupBadSAPFile();  
			 controller.Savedoc();
			 
			 // check if the attachment was saved.
			 List<Attachment> listAttachment = [select id, name from Attachment where name = 'testfile.csv'];
			 system.assertEquals(listAttachment.isEmpty(), false);
		 }
		 
		 Test.stopTest();
	}
	
	private static Blob setupGoodSAPFile()
	{
		String fileBody = 'Invoice Type,SAP Customer Id,SAP Material No,Net Trade Sales,Invoice Qty,Month,Year\n';
		fileBody += 'HOMECARE PHARMACY,221,376769,12345,1000,01,2014';
		return Blob.valueOf(fileBody);
	} 
	
	private static Blob setupBadSAPFile()
	{
		//String fileBody = 'Invoice Type,SAP Customer Id,SAP Material No,Net Trade Sales,Invoice Qty,Month,Year\n';
		String fileBody = 'Invoice Type,SAP Customer Id,SAP Material No,Net Trade Sales,Invoice Qty,Month,Year\n';
		fileBody += 'HOMECARE PHARMACY,,376769,100,100,14,2014';
		return Blob.valueOf(fileBody);
	}
	
	private static void setupData(User u)
	{		
		jj_rb_Test_BaseClass.setupRebateNCMUser(u);
		jj_rb_Test_BaseClass.setupRebateProduct();
		jj_rb_Test_BaseClass.setupHomecareCustomer(u);
	}
}