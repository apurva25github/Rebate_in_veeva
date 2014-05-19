/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  25/04/2014
     @description  Extension for the Data request routing page
 
     Function: Routes the user to either the intermediate data request page or the iconnect
                New data request page.
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    25/04/2014      Original Version
 */
public  class jj_rb_DataRequestRoute_CTE {  
    
    public Boolean rebateUser {get; set;}
    public String routeOption {get; set;}
    public String ITEM_VAL_ICONNECT {get{return 'iCONNECT';}}
    public String ITEM_VAL_REBATE {get{return 'REBATE';}}
    
    Set<Id> setRebatePermissionSets = new Set<Id>();
    String accountId;
    
    public jj_rb_DataRequestRoute_CTE(ApexPages.standardController con)
    {
        accountId = Apexpages.currentPage().getParameters().get('Account_id');
        system.debug('accountId>>>' + accountId);   
        
        for(jj_rb_Rebate_Permission_Set__c permissionSet  : [SELECT jj_rb_Permission_Set_Id__c,Name 
        															FROM jj_rb_Rebate_Permission_Set__c])	
        {
        	setRebatePermissionSets.add(permissionSet.jj_rb_Permission_Set_Id__c);
        }															
    }
    
    // page load event
    // Redirect to iConnect Data Request Page - 
    // if not a rebate user
    // if data request created for a hospital customer
    public pageReference routeUser()    
    {       
        if(!isRebateUser() || isHospital())
        {
           return routeToIConnect();
        }
        
        return null; 
    }
    
    private boolean isHospital()
    {
    	// check if the data request account is a hospital 
    	if(String.isNotBlank(accountId)) {
	    	List<Account> hospitals = [SELECT Account_Type__c, Structure_Type_JJ__c, recordtypeId, 
	    									 Primary_Parent_vod__c, recordtype.DeveloperName 
	    									FROM Account where id = :accountId];
	    	if(!hospitals.isEmpty())
	    		return jj_rb_Rebate_utils.isHospital(hospitals[0]);    									
    	}    									
    	return false;
    } 
    
    public pageReference routeToSelection()
    {
      system.debug('routeOption >>>>' + routeOption );
      if(routeOption == ITEM_VAL_ICONNECT)
      {
          system.debug('routing to iconnect>>>');
          return routeToIConnect();
      }
      if(routeOption == ITEM_VAL_REBATE)
      {
          system.debug('routing to rebate>>>');
          return routeToRebateMDR();
      }
      return null;
    }
    
    private PageReference routeToIConnect()
    {
         PageReference pageRef;
         pageRef = new Pagereference('/apex/jj_DataRequest?Account_id=' + accountId);
         pageRef.setRedirect(true);
         system.debug('iconnect pageRef>>>' + pageRef);
         return pageRef;
    }
    
    private PageReference routeToRebateMDR()
    {
        PageReference pageRef = new PageReference('/apex/jj_rb_Rebate_Account_RequestChange?id=' + accountId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private boolean isRebateUser()
    {
        // get the current user and check if part of any rebate permission set.
        String currentUserId = UserInfo.getUserId();
        
        // check if the user is subscribed to the rebate permission set
        List<PermissionSetAssignment> listPermissionSets = [select Id from PermissionSetAssignment 
                                                                    where AssigneeId = :currentUserId
                                                                    and PermissionSetId  in :setRebatePermissionSets];
                                                                    
        if(!listPermissionSets.isEmpty()) {
            return true;
        }
        return false;
    }
}