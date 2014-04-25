trigger jj_rb_Rebate_Buying_GRPMembers_before_insert on jj_rb_Retailer_Buying_Group_Member__c (Before insert,before update) 
{
    list<jj_rb_Retailer_Buying_Group_Member__c> new_members = trigger.new;
    
    List<ID> listbuying_grp = new List<ID>();
    
    //  Add Retailer Buying Group ID to a list
    for(jj_rb_Retailer_Buying_Group_Member__c members : new_members)
    {
        listbuying_grp.add(members.jj_rb_Lead_Retailers__c);
    }
    
    //Retrieve members of groups whose IDs present in list
    list<jj_rb_Retailer_Buying_Group_Member__c> exists_members = [select jj_rb_customer__c ,name,jj_rb_Lead_Retailers__c
                                                                  from jj_rb_Retailer_Buying_Group_Member__c
                                                                 where jj_rb_Lead_Retailers__c IN : listbuying_grp]; 
    
    // check any member is present for perticular customer, if yes then add error
    for(jj_rb_Retailer_Buying_Group_Member__c members : new_members)
    {
        
        for(jj_rb_Retailer_Buying_Group_Member__c oldMembers :  exists_members)
        {
            if(members.id != oldMembers.id)
            {
                if(members.jj_rb_Lead_Retailers__c == oldMembers.jj_rb_Lead_Retailers__c )
                {
                    if(members.jj_rb_customer__c == oldMembers.jj_rb_customer__c )
                    {
                    members.addError('Retailer buying group member with same customer is already present');
                    }
                }
            }
        }
    }
}