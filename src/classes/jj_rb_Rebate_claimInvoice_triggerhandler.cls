public class jj_rb_Rebate_claimInvoice_triggerhandler
{
    //Get SobjectType Prefix
            public static Sobjecttype claimType =  jj_rb_rebate_claim__c.sobjecttype;
            public static String prefix = claimType.getdescribe().getkeyprefix();
    
    public static void updateRebateClaim(List<Attachment> listnewAttach,boolean flag)
    {
            set<id> setClaimIds = new set<id>();
            list<jj_rb_Rebate_Claim__c> listupdateClaims = new list<jj_rb_Rebate_Claim__c>();
    
            for(Attachment attach : listnewAttach)
            {
                //Get Attachment's Parent Prefix
                String parentPrefix = attach.ParentId;
                if(parentPrefix.substring(0, 3) == prefix)
                {
                    setClaimIds.add(attach.ParentId);
                }
            }
             
            //Get claims
        	list<jj_rb_Rebate_Claim__c> listClaims = jj_rb_Rebate_claimInvoice_triggerhandler.getClaims(setClaimIds);
            
            
            for(jj_rb_Rebate_Claim__c claims : listClaims)
            {
                claims.jj_rb_Attachment_Present__c = flag;
                listupdateClaims.add(claims);
            }
            update listupdateClaims;
    }
    public static void BeforeDeleteAttactment(List<Attachment> listnewAttach)
    {
        set<id> claimID = new set<id>();
        map<id,Attachment> mapAttachment = new map<id,Attachment>(); // key-> ParentId
    	for(Attachment attach : listnewAttach)
        {
            //Get Attachment's Parent Prefix
            String parentPrefix = attach.ParentId;
            if(parentPrefix.substring(0, 3) == prefix)
            {
            	claimID.add(attach.ParentId);
                mapAttachment.put(attach.parentID,attach);
            }
        }
        
        list<jj_rb_Rebate_Claim__c> listclaim = jj_rb_Rebate_claimInvoice_triggerhandler.getClaims(claimID);
        
        //Get submitted claims
        for(jj_rb_Rebate_Claim__c claim : listclaim)
        {
            //Add Error
            Attachment att = mapAttachment.get(claim.Id);
            if(claim.jj_rb_Status__c == jj_rb_Rebate_utils.getRebateLineItemStatus('Submitted'))
            {
                att.addError('You cannot delete an attachment for a rebate claim in an approval process.');
            }
            else if(claim.jj_rb_Status__c == jj_rb_Rebate_utils.getRebateLineItemStatus('Approved'))
            {
                att.addError('You cannot delete an attachment for an approved rebate claim.');
            }
        }
    }
    public static list<jj_rb_Rebate_Claim__c> getClaims(set<id> listClaims)
    {
        return [select id,name,jj_rb_status__c,jj_rb_Attachment_Present__c 
                from jj_rb_Rebate_Claim__c 
                where id in : listClaims];
    }
}