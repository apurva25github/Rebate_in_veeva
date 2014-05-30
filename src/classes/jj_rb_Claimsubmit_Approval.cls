global class jj_rb_Claimsubmit_Approval
{
    webservice static void Submitforapproval(list<id> listClaim)
    {
    	string statusApproved = jj_rb_Rebate_utils.getRebateLineItemStatus('Approved');
    	string statusSubmitted = jj_rb_Rebate_utils.getRebateLineItemStatus('Submitted');
    	//system.debug('******* List of claims '+listClaim);
        List<jj_rb_rebate_claim__C> listclaimrec = [select id,name,jj_rb_Description__c,jj_rb_Status__c from jj_rb_rebate_claim__c where id IN : listClaim and jj_rb_Status__c Not IN ('Approved','Submitted')];
        //System.debug('**************** selected new records ****** '+listclaimrec);
        
        for(jj_rb_rebate_claim__C claimrec : listclaimrec)
        {
        	Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
       		req.setObjectId(claimrec.id);  
       		Approval.ProcessResult result = Approval.process(req);	
        }   
    }
}