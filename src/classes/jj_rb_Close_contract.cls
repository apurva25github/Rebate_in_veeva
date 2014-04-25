public class jj_rb_Close_contract
{
   public jj_rb_rebate_contract__c contract {get; set;} 
   ApexPages.StandardController controller;
    public boolean Block1 {get; set;}
     public boolean Block2 {get; set;}
   public jj_rb_Close_contract(ApexPages.StandardController controller) {
      this.controller = controller;
      contract = (jj_rb_rebate_contract__c)controller.getRecord();  
      contract = [select Id, jj_rb_Closure_Status__c, jj_rb_Closure_Comment__c,jj_rb_status__c,name,(select ID,name,jj_rb_status__c from Rebate_Contract_Line_Items__r )
                        from jj_rb_rebate_contract__c
                        where id = :contract.id limit 1];
       if(contract.jj_rb_Status__c == 'Submitted')
       {
            Block1 = true;
            Block2 = False;
       }
       else
       {
            Block1 = False;
            Block2 = true;
       }
    }

    
   
    public pageReference close_contract()
    { 
        
        String Closed = jj_rb_Rebate_utils.getRebateLineItemStatus('Closed');
        
        list<jj_rb_Rebate_Contract_Line_Item__c> ListLine_Item = new list<jj_rb_Rebate_Contract_Line_Item__c>();
            
        // System.debug('Contract **** '+ contract.Rebate_Contract_Line_Items__r);
        // Iterate over Line Items and update the Status.
        for(jj_rb_Rebate_Contract_Line_Item__c RCIL : contract.Rebate_Contract_Line_Items__r)
        {   Id RecID  = RCIL.RecordTypeId;
            
            if(RecID   == jj_rb_Rebate_utils.getRecordTypeId('Contract_LineItem_Retailer'))
            { 
                RCIL.jj_rb_status__c = Closed;
                RCIL.RecordTypeId = jj_rb_Rebate_utils.getRecordTypeId('Retailer_Closed_Contract_Line_Item');
            }
            //system.debug('Line Item *** '+ RecID  + ' Custom Setting *** '  + utils.getRecordTypeId('Retailer contract line item'));
            else if(RecID == jj_rb_Rebate_utils.getRecordTypeId('Homecare_Contract_Line_Item'))
            {
                RCIL.jj_rb_status__c = Closed;
                RCIL.RecordTypeId =  jj_rb_Rebate_utils.getRecordTypeId('Homecare_Closed_Contract_Lineitem');
            }
            ListLine_Item.add(RCIL);
        }
        
        //Update Contract Status
        if(contract.RecordTypeId  == jj_rb_Rebate_utils.getRecordTypeId('Rebate_Contract_Retailer'))
        {
            contract.jj_rb_Status__c = Closed;
            contract.RecordTypeId = jj_rb_Rebate_utils.getRecordTypeId('Retailer_Closed_Contract');
        }
        else if(contract.RecordTypeId == jj_rb_Rebate_utils.getRecordTypeId('Homecare_Contract'))
        {
            contract.jj_rb_Status__c = Closed;
            contract.RecordTypeId = jj_rb_Rebate_utils.getRecordTypeId('Homecare_Closed_Contract');
        }
        if(!ListLine_Item.isEmpty())
        {
           update(ListLine_Item);
        }
        update(contract);
        pageReference pgref = New ApexPages.StandardController(contract).view();
        pgref.setRedirect(true);
        Return pgref;
    }
}