public with sharing class jj_rb_EditcontractLineItemOverrideclass {
    public ApexPages.StandardController controller;
    public jj_rb_Rebate_Contract_Line_Item__c conlineitems;
    public string recordtype{set;get;}
    public String retURL {get; set;}
    public string status{set;get;}
    public string customer{set;get;}
    public string contract{set;get;}
    public string editContractLineItem{get{return 'Edit';}}
    public string cloneContractLineItem{get{return 'Clone';}}
    public boolean show_optns{get; set;}
    public boolean show_error{get; set;}
    public boolean show_clone{get; set;}
    public string editOption{get; set;}
    public string show_closeError{get; set;}
    
    // Record Types of contract an lineitems
    String retailerclosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Retailer_Closed_Contract');
    String HomecareClosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Homecare_Closed_Contract');
    String contractlineClosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Retailer_Closed_Contract_Line_Item');
    String HCPlineitemClosed_recordType=jj_rb_Rebate_utils.getRecordTypeId('Homecare_Closed_Contract_Lineitem');
    String RetailerConLineitem_RT=jj_rb_Rebate_utils.getRecordTypeId('Contract_LineItem_Retailer');
    String HCPConLineItem_RT=jj_rb_Rebate_utils.getRecordTypeId('Homecare_Contract_Line_Item');
    String Status_closed=jj_rb_Rebate_utils.getRebateLineItemStatus('Closed');
    String Status_Expired=jj_rb_Rebate_utils.getRebateLineItemStatus('Expired');  
    String Status_approved = jj_rb_Rebate_utils.getRebateLineItemStatus('Approved');
    String Status_modified = jj_rb_Rebate_utils.getRebateLineItemStatus('Modified');
    String status_new = jj_rb_Rebate_utils.getRebateLineItemStatus('New');
    String status_rejected = jj_rb_Rebate_utils.getRebateLineItemStatus('Rejected');
    String status_submitted = jj_rb_Rebate_utils.getRebateLineItemStatus('Submitted');
    string statusField = jj_rb_Rebate_utils.getRecordTypeId('Contract_status_field');
    
    public jj_rb_EditcontractLineItemOverrideclass(ApexPages.StandardController controller) {
        this.controller=controller;
        status=ApexPages.currentPage().getParameters().get('conlineitems.jj_rb_Status__c');
        recordtype=ApexPages.currentPage().getParameters().get('conlineitems.RecordType.name');
        contract=ApexPages.currentPage().getParameters().get('conlineitems.jj_rb_Rebate_Contract__c');
        customer=ApexPages.currentPage().getParameters().get('conlineitems.jj_rb_Rebate_Contract__r.jj_rb_customer__c');
        retURL = ApexPages.currentPage().getParameters().get('retURL');        
    }
    PageReference returnURL;
    public Pagereference edit()
    {
        //PageReference returnURL;
        conlineitems=(jj_rb_Rebate_Contract_Line_Item__c)controller.getRecord();
        //get the Rebate contract line items
        conlineitems=[select jj_rb_Status__c,jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__r.Name,
                            RecordTypeId,RecordType.name,jj_rb_Rebate_Contract__r.name,jj_rb_Rebate_Contract__r.jj_rb_customer__r.name,
                            jj_rb_Rebate_Contract__r.jj_rb_Status__c from jj_rb_Rebate_Contract_Line_Item__c
                            where id=:conlineitems.id];
        
        System.debug('@@@contractlineitems@@@@'+conlineitems.jj_rb_Rebate_Contract__r.jj_rb_Status__c +' ***** '+status_submitted);
        System.debug('Status of line item ***** '+conlineitems);
        if(conlineitems.jj_rb_Status__c==Status_closed
                && (conlineitems.RecordTypeID==contractlineClosed_recordType || conlineitems.RecordTypeID==HCPlineitemClosed_recordType 
                    || conlineitems.RecordTypeID==HCPConLineItem_RT ||conlineitems.RecordTypeID==RetailerConLineitem_RT))
        {
        	show_optns = false;
        	show_clone = true;
        	show_closeError = 'A closed contract line item cannot be modified';
           //returnURL=new PageReference('/apex/jj_rb_contractLineItemEditOverride');
          
        }
        else if(conlineitems.jj_rb_Rebate_Contract__r.jj_rb_Status__c == status_submitted)
        {
        	show_clone = true;
        	show_optns = false;
        	show_closeError = 'A submitted contract line item cannot be modified';
        }
        else if(conlineitems.jj_rb_Status__c == Status_Expired)
        {
        	//returnURL=new PageReference('/apex/jj_rb_EditcontractLineItem');
        	
        	show_error = true;
			show_clone = false;
        	return redirect();
        }
        else if(conlineitems.jj_rb_Status__c == Status_approved || conlineitems.jj_rb_Status__c == Status_modified || conlineitems.jj_rb_Status__c == status_new || conlineitems.jj_rb_Status__c == status_rejected)
        {
        	// Render options Edit/Clone
        	show_optns = true;
           	return redirect();
        }
       
        return returnURL;
    }
    
    public Pagereference redirect()
    {
    	if(editOption == editContractLineItem)
      	{
      		//Redirect to Edit page
      		returnURL=new PageReference('/'+conlineitems.id+'/e?nooverride=1');
        		 	returnURL.getParameters().put('retURL',conlineitems.id ); 
    				return returnURL;
        }
        if(editOption == cloneContractLineItem)
        {
        	//Redirect to clone page
        	returnURL=new PageReference('/'+conlineitems.id+'/e?clone=1&'+statusField+'='+status_new);
        	returnURL.getParameters().put('retURL',retURL ); 
			        
        	return returnURL;	
        }
    	return null;
    }
}