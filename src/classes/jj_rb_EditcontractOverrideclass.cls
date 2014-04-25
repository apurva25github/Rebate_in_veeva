public with sharing class jj_rb_EditcontractOverrideclass{
     public ApexPages.StandardController controller;
     public jj_rb_Rebate_Contract__c contracts;
     public string recordtype{set;get;}
     public String retURL {get; set;}
     public string status{set;get;}
     public string customer{set;get;}
     public string contract{set;get;}
     public string product{set;get;}
     
     //Record Types
      
     String retailercontract_recordType=jj_rb_Rebate_utils.getRecordTypeId('Retailer Contract');
     String HomecareContract_recordType=jj_rb_Rebate_utils.getRecordTypeId('Home care Provider contract');   
     
     
     String Status_Expired=jj_rb_Rebate_utils.getRebateLineItemStatus('Expired');    
     //constructor
     public jj_rb_EditcontractOverrideclass(ApexPages.StandardController controller)
     {
        this.controller=controller;
        status=ApexPages.currentPage().getParameters().get('contracts.jj_rb_Status__c');
        recordtype=ApexPages.currentPage().getParameters().get('contracts.RecordType.name');
        customer=ApexPages.currentPage().getParameters().get('contracts.jj_rb_customer__r.name');
        contract=ApexPages.currentPage().getParameters().get('contracts.name');
        product=ApexPages.currentPage().getParameters().get('contracts.jj_rb_Product__r.name');
        retURL = ApexPages.currentPage().getParameters().get('retURL');     
     
     }
     public Pagereference Edit()
    {
        PageReference returnURL;
        contracts=(jj_rb_Rebate_Contract__c)controller.getRecord();
        //get the Rebate contracts 
        contracts=[select jj_rb_Status__c,name,RecordTypeId,RecordType.name,jj_rb_Product__r.name,
                        jj_rb_customer__c,jj_rb_Customer__r.name from jj_rb_Rebate_Contract__c
                        where id=:contracts.id];
        if(contracts.jj_rb_Status__c==Status_Expired && contracts.RecordTypeId==retailercontract_recordType)
        {
            returnURL=new PageReference('/apex/jj_rb_contractEditOverrideforRetailer?id='+contracts.id);        
        
        } else if(contracts.jj_rb_Status__c==Status_Expired && contracts.RecordTypeId==HomecareContract_recordType)
        {
            returnURL=new PageReference('/apex/jj_rb_contractEditOverrideforHomecare?id='+contracts.id);     
        }else        
        {           
            returnURL=new PageReference('/'+contracts.id+'/e?nooverride=1');           
        }
        returnURL.getParameters().put('retURL',retURL ); 
        returnURL.getParameters().put('recordtype',contracts.RecordType.name);
        returnURL.getParameters().put('Status',contracts.jj_rb_Status__c);       
        returnURL.getParameters().put('customer',contracts.jj_rb_customer__r.name); 
        returnURL.getParameters().put('contract',contracts.name); 
        returnURL.getParameters().put('product',contracts.jj_rb_Product__r.name);           
        returnURL.getParameters().put('nooverride', '1');
        
        returnURL.setRedirect(true);
        

    return returnURL;
    }
     




}