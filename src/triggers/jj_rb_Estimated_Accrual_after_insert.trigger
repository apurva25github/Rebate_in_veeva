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
           list <jj_rb_Estimated_Rebate_Accrual__c> listERA = new list <jj_rb_Estimated_Rebate_Accrual__c>();
           list <id> listmdrID = new list<id>();
           map <id,jj_rb_Estimated_Rebate_Accrual__c> mapERA = new map <id,jj_rb_Estimated_Rebate_Accrual__c>();
           for(jj_rb_Estimated_Rebate_Accrual__c ERA : newERA)
           {
               if(!mapERA.containsKey(ERA.jj_rb_rebate_product__c))
               {
                   //system.debug('*************');
                   mapERA.put(ERA.jj_rb_rebate_product__c,ERA);
                   listmdrID .add(ERA.jj_rb_Master_data_request__c);
               }
               else
               {
                   ERA.adderror('Rebate Product '+ERA.jj_rb_rebate_product__r.name+' is already present for '+ERA.name);
               }
               
           }
           listERA = [select name ,jj_rb_Master_data_request__c,jj_rb_account__c,jj_rb_Estimated_Accrual__c,jj_rb_rebate_product__c 
                       from  jj_rb_Estimated_Rebate_Accrual__c
                       where jj_rb_Master_data_request__c in:listmdrID];
           for(id ProductID : mapERA.keySet())
           {    
               jj_rb_Estimated_Rebate_Accrual__c EstmtdAccrl = mapERA.get(ProductID);
               for(jj_rb_Estimated_Rebate_Accrual__c ERA :  listERA )
               {
                   if(EstmtdAccrl.id != ERA.id && EstmtdAccrl.jj_rb_Master_data_request__c == ERA.jj_rb_Master_data_request__c )
                   {
                       if(EstmtdAccrl.jj_rb_rebate_product__c == ERA.jj_rb_rebate_product__c)
                       {
                           EstmtdAccrl.addError('Rebate Product is already present for '+ERA.name);
                       }
                       
                   }
               }
           }
           
        }
}