/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  1/05/2014
     @description  Test class for the IMS Data Upload page and batch process
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    1/05/2014      Original Version
 */

@IsTest
private class jj_rb_Test_IMSDataUpload {
	static testMethod void testIMSDataUpload() {  
		 //setup data
		 User u = jj_rb_Test_BaseClass.setupUser();
		 	 
		 // start test
		 Test.startTest();
		 
		 system.runas(u) {
			 setupData(u);
			 
			 jj_rb_UploadIMSDataController controller = new jj_rb_UploadIMSDataController(new ApexPages.Standardcontroller(new jj_rb_Rebate_IMS_Job__c()));
			 
			 // positive case
			 controller.myfile = new Attachment();
			 controller.myfile.name = 'testfile.csv';
			 controller.myfile.Body = setupGoodIMSFile();  
			 controller.Savedoc();
			 
			 // negative case
			 controller.myfile = new Attachment();
			 controller.myfile.name = 'testfile.csv';
			 controller.myfile.Body = setupBadIMSFile();  
			 controller.Savedoc();
			 
			 // check if the attachment was saved.
			 List<Attachment> listAttachment = [select id, name from Attachment where name = 'testfile.csv'];
			 system.assertEquals(listAttachment.isEmpty(), false);
		 }
		 
		 Test.stopTest();
	}
	
	private static Blob setupGoodIMSFile()
	{
		String fileBody = 'Outlet Type,Customer Name,IMS Customer Id,Product Name,Product Info,IMS Product Id,Month,Year,Qty\n';
		fileBody += 'RETAIL PHARMACY,test customer,221,testproduct,testproductInfo,12345,01,2014,1000';
		return Blob.valueOf(fileBody);
	} 
	
	private static Blob setupBadIMSFile()
	{
		String fileBody = 'Outlet Type,Customer Name,IMS Customer Id,Product Name,Product Info,IMS Product Id,Month,Year,Qty\n';
		fileBody += 'RETAIL PHARMACY,test customer,xyz,testproduct,testproductInfo,12345,01,2014,1000';
		return Blob.valueOf(fileBody);
	}
	
	private static void setupData(User u)
	{		
		jj_rb_Test_BaseClass.setupRebateNCMUser(u);
		insert jj_rb_Test_BaseClass.setupRebateProduct();
		insert jj_rb_Test_BaseClass.setupRetailerCustomer(u);		
	}
}