trigger jj_rb_Rebate_Claim_validation on jj_rb_Rebate_Claim__c (before insert,before update) 
{
/**********************************************************************
 Name: Rebate_Claim_validation Trigger
 Capgemini India Ltd 

 Purpose:
  It is used for Validation of "Duplicate month for this Customer" and "Duplicate Year for this Customer" on the Rebate Claim Object

 History:
 VERSION      AUTHOR            DATE              DETAIL                                 
 1.0      MangaDivya Kasani     10/2/2014       Created classes/trigger

***********************************************************************/ 
    List<jj_rb_Rebate_Claim__c> RClaimlist=System.Trigger.new;
    List<jj_rb_Rebate_Claim__c> RClistdata= new  List<jj_rb_Rebate_Claim__c>();
    Set<ID> setids= new Set<ID>();
    List<jj_rb_Rebate_Claim__c> UpdatedClaim = new list<jj_rb_Rebate_Claim__c>();
    
   List<Account> accNCM = new List<Account>([select Id, jj_rb_National_Channel_Manager__c,name from Account]);
    for(jj_rb_Rebate_Claim__c RClaim:RClaimlist)
    {
        setids.add(RClaim.jj_rb_Customer__c);
        for(Account acc : accNCM)
        {
            if(RClaim.jj_rb_Customer__c == acc.Id)
            {
                if(acc.jj_rb_National_Channel_Manager__c != null) {
                    RClaim.OwnerId = acc.jj_rb_National_Channel_Manager__c;
                } else {
                    RClaim.addError('No National Channel Manager selected for claim customer ' + acc.Name + '.');
                }    
            }
        }
    }
    
    RClistdata=[SELECT jj_rb_month__c,jj_rb_Year__c FROM jj_rb_Rebate_Claim__c where jj_rb_Customer__c IN:setids];
    
    for(jj_rb_Rebate_Claim__c RClaim:RClaimlist)
    {
        for(jj_rb_Rebate_Claim__c R_claim:RClistdata)
        {
            if(System.Trigger.isInsert || (RClaim.jj_rb_Month__c!=System.Trigger.oldMap.get(RClaim.Id).jj_rb_Month__c && RClaim.jj_rb_year__c!=System.Trigger.oldMap.get(RClaim.Id).jj_rb_Year__c))
            {
                if((R_claim.jj_rb_month__c == RClaim.jj_rb_Month__c && R_claim.jj_rb_Year__c==RClaim.jj_rb_Year__c ) && RClaim.jj_rb_Month__c !=null && RClaim.jj_rb_year__c !=null)
                {
                    RClaim.addError('Duplicate month and year for this Customer');
                }
               /* else IF((R_claim.jj_rb_Year__c==RClaim.jj_rb_Year__c) && RClaim.jj_rb_Year__c!=null)
                {
                    RClaim.addError('Duplicate Year for this Customer');
                }*/
                
            }
      
        }
    }
      
}