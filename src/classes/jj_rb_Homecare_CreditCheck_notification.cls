global class jj_rb_Homecare_CreditCheck_notification implements Database.Batchable<sObject>,Database.Stateful
    {
        Date exriringToday = Date.Today();
        Date expiring2Months = Date.Today()+60;
        Date expiring2Wks = Date.Today()+14;
        Id recid= jj_rb_rebate_utils.getRecordTypeId('Account_Homecare');
        global Database.QueryLocator start(Database.BatchableContext BC)
        {
            //Fetch all HCP customers  which are expiring today/2 months/2 wks
            String query = 'select jj_rb_Credit_check_Validity_End__c,jj_rb_Credit_check_Validity_From__c,name,jj_rb_National_Channel_Manager__r.name,jj_rb_National_Channel_Manager__r.email from account where (jj_rb_Credit_check_Validity_End__c =: exriringToday OR jj_rb_Credit_check_Validity_End__c =: expiring2Months OR jj_rb_Credit_check_Validity_End__c =: expiring2Wks) And RecordTypeID =: recid';
            return Database.getQueryLocator(query);
        }
        
        global void execute(Database.BatchableContext BC,List<Account> listHCPcustomer)
        {
            //map<String, list<Account>> mapexpToday = new map<String, list<Account>>();
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            map<id,list<Account>> mapexpToday = new map<id,list<Account>>();//NCM ID
            map<id,list<Account>> mapexp2wks = new map<id,list<Account>>();//NCM ID
            map<id,list<Account>> mapexp2mnths = new map<id,list<Account>>();//NCM ID
            List<Account> listacc = new List<Account>();
            map<id,User> mapNCM = new map<id,User>();
            //get all HCP customers
            for(Account acc : listHCPcustomer)
            {   
                id ncmID = acc.jj_rb_National_Channel_Manager__c;
                //list of NCM
                if(acc.jj_rb_National_Channel_Manager__c != null )
                {
                    mapNCM.put(acc.jj_rb_National_Channel_Manager__c,acc.jj_rb_National_Channel_Manager__r);
                        //Seperate today,2months, 2wks
                    if(acc.jj_rb_Credit_check_Validity_End__c ==  exriringToday)
                    {
                        listacc = getMapList(mapexpToday,ncmID);
                        listacc.add(acc);
                        mapexpToday.put(acc.jj_rb_National_Channel_Manager__c ,listacc);
                        
                    }
                    if(acc.jj_rb_Credit_check_Validity_End__c ==  expiring2Months)
                    {
                        listacc = getMapList(mapexp2mnths,ncmID);
                        listacc.add(acc);
                        mapexp2mnths.put(acc.jj_rb_National_Channel_Manager__c ,listacc);
                        
                    }
                    if(acc.jj_rb_Credit_check_Validity_End__c ==  expiring2Wks)
                    {
                        listacc = getMapList(mapexp2wks,ncmID);
                        listacc.add(acc);
                        mapexp2wks.put(acc.jj_rb_National_Channel_Manager__c ,listacc);
                        
                    }
                    
                }
            }
            
            
            //mail to NCM
            for(id NCM : mapNCM.keyset() )
            {
                User NCMuser = mapNCM.get(NCM);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{NCMuser.Email});
                mail.setSubject('Homecare Provider expiration notification');
                String messageBody = '<html><body>Hello, ';
                String acctable;
                //expiring today
                if(mapexpToday.get(NCM) != null)
                {
                    list<Account> listexptoday = mapexpToday.get(NCM);
                    acctable = createTable(listexpToday);
                    System.debug('************* '+acctable);
                    messageBody += '<br><br>The following Homecare provider customer(s) are going to expire Today - <br/>' + acctable;

                }
                //expiring in 2 wks
                
                
                if(mapexp2wks.get(NCM) != null)
                {
                    list<Account> listexp2wks = mapexp2wks.get(NCM);
                    acctable = createTable(listexp2wks);
                    System.debug('************* '+acctable);
                    messageBody += '<br><br>The following Homecare provider customer(s) are going to expire in 2 weeks - <br/>' + acctable;
                }
                //expiring in 2 months
                
                if(mapexp2mnths.get(NCM) != null )
                {
                    list<Account> listexp2mnth = mapexp2mnths.get(NCM);
                    acctable = createTable(listexp2mnth);
                    System.debug('************* '+acctable);
                    messageBody += '<br><br>The following Homecare provider customer(s) are going to expire in 2 Months - <br/>' + acctable;
                }
                messageBody += '<br/><br/>Regards,<br/>Rebate Management System </body></html>';
               mail.setHtmlBody(messageBody);
               mailList.add(mail); 
               Messaging.sendEmail(mailList);
            }
        }
        
        private List<Account> getMapList(Map<id, List<Account>> mapAcc, id ncmUser)
        {
            List<Account> listacc;
            if(mapAcc.containsKey(ncmUser))
            {
                listacc = mapAcc.get(ncmUser);
            } 
            else 
            {
                listacc = new List<Account>(); 
            }
            return listacc;
        }
        
        private String createTable(List<Account> listaccount)
        {
            String body = '';
            body += '<table border="1"><tr><td><b>Name</b></td><td><b>Credit validity from</b></td><td><b> Credit validity end </b></td></tr>';
            for(Account acc : listaccount)
            {
                //Date formatting
                Datetime fromdate= acc.jj_rb_Credit_check_Validity_From__c;
                String mtdt = fromdate.format('dd-MM-yyyy');
                Datetime enddate= acc.jj_rb_Credit_check_Validity_end__c;
                String mydt = enddate.format('dd-MM-yyyy');
                body += '<tr><td><a href= "'+URL.getSalesforceBaseUrl().toExternalForm() +  '/'+acc.id +'">'+ acc.Name + '</a> </td><td>' + mtdt + '</td><td>' + mydt + '</td>';
            }
             body += '</table>'; 
      return body;       
        }
        global void finish(Database.BatchableContext BC)  
       {
                        
       }
    }