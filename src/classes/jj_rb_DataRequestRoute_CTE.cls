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
    
    Set<Id> setRebatePermissionSets = new Set<Id>{'0PS1100000008QdGAI','0PS1100000008QeGAI', '0PS1100000008QfGAI','0PS1100000008QgGAI', '0PS1100000008QhGAI'};
    String accountId;
    
    public jj_rb_DataRequestRoute_CTE(ApexPages.standardController con)
    {
        accountId = Apexpages.currentPage().getParameters().get('Account_id');
        system.debug('accountId>>>' + accountId);   
    }
    
    public pageReference routeUser()
    {       
        if(!isRebateUser())
        {
           return routeToIConnect();
        }
        
        return null; 
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