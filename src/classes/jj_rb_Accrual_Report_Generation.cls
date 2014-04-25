global class jj_rb_Accrual_Report_Generation implements Database.batchable<sObject>, Database.Stateful{
    global Map<id,Map<String, jj_rb_Rebate_Accrual_Report_Line_Item__c>> mapAccrualMain = 
                                                               new Map<id, Map<String, jj_rb_Rebate_Accrual_Report_Line_Item__c>>();    // outer key -> accrual recordtype id and inner key -> product id
    
    global  Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select Id, jj_rb_Product__c, jj_rb_Net_Rebate_Accrual_After_Adj__c, jj_rb_Volume__c,jj_rb_Rebate_Accrual__r.RecordTypeId from jj_rb_Rebate_Accrual_Line_Item__c where jj_rb_Rebate_Accrual__r.jj_rb_Status__c = \'Approved\' and jj_rb_Rebate_Accrual__r.jj_rb_Accrual_Date__c = this_month order by jj_rb_Product__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(jj_rb_Rebate_Accrual_Line_Item__c accrualLineItem : (List<jj_rb_Rebate_Accrual_Line_Item__c>) scope)
        {
            String accrualRecordType = accrualLineItem.jj_rb_Rebate_Accrual__r.RecordTypeId;
            
            Map<String, jj_rb_Rebate_Accrual_Report_Line_Item__c> mapReportLineItems;
            if(mapAccrualMain.containsKey(accrualRecordType))
            {
                mapReportLineItems = mapAccrualMain.get(accrualRecordType);              
            } else {
                // create the map of report line items 
                mapReportLineItems =  new Map<String, jj_rb_Rebate_Accrual_Report_Line_Item__c>();              
            }
            mapReportLineItems = getReportLineItemsMap(accrualLineItem, mapReportLineItems);
            mapAccrualMain.put(accrualRecordType, mapReportLineItems);      
                
        }       
    }
    
    private Map<String, jj_rb_Rebate_Accrual_Report_Line_Item__c> getReportLineItemsMap(jj_rb_Rebate_Accrual_Line_Item__c accrualLineItem,
                                                                                    Map<String, jj_rb_Rebate_Accrual_Report_Line_Item__c> mapReportLineItems)
    {
        
            jj_rb_Rebate_Accrual_Report_Line_Item__c reportLineItem;
            if(mapReportLineItems.containsKey(accrualLineItem.jj_rb_Product__c))
            {
                reportLineItem = mapReportLineItems.get(accrualLineItem.jj_rb_Product__c);
                reportLineItem.jj_rb_Net_Rebate__c +=  accrualLineItem.jj_rb_Net_Rebate_Accrual_After_Adj__c;
                reportLineItem.jj_rb_Quantity__c += accrualLineItem.jj_rb_Volume__c;                
            } else {
                reportLineItem = new jj_rb_Rebate_Accrual_Report_Line_Item__c();
                reportLineItem.jj_rb_Rebate_Product__c = accrualLineItem.jj_rb_Product__c;
                reportLineItem.jj_rb_Net_Rebate__c = accrualLineItem.jj_rb_Net_Rebate_Accrual_After_Adj__c;
                reportLineItem.jj_rb_Quantity__c = accrualLineItem.jj_rb_Volume__c;                            
            }   
            mapReportLineItems.put(accrualLineItem.jj_rb_Product__c, reportLineItem);
        return mapReportLineItems;
    }                                                                                    
    
    global void finish(Database.BatchableContext BC){  
   
        String RetailerAccrualRecordType = jj_rb_Rebate_utils.getRecordTypeId('Accrual_Retailer');
        String HCPAccrualRecordType = jj_rb_Rebate_utils.getRecordTypeId('Accrual_Homecare');
        String RetialerReportType = jj_rb_Rebate_utils.getRecordTypeId('Accrual_Report_Retailer');
        String HCPReportType = jj_rb_Rebate_utils.getRecordTypeId('Accrual_Report_Homecare');
        
        Map<String, jj_rb_Rebate_Accrual_Report_Line_Item__c> mapLineItems;
        
        list <jj_rb_Rebate_Accrual_Report__c> listaccReport = new list<jj_rb_Rebate_Accrual_Report__c>();
         
       if(!mapAccrualMain.isEmpty())
       {
            // loop over main map and for each key create a report
            for(id accrualRecordType : mapAccrualMain.keySet()) 
            {
                mapLineItems = mapAccrualMain.get(accrualRecordType);
                
                // create a rebate accrual report record 
                jj_rb_Rebate_Accrual_Report__c accrualReport = new jj_rb_Rebate_Accrual_Report__c();
                accrualReport.jj_rb_Month__c = DateTime.now().format('MM');
                accrualReport.jj_rb_Year__c = DateTime.now().format('YYYY');
                id recID = accrualRecordType;
                id RetailerID = RetailerAccrualRecordType;
                accrualReport.RecordTypeId = (accrualRecordType == RetailerAccrualRecordType) ?  RetialerReportType :HCPReportType;
                
                insert accrualReport;
                
                // associate the rebate accrual report with the line items
                for(jj_rb_Rebate_Accrual_Report_Line_Item__c reportLineItem : mapLineItems.values())
                {
                    reportLineItem.jj_rb_Rebate_Accrual_Report__c = accrualReport.Id;
                }
                insert mapLineItems.values();
                
                // mark the rebate accrual report as completed
                accrualReport.jj_rb_Completed__c = true;
                update  accrualReport;  
            }                 
       }
    }
    
   
}