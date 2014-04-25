/**********************************************************************
 Name:  jj_rb_Rebate_Contract_After_Update Trigger
 Capgemini India Ltd 

 Purpose:
    Changes the status of Rebate Contract Line Items to 'Approved', If the Rebate Contract gets Approved.

 History:
 VERSION  AUTHOR            DATE              DETAIL                                 
 1.0      Apurva Prasade    21/2/2014           Created trigger

***********************************************************************/ 

trigger jj_rb_Rebate_Contract_After_Update 
                        on jj_rb_Rebate_Contract__c (after Update) 
{
    
    
    List <jj_rb_Rebate_Contract_Line_item__c> Approved_List = new List <jj_rb_Rebate_Contract_Line_item__c>();
    
    // Get Updated Contracts.    
    Set<ID> setContractID = new Set<ID>();   
    
    String statusApproved = jj_rb_Rebate_utils.getRebateLineItemStatus('Approved');
    
    // Iterate over the 'updated_contracts' List
    // And Get Contract With Approved Status
    for(jj_rb_Rebate_Contract__c Rebate_Contract : trigger.new)
    {
        if(Rebate_Contract.jj_rb_Status__c != trigger.oldMap.get(Rebate_Contract.id).jj_rb_Status__c 
           && Rebate_Contract.jj_rb_Status__c == statusApproved)
        {
            // Add ID of the Contracts whose status is 'Approved' in a List. 
            setContractID.add(Rebate_Contract.Id);
        }
    }
    
    //Query those Line Items whose contracts has been 'Approved'.    
    List <jj_rb_Rebate_Contract_Line_item__c> line_item =[select Name, id, jj_rb_status__c ,jj_rb_Is_Modified__c
                                                    from jj_rb_Rebate_Contract_Line_item__c 
                                                    where jj_rb_Rebate_contract__c in : setContractID
                                                    and jj_rb_Status__c not in ('Closed', 'Expired')];
    
    //Iterate Over the Line Items 
    //And Change the Status to 'Approved'        
    for(jj_rb_Rebate_Contract_Line_Item__c Rebate_Line_Item : line_item)
    {
        if(Rebate_Line_Item.jj_rb_Status__c != statusApproved )
        {
            Rebate_Line_Item.jj_rb_status__c = statusApproved;
            Rebate_Line_Item.jj_rb_Is_Modified__c = false;
            Approved_List.add(Rebate_Line_Item);
        }  
    }   
    if(!Approved_List.isEmpty())
    {
        try {
            update(Approved_List);
        }
        catch(Exception ex)
        {
            Trigger.new[0].addError(ex.getMessage());   
        }      
    }
}