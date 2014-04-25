global class jj_rb_Contract_notifications implements Database.Batchable<sObject>,Database.Stateful
{
    
    id retailerRecordTypeID = jj_rb_Rebate_Utils.getRecordTypeId('Contract_LineItem_Retailer');
    id homecareProviderRecordTypeID = jj_rb_Rebate_Utils.getRecordTypeId('Homecare_Contract_Line_Item');
    Date expiredateToday = Date.today();
    Date expiredate2Weeks = Date.today()+14;
    Date expiredate2Months = Date.today()+60;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {     
        
        String query = 'SELECT name,jj_rb_Rebate__c, jj_rb_Start_Date__c, jj_rb_Product__r.name, jj_rb_End_Date__c, jj_rb_Rebate_Contract__c, jj_rb_Rebate_Contract__r.Name, jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__r.Name, jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__r.Email,RecordTypeId,jj_rb_Region__c,jj_rb_Region__r.name,jj_rb_Rebate_Contract__r.jj_rb_Product__r.name  FROM jj_rb_Rebate_Contract_Line_Item__c where (jj_rb_End_Date__c =:expiredateToday OR jj_rb_End_Date__c =:expiredate2Weeks OR jj_rb_End_Date__c =:expiredate2Months) order by jj_rb_Rebate_Contract__c ';  
        return Database.getQueryLocator(query);
    }
    
    private String getUniqueKey(jj_rb_Rebate_Contract_Line_Item__c lineItem)
    {
        return lineItem.jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__c + '_' + lineItem.recordtypeId;
    }
    
    global void execute(Database.BatchableContext BC, List<jj_rb_Rebate_Contract_Line_Item__c> listContractLineItem)
    {   
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        Set<Id> setRecordTypeId = new Set<id>(); // set of recordtype id
        Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapExpiring2Months = new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>(); // key -> NCM user Id
        Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapExpiring2Weeks = new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>();
        Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapExpiringToday = new Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>>();
        
        Map<String, User> mapNCM = new Map<String, User>();                        
        List<jj_rb_Rebate_Contract_Line_Item__c> listLineItems;        
                
        for(jj_rb_Rebate_Contract_Line_Item__c lineItem  : listContractLineItem)
        {
            if(lineItem.jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__c != null)
            {
                setRecordTypeId.add(lineItem.recordtypeId);
                String ncmUser = lineItem.jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__c;            
              system.debug('ncmuser----' + ncmUser);
              
                mapNCM.put(lineItem.jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__c, lineItem.jj_rb_Rebate_Contract__r.jj_rb_National_Channel_Manager__r);               
                if(lineItem.jj_rb_End_Date__c == expiredate2Months)
                {                   
                        
                        listLineItems = getMapList(mapExpiring2Months, ncmUser); 
                        listLineItems.add(lineItem);
                        mapExpiring2Months.put(getUniqueKey(lineItem), listLineItems);
                }
                    
                if(lineItem.jj_rb_End_Date__c == expiredate2Weeks)
                {                       
                        listLineItems = getMapList(mapExpiring2Weeks, ncmUser); 
                        listLineItems.add(lineItem);
                        mapExpiring2Weeks.put(getUniqueKey(lineItem), listLineItems);
                }
                
                if(lineItem.jj_rb_End_Date__c == expiredateToday)
                {                        
                        listLineItems = getMapList(mapExpiringToday, ncmUser); 
                        listLineItems.add(lineItem);
                        mapExpiringToday.put(getUniqueKey(lineItem), listLineItems);
                }
                
              }             
          }          
         
         system.debug('mapncm>>>>' + mapncm);
         system.debug('RecordTypeIDS ***** '+ setRecordTypeId);
        for(Id recordTypeId : setRecordTypeId)
        {
            //loop over the set of NCMs and send email 
            for(String ncmId : mapNCM.keySet())
            {      
               String uniqueKey = ncmId + '_' + recordTypeId;
               system.debug('uniqueKey> >>' + uniqueKey);
               system.debug('mapNCM>>>' + mapNCM);
               User ncmUser = mapNCM.get(ncmId);
               
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               mail.setToAddresses(new List<String>{ncmUser.Email});
               mail.setSubject('Contract Expiration Notification');
               
               String messageBody = '<html><body>Hello ' + ncmUser.Name  + ',';
               String lineItemTable;
               
                // get the line items expiring today
               List<jj_rb_Rebate_Contract_Line_Item__c> listExpiringToday = mapExpiringToday.get(uniqueKey);
               if(listExpiringToday != null && !listExpiringToday.isEmpty()) {                
                    lineItemTable =  getLineItemTable(listExpiringToday, recordTypeId);           
                    messageBody += '<br><br>The following line items are going to expire today - <br/>' + lineItemTable;
               }
               
               // get the line items expiring in 2 weeks
               List<jj_rb_Rebate_Contract_Line_Item__c> listExpiring2Weeks = mapExpiring2Weeks.get(ncmId);
               if(listExpiring2Weeks != null && !listExpiring2Weeks.isEmpty()) {                     
                    lineItemTable =  getLineItemTable(listExpiring2Weeks, recordTypeId);          
                    messageBody += '<br><br>The following line items are going to expire in 2 weeks - <br/>' + lineItemTable;
               }
               
               // get the line items expiring in 2 months
               List<jj_rb_Rebate_Contract_Line_Item__c> listExpiring2Months = mapExpiring2Months.get(ncmId);
               if(listExpiring2Months != null && !listExpiring2Months.isEmpty()) {                  
                    lineItemTable =  getLineItemTable(listExpiring2Months, recordTypeId);           
                    messageBody += '<br><br>The following line items are going to expire in 2 months - <br/>' + lineItemTable;
               }                 
               
               
               messageBody += '<br/><br/>Regards,<br/>Rebate Management System </body></html>';
               mail.setHtmlBody(messageBody);
               
               if(listExpiring2Months != null || listExpiring2Weeks != null || listExpiringToday != null) {
                    mailList.add(mail); 
               }           
            }   
        }         
        
        
        system.debug('mailList>>>' + mailList);
        Messaging.sendEmail(mailList);             
   }
   
   public String getLineItemTable(List<jj_rb_Rebate_Contract_Line_Item__c> lineItems, String recordTypeId)
   {
   		System.debug('OUT*******'+recordTypeId +' == '+retailerRecordTypeID);
      if(recordTypeId == retailerRecordTypeID)
      {
      	System.debug('IN*******'+recordTypeId +' == '+retailerRecordTypeID);
         return createTable(lineItems);
      }
      else if(recordTypeId == homecareProviderRecordTypeID){
        return createHCPTable(lineItems);
      }
      return null;
   }
    
   private List<jj_rb_Rebate_Contract_Line_Item__c> getMapList(Map<String, List<jj_rb_Rebate_Contract_Line_Item__c>> mapCLI, String ncmUser)
   {
      List<jj_rb_Rebate_Contract_Line_Item__c> listLineItems;
      if(mapCLI.containsKey(ncmUser))
      {
          listLineItems = mapCLI.get(ncmUser);
      } else {
          listLineItems = new List<jj_rb_Rebate_Contract_Line_Item__c>(); 
      }
       return listLineItems;
   }
   
 
   // Table for HCP email template
   private String createHCPTable(List<jj_rb_Rebate_Contract_Line_Item__c> lineItems)
   {
      String body = '';
      body += '<table border="1"><tr><td><b>Contract</b></td><td><b>Line Item No</b></td><td><b>Product</b></td><td><b>Region</b></td><td><b> Rebate Value </b></td> <td><b> Start Date  </b></td> <td><b> End Date </b></td></tr>';
      for(jj_rb_Rebate_Contract_Line_Item__c li : lineItems)
      {
        body += '<tr><td><a href= "'+URL.getSalesforceBaseUrl().toExternalForm() +
                            '/'+li.jj_rb_Rebate_Contract__r.id +'">'+ li.jj_rb_Rebate_Contract__r.Name + '</a> </td><td>' + li.name + '</td><td>'+  li.jj_rb_Rebate_Contract__r.jj_rb_Product__r.name + '</td><td>'+ li.jj_rb_Region__r.name + '</td><td>' + li.jj_rb_Rebate__c + '</td><td>' + formatDate(li.jj_rb_Start_Date__c,'dd/MM/yyyy') + '</td><td>' + formatDate(li.jj_rb_End_Date__c,'dd/MM/yyyy') + '</td></tr>';
      }
      body += '</table>'; 
      return body;       
   }
   // Table for Retailer email template
   private String createTable(List<jj_rb_Rebate_Contract_Line_Item__c> lineItems)
   {
      String body = '';
      body += '<table border="1"><tr><td><b>Contract</b></td><td><b>Line Item No</b></td><td><b>Product</b></td><td><b> Rebate Value </b></td> <td><b> Start Date  </b></td> <td><b> End Date </b></td></tr>';
      for(jj_rb_Rebate_Contract_Line_Item__c li : lineItems)
      {
        body += '<tr><td><a href= "'+URL.getSalesforceBaseUrl().toExternalForm() +
   '/'+li.jj_rb_Rebate_Contract__r.id +'">'+ li.jj_rb_Rebate_Contract__r.Name + '</a> </td><td>' + li.name + '</td><td>' + li.jj_rb_Product__r.name + '</td><td>' + li.jj_rb_Rebate__c + '</td><td>' + formatDate(li.jj_rb_Start_Date__c,'dd/MM/yyyy') + '</td><td>' + formatDate(li.jj_rb_End_Date__c,'dd/MM/yyyy') + '</td></tr>';
      }
      body += '</table>'; 
      return body;       
   }
   
   private String formatDate(Date dateValue, String format)
   {
        DateTime dt = DateTime.newInstance(dateValue.year(), dateValue.month(), dateValue.day());
        return dt.format(format);
   }
   
   global void finish(Database.BatchableContext BC)  
   {
                    
   }
}