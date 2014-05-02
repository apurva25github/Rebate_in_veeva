public class jj_rb_Test_BaseClass {
	public static Account setupHomecareCustomer(User ncmUser)
    {
    	Id hcpRecordtype = getRecordTypeId('Homecare provider', 'Account');
    	
    	Account a = new Account();
    	a.jj_rb_National_Channel_Manager__c = ncmUser.Id;
    	a.jj_rb_SAP_Customer_Number__c = '221';
    	a.jj_rb_SAP_Vendor_Number__c = '221';
    	a.RecordTypeId = hcpRecordtype; 
		a.Name = 'test Account';
		
    	insert a;
    	return a;
    	
    }
    
    public static jj_rb_Rebate_Product__c setupRebateProduct()
    {
    	jj_rb_VAT_Code__c vatCode = setupVATCode();
    	
    	jj_rb_Rebate_Product__c product = new jj_rb_Rebate_Product__c();
    	product.jj_rb_SAP_EAN_Code__c = '376769';
    	product.jj_rb_SAP_Material_Number__c = '376769';
    	product.Name = 'Test Product';
    	product.jj_rb_Description__c = 'Product description';
    	product.jj_rb_VAT_Code__c = vatCode.id;
    	
    	insert product;
    	return product;
    }
    
    public static Account setupHospital(jj_rb_NHS_Trust__c trust, User ncmUser)
    {
    	Id hospitalRecordtype = getRecordTypeId('Hospital_vod', 'Account');
    	Account a = new Account();
    	a.jj_rb_NHS_Trust__c = trust.id;
    	a.CODS_External_Id__c = '12345';
    	a.RecordTypeId = hospitalRecordtype;
    	a.name = 'Test Hospital';
    	
    	
    	if(ncmUser != null)
    		a.jj_rb_National_Channel_Manager__c = ncmUser.Id;
   
    	insert a;
    	return a;
    	
    }
    
    public static jj_rb_VAT_Code__c setupVATCode()
    {
    	jj_rb_VAT_Code__c vat = new jj_rb_VAT_Code__c();
    	vat.jj_rb_VAT__c = 20;
    	vat.jj_rb_VAT_External_Id__c = '20';
    	vat.Name = 'test vat';
    	
    	insert vat;
    	return vat;
    }
    
    public static jj_rb_NHS_Trust__c setupTrust(jj_rb_Region__c r)
    {
    	jj_rb_NHS_Trust__c t = new jj_rb_NHS_Trust__c();
    	t.Name = 'Test Trust';
    	t.jj_rb_NHS_Trust_ID__c = '12345';
    	t.jj_rb_Business_Phone__c = '12312344123';
    	t.jj_rb_Business_Postal_Code__c = '1234567';
    	t.jj_rb_Business_Street__c = 'trust street';
    	t.jj_rb_Business_City__c = 'trust city';
    	t.jj_rb_Region__c = r.Id;
    	insert t;
    	return t;
    }
    
    // create a test region
    public static jj_rb_Region__c setupRegion()
    {
    	jj_rb_Region__c r = new jj_rb_Region__c();
    	r.jj_rb_Description__c = 'test region';
    	r.Name = 'TestRegion';
    	insert r;
    	return r;
    }
    
    
    
    public static Id getRecordTypeId(String recordTypeName, String objectName)
    {
    	List<RecordType> r = [select Id from RecordType 
    								where name = :recordTypeName 
    								and SobjectType = :objectName limit 1];
    	if(!r.isEmpty())
    		return r[0].Id;
    	return null;	
    }
    
    public static User setupRebateNCMUser(User u)
    {
    	// get rebate analyst permission set
    	List<PermissionSet> permissionSetNCM = [select Id from PermissionSet where name = 'jj_rb_UK_Rebate_NCM' limit 1];
    	    	
    	if(!permissionSetNCM.isEmpty())
    	{
    		//return getUser(permissionSetNCM[0].Id);
    		PermissionSetAssignment pa = new PermissionSetAssignment();
	    	pa.AssigneeId = u.Id;
	    	pa.PermissionSetId =  permissionSetNCM[0].Id;	
	    	insert pa;												
    	}
    	return null;	
    }
    
    public static User getUser(String permissionSetId)
    {
    	if(String.isNotBlank(permissionSetId))
    	{
    		List<User> listUser = [select Id from User 
    								where isActive = true 
    								and id in (SELECT AssigneeId 
    												FROM PermissionSetAssignment where PermissionSetId = :permissionSetId) limit 1];    		
    		
    		
    		if(!listUser.isEmpty())
    			return listUser[0];	
    	}
    	return null;
    }
    
    public static User setupRebateAnalystUser(User u)
    {
    	// get rebate analyst permission set
    	List<PermissionSet> permissionSetAnalyst = [select Id from PermissionSet where name = 'jj_rb_UK_Rebate_Analyst' limit 1];
    	if(!permissionSetAnalyst.isEmpty())
    	{
    		//return getUser(permissionSetAnalyst[0].Id);    		
    		PermissionSetAssignment pa = new PermissionSetAssignment();
	    	pa.AssigneeId = u.Id;
	    	pa.PermissionSetId =  permissionSetAnalyst[0].Id;	
	    	insert pa;    														
    	}
    	return null;
    }
    
    public Static User setupUser()
    {
    	Profile prof = [select id from profile where name = 'System Administrator'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');
        insert u;
        return u;
    }
    
    public static void setupCustomSettings()
    {
    	// set the custom setting  for permission set
    	List<jj_rb_Rebate_Permission_Set__c> listPermissionSetCustomSetting = new List<jj_rb_Rebate_Permission_Set__c>();
    	List<PermissionSet> listPermissionSet = [select Id, name  from PermissionSet where name like 'jj_rb_UK_Rebate_%'];
    	for(PermissionSet pm : listPermissionSet) {
    		jj_rb_Rebate_Permission_Set__c rps = new jj_rb_Rebate_Permission_Set__c();
    		rps.name = pm.name;
    		rps.jj_rb_Permission_Set_Id__c = pm.id;
    		listPermissionSetCustomSetting.add(rps);
    	}
    	if(!listPermissionSetCustomSetting.isEmpty())
    		insert listPermissionSetCustomSetting;
    	
    }
    

}