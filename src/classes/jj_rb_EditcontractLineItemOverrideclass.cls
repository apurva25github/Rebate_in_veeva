public with sharing class jj_rb_EditcontractLineItemOverrideclass {
    public ApexPages.StandardController controller;
    public jj_rb_Rebate_Contract_Line_Item__c conlineitems;
    public string recordtype{set;get;}
    public String retURL {get; set;}
    public string status{set;get;}
    public string customer{set;get;}
    public string contract{set;get;}
   
    
      
    
    // Record Types of contract an lineitems
    String retailerclosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Retailer_Closed_Contract');
    String HomecareClosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Homecare_Closed_Contract');
    String contractlineClosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Retailer_Closed_Contract_Line_Item');
    String HCPlineitemClosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Homecare_Closed_Contract_Lineitem');
    String RetailerConLineitem_RT=jj_rb_Rebate_utils.getRecordTypeId('Contract_LineItem_Retailer');
    String HCPConLineItem_RT=jj_rb_Rebate_utils.getRecordTypeId('Homecare_Contract_Line_Item');
    String Status_closed=jj_rb_Rebate_utils.getRebateLineItemStatus('Closed');
    String Status_Expired=jj_rb_Rebate_utils.getRebateLineItemStatus('Expired');    
   
    public jj_rb_EditcontractLineItemOverrideclass(ApexPages.StandardController controller) {
        this.controller=controller;
        status=ApexPages.currentPage().getParameters().get('conlineitems.jj_rb_Status__c');
        recordtype=ApexPages.currentPage().getParameters().get('conlineitems.RecordType.name');
        contract=ApexPages.currentPage().getParameters().get('conlineitems.jj_rb_Rebate_Contract__c');
        customer=ApexPages.currentPage().getParameters().get('conlineitems.jj_rb_Rebate_Contract__r.jj_rb_customer__c');
        retURL = ApexPages.currentPage().getParameters().get('retURL');        
    }
    
    public Pagereference edit()
    {
        PageReference returnURL;
        conlineitems=(jj_rb_Rebate_Contract_Line_Item__c)controller.getRecord();
        //get the Rebate contract line items
        conlineitems=[select jj_rb_Status__c,jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__r.Name,
                            RecordTypeId,RecordType.name,jj_rb_Rebate_Contract__r.name,jj_rb_Rebate_Contract__r.jj_rb_customer__r.name,
                            jj_rb_Rebate_Contract__r.jj_rb_Status__c from jj_rb_Rebate_Contract_Line_Item__c
                            where id=:conlineitems.id];
        
        System.debug('@@@contractlineitems@@@@'+conlineitems);
        System.debug('@@@contractlineitems@@@@'+conlineitems.jj_rb_Status__c);
        System.debug('@@@contractlineitems@@@@'+conlineitems.RecordTypeID);
        
        if((conlineitems.jj_rb_Status__c==Status_Expired ||conlineitems.jj_rb_Status__c==Status_closed) 
                && (conlineitems.RecordTypeID==contractlineClosed_recordType || conlineitems.RecordTypeID==HCPlineitemClosed_recordType 
                    || conlineitems.RecordTypeID==HCPConLineItem_RT ||conlineitems.RecordTypeID==RetailerConLineitem_RT))
        {
           returnURL=new PageReference('/apex/jj_rb_contractLineItemEditOverride');
          
        }
        else 
        {
           
            returnURL=new PageReference('/'+conlineitems.id+'/e?nooverride=1');
           
        }
        returnURL.getParameters().put('retURL',retURL ); 
        returnURL.getParameters().put('recordtype',conlineitems.RecordType.name);
        returnURL.getParameters().put('Status',conlineitems.jj_rb_Status__c);
        returnURL.getParameters().put('contract',conlineitems.jj_rb_Rebate_Contract__r.name);
        returnURL.getParameters().put('customer',conlineitems.jj_rb_Rebate_Contract__r.jj_rb_customer__r.name);
        returnURL.getParameters().put('NCM',conlineitems.jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__r.Name);
        returnURL.getParameters().put('nooverride', '1');
        
        returnURL.setRedirect(true);
        

    return returnURL;
    }
    
   
    
}