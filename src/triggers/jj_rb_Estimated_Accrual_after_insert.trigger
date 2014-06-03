/**********************************************************************
 Name:  jj_rb_Estimated_Accrual_after_insert
 Capgemini India Ltd 

 Purpose:
    count Estmated rebate accrual records
 History:
 VERSION  AUTHOR            DATE              DETAIL                                 
 1.0      Apurva Prasade    03/04/2014        Created trigger

***********************************************************************/ 
trigger jj_rb_Estimated_Accrual_after_insert on jj_rb_Estimated_Rebate_Accrual__c (after insert,after update,before insert,before update) 
{

        Integer Count = 0;
        String MDR;
        Map <String,integer> RecCount = new Map <String,integer>();
        List <jj_rb_Master_data_request__c> updateMDR = new List <jj_rb_Master_data_request__c>();
        if(trigger.isAfter)
        {
          System.debug('****** in trigger after ***********');  
        for(AggregateResult ERA : [select jj_rb_Master_data_request__c,COUNT(id) noOfREc 
                               from jj_rb_Estimated_Rebate_Accrual__c
                               group by jj_rb_Master_data_request__c having jj_rb_Master_data_request__c != null])
        {
            Count =Integer.valueOf(ERA.get('noOfREc'));
            MDR = String.valueOf(ERA.get('jj_rb_Master_data_request__c'));
            RecCount.put(MDR,Count);
        }   
        
        List <jj_rb_Master_data_request__c> listMDR = [select id,name,jj_rb_Total_Estimat_Rebate_Accrual__c 
                                                   from jj_rb_Master_data_request__c 
                                                   where id in: RecCount.keySet()];
        System.debug('*******List MDR*********'+ listMDR);
    
        for(String keys : RecCount.keySet())
        {
            for(jj_rb_Master_data_request__c request : listMDR)
            {
                    if(request.id == keys)
                    {
                        request.jj_rb_Total_Estimat_Rebate_Accrual__c = RecCount.get(keys);
                        updateMDR.add(request);
                    }   
            }
        }
            update updateMDR; 
        }
        if(trigger.isBefore)
        {
           list <jj_rb_Estimated_Rebate_Accrual__c> newERA = trigger.new;
           
           set <id> setmdrID = new set<id>();
           
           map <string,jj_rb_Estimated_Rebate_Accrual__c> mapERA = new map <string,jj_rb_Estimated_Rebate_Accrual__c>();
           list<jj_rb_Master_Data_Request__c> listMDR = new list<jj_rb_Master_Data_Request__c>();
           set<id> setProductId = new set<id>();
           set <id> setaccountId = new set<id>();
                      
           Map<Id, Id> mapMDRAccounts = new Map<Id, Id>();	// key -> mdr id, value -> account id
           Set<Id> setCriteria = new Set<Id>();
         
           for(jj_rb_Estimated_Rebate_Accrual__c ERA : newERA)
           {
           		//chk New ERAs for Account
           		if(ERA.jj_rb_Account__c == null)
           		{
           			setmdrID.add(ERA.jj_rb_Master_data_request__c);           			
           		}
           		
           }
           
           //retrive ERAs MDR and its Account           
           for(jj_rb_Master_Data_Request__c mdrset : [select id,name,jj_rb_Rebate_Request_Change_For_ID__c 
           												from jj_rb_Master_Data_Request__c 
           												where id IN : setmdrID])
			{
				System.debug('In FOR MDR ***** '+mdrset);
				mapMDRAccounts.put(mdrset.Id, mdrset.jj_rb_Rebate_Request_Change_For_ID__c);				
			}           												
           
           
           // check for record CSV batch
           for(jj_rb_Estimated_Rebate_Accrual__c ERA : newERA)
           {
           		Id accountId;
           		
           		if(ERA.jj_rb_Account__c != null)
           			accountId = era.jj_rb_Account__c;
           		else
           		   	accountId = mapMDRAccounts.get(era.jj_rb_Master_data_request__c);
           		
           		// get the unique key
           		String uniqueKey = accountId + '-' + ERA.jj_rb_Rebate_Product__c;
           		System.debug('***** Unique key '+uniqueKey);
           		setCriteria.add(accountId);
           		setCriteria.add(ERA.jj_rb_Rebate_Product__c);   	
           		           		
           		if(!mapERA.containsKey(uniqueKey))
	            {
	               mapERA.put(uniqueKey,ERA);
	               //setProductId.add(ERA.jj_rb_Rebate_Product__c);
	            }
	            else
	            {
	               ERA.adderror('ERA value already present for this product');
	            }
           }
           
           system.debug('mapMDRAccounts>>>' + mapMDRAccounts);
           system.debug('mapERA>>>>' + mapERA);
           //System.debug('setCriteria >>>>> '+setCriteria);
           
           Map<String, jj_rb_Estimated_Rebate_Accrual__c> mapOldERA = new Map<String, jj_rb_Estimated_Rebate_Accrual__c>();
           for(jj_rb_Estimated_Rebate_Accrual__c oldera : [select name,jj_rb_Master_data_request__c,jj_rb_account__c,jj_rb_Estimated_Accrual__c,
           														jj_rb_rebate_product__c,jj_rb_Rebate_Product__r.name
           												  from jj_rb_Estimated_Rebate_Accrual__c
           												  where jj_rb_account__c In : setCriteria and jj_rb_rebate_product__c in : setCriteria])
           {
           		String uniqueKey = oldera.jj_rb_Account__c + '-' + oldera.jj_rb_Rebate_Product__c;
           		mapOldERA.put(uniqueKey,oldera);
           		System.debug('In new For **** Old Record with same acc and product ** '+oldera);
           		/*if(oldera != null)
           		{
           			
           		}*/
           }											  
           
           for(jj_rb_Estimated_Rebate_Accrual__c  oldERA :  [select name ,jj_rb_Master_data_request__c,
           															  jj_rb_Master_data_request__r.jj_rb_Rebate_Request_Change_For_ID__c,
           															  jj_rb_account__c,jj_rb_Estimated_Accrual__c,
           															  jj_rb_rebate_product__c,jj_rb_Rebate_Product__r.name
                       											from  jj_rb_Estimated_Rebate_Accrual__c 
                       											where (jj_rb_Rebate_Product__c in :setCriteria
                       											and jj_rb_Master_data_request__r.jj_rb_Rebate_Request_Change_For_ID__c in :setCriteria)]) {
                    String uniqueKey = oldERA.jj_rb_Master_data_request__r.jj_rb_Rebate_Request_Change_For_ID__c 
                     					+'-' + oldERA.jj_rb_rebate_product__c;
                    mapOldERA.put(uniqueKey, oldERA);        												
           }
           
           system.debug('mapOldERA>>>>' + mapOldERA);
                       				 							
           //Chk existing ERA records.
           for(String uniqueKey : mapERA.keySet())
           {
           	 jj_rb_Estimated_Rebate_Accrual__c eraNew = mapERA.get(uniqueKey);
           	 if(mapOldERA.containsKey(uniqueKey))
           	 {
           	 	jj_rb_Estimated_Rebate_Accrual__c eraOld = mapOldERA.get(uniqueKey);
           	 	if(eraOld.id != eraNew.id)
           	 	{
           	 		eraNew.addError('Rebate Product - '+ eraOld.jj_rb_Rebate_Product__r.name +' is already present for ' + eraOld.name);
           	 	}
           	 }
           }            
                       
                       
           /*for(String ERAuniquekey : mapERA.keyset())
           { 
               jj_rb_Estimated_Rebate_Accrual__c ERAnew = mapERA.get(ERAuniquekey);
               for(jj_rb_Estimated_Rebate_Accrual__c ERA :  listERA )
               {
                   if(ERAnew.id != ERA.id && mapMDRAccounts.get(ERAnew.jj_rb_Master_data_request__c) == ERA.jj_rb_Master_data_request__r.jj_rb_Rebate_Request_Change_For_ID__c)
                   {
                       if(ERAnew.jj_rb_rebate_product__c == ERA.jj_rb_rebate_product__c)
                       {
                           ERAnew.addError('Rebate Product - '+ ERA.jj_rb_Rebate_Product__r.name +' is already present for '+ERA.name);
                       }
                       
                   }
               }
           }*/
           
        }
}