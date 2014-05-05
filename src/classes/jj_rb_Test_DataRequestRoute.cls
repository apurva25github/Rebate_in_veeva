/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  1/05/2014
     @description  Test class for the Data Request Route page
     
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    1/05/2014      Original Version
 */

@IsTest
private class jj_rb_Test_DataRequestRoute {
	static testMethod void testDataRequestRoute() {
		
		Test.startTest();
		
		jj_rb_Test_BaseClass.setupCustomSettings();
		// setup test user
		User testUser = jj_rb_Test_BaseClass.setupUser();
			
		// run as iConnect user
		system.runas(testUser) {
			// setup test account
			Account a = jj_rb_Test_BaseClass.setupHomecareCustomer(testUser);
			insert a;
			
			// setup VF page
			Pagereference pageRef = Page.jj_rb_DataRequestRoute;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('Account_id',a.id);
			
			// run for option iCOnnect
			jj_rb_DataRequestRoute_CTE controller = new jj_rb_DataRequestRoute_CTE(new ApexPages.Standardcontroller(a));			
		    controller.routeOption = controller.ITEM_VAL_ICONNECT;
		    controller.routeUser();
			
			// run for option Rebate
			controller.routeOption = controller.ITEM_VAL_REBATE;
		    system.assertNotEquals(null,controller.routeUser());
			
		}	
		
			
		// run as a rebate user
		system.runas(testUser) {
			jj_rb_Test_BaseClass.setupRebateAnalystUser(testUser);	
			
			// setup test account
			Account a = jj_rb_Test_BaseClass.setupHomecareCustomer(testUser);
			insert a;
			
			// setup VF page
			Pagereference pageRef = Page.jj_rb_DataRequestRoute;
			Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('Account_id',a.id);
			
			// run for option iCOnnect
			jj_rb_DataRequestRoute_CTE controller = new jj_rb_DataRequestRoute_CTE(new ApexPages.Standardcontroller(a));			
		    controller.routeOption = controller.ITEM_VAL_ICONNECT;
		    controller.routeUser();
			
			// run for option Rebate
			controller.routeOption = controller.ITEM_VAL_REBATE;
		    system.assertEquals(null,controller.routeUser());
		    system.assertNotEquals(null,controller.routeToSelection());
		}
		Test.stopTest();		
		
	}
	
	private static void setupUsers()
	{
		
	}
	
	private static void setupData()
	{
		
	}
}