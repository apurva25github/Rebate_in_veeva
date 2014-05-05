/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  1/05/2014
     @description  Test class for the homecare upload page
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    1/05/2014      Original Version
 */
@isTest
private class jj_rb_Test_Homecare_ClaimUpload { 	
    static testMethod void testUploadPage() {
    	Document d;
    	
    	
    	jj_rb_HomecareClaimUpload uploadController = new jj_rb_HomecareClaimUpload(); 
    	
    	// Pass -1 - upload with a an empty file
    	uploadController.upload();
    	
    	// Pass -2 - upload with a non CV file
    	d = new Document();
    	d.Body = prepareCSVBody();
    	d.Name = 'test.pdf';
    	uploadController.document = d;    	
        uploadController.upload();
    	
    	// Pass-2 - upload with a csv file
    	d = new Document();
    	d.Body = prepareCSVBody();
    	d.Name = 'test.csv';
    	uploadController.document = d;    	
        uploadController.upload();
        
        // Pass 3 - upload with a csv file  
        User testUser = setupTestUser();
              
        if(testUser != null) {
        	system.runAs(testUser) {
        		setupData(testUser);
        		 
        		 d = new Document();
		    	d.Body = prepareCSVBody();
		    	d.Name = 'test.csv';
		    	uploadController.document = d;    	
		        uploadController.upload();	
        	}        	
        }
       
    }
    
    private static Blob prepareCSVBody()
    {
    	String csvBody = 'SAP Customer No,Claim Month,Claim Year,Hospital Id,Hospital Name,Product EAN Code,Product Name,Quantity,Unit List Price (pack),Unit Contract Price(pack),Unit,Rebate (pack),Net Rebate,VAT Amount,VAT Code,Gross Rebate\n';
    	csvBody = csvBody + '221,01,2013,12345,,376769,Durogesic DTrans 50 8.4mg x 5patches,20,2.3,2,0.3,6,0.3,5,6.3';
    	
    	return Blob.valueOf(csvBody);
    }
    
    private static User setupTestUser()
    {
    	User testUser = jj_rb_Test_BaseClass.setupUser(); 
    	jj_rb_Test_BaseClass.setupRebateAnalystUser(testUser);
        jj_rb_Test_BaseClass.setupRebateNCMUser(testUser); 
        return testUser;
    }
    
    private static void setupData(User user)
    {
    	insert jj_rb_Test_BaseClass.setupHomecareCustomer(user);
    	insert jj_rb_Test_BaseClass.setupRebateProduct();
    	
    	jj_rb_Region__c region = jj_rb_Test_BaseClass.setupRegion();
    	jj_rb_NHS_Trust__c nhsTrust = jj_rb_Test_BaseClass.setupTrust(region);
    	jj_rb_Test_BaseClass.setupHospital(nhsTrust, user);   	
    }
    
    
    
}