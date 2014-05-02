/**
 *    @author  MangaDivya Kasani
 *    @date  15/04/2014
     @description  This class is used to calculate Average Quantity for customer  
      
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     MangaDivya Kasani    15/04/2014      Original Version
 */
global class jj_rb_avgQuantityCalc implements Database.Batchable<sObject>
{
    
    String homecareclaim_recType=jj_rb_Rebate_utils.getRecordTypeID('Claim_Homecare');
    String status_approved = jj_rb_Rebate_utils.getRebateLineItemStatus('Approved');
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query='SELECT Id,Name,jj_rb_Claim_Date__c,jj_rb_Customer__c,(select id, name,jj_rb_Rebate_Product__r.name,jj_rb_Rebate_Product__c,jj_rb_Quantity__c from Rebate_Claim_Line_Items__r) FROM jj_rb_Rebate_Claim__c where jj_rb_Claim_Date__c = LAST_N_DAYS:1460 AND jj_rb_Status__c =:status_approved AND jj_rb_Claim_Date__c < today AND jj_rb_Customer__c!=null AND RecordTypeId=:homecareclaim_recType order by jj_rb_Claim_Date__c desc';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<jj_rb_Rebate_Claim__c> rbcList = (List<jj_rb_Rebate_Claim__c>)scope;  
        System.debug('rebate claims list'+rbcList);
        Set<ID> accIdSet = new Set<ID>();
        Map<ID,List<jj_rb_Rebate_Claim__c>> accRcMap = new Map<ID,List<jj_rb_Rebate_Claim__c>>();
        for(jj_rb_Rebate_Claim__c rc : rbcList){
            String accId = rc.jj_rb_Customer__c;
            if(accRcMap.containsKey(accId)){
                List<jj_rb_Rebate_Claim__c> claims = accRcMap.get(accId);
                if(claims!=null && claims.size()<=2)
                {
                    claims.add(rc);
                }
                accRcMap.put(accId,claims);
            }
            else
            {
                List<jj_rb_Rebate_Claim__c> listclaim= new List<jj_rb_Rebate_Claim__c>{rc};
                accRcMap.put(accId,listclaim);
            }           
        }
        System.debug('accRcMap'+accRcMap);
        List<jj_rb_Rebate_Claim__c> rcList = new List<jj_rb_Rebate_Claim__c>();
        Map<ID,Map<ID,avgcalculation>> m = new Map<ID,Map<ID,avgcalculation>>();
        for(ID accid : accRcMap.keySet()){
            for(jj_rb_Rebate_Claim__c rc:accRcMap.get(accid)){
                rcList.add(rc);
            }
            m.put(accid,calAvgQuantity(rcList));
        }
        System.debug('m@@@'+m);
        List<jj_rb_Tolerance__c> tolList = [select id,jj_rb_Customer__c, jj_rb_Product__c,jj_rb_Product__r.name,
                                                 jj_rb_Price_Tolerance__c, jj_rb_Quantity_Tolerance__c,
                                                 jj_rb_Average_Quantity__c from jj_rb_Tolerance__c 
                                                 where jj_rb_Customer__c=: accRcMap.keySet()];
        System.debug('tolList '+tolList);                                                 
        for(jj_rb_Tolerance__c tol : tolList){
            for(id accid : m.keyset()){
                if(tol.jj_rb_Customer__c == accid){
                    for(id productid : m.get(accid).keyset())
                    {
                        if(tol.jj_rb_Product__c == productid)
                        {
                            tol.jj_rb_Average_Quantity__c = m.get(accid).get(productid).getAvgQty();
                        }   
                    }
                                       
                }                         
            }
        }
        update tolList;   
        System.debug('@@@tolList'+tolList); 
    }
    global void finish(Database.BatchableContext BC){   
       
    }
    public Map<ID,avgcalculation> calAvgQuantity(List<jj_rb_Rebate_Claim__c> listClaims){
        // take the average of quantity 
        Map<id,avgcalculation> mapAvgQtyCal= new Map<id,avgcalculation>();// key:productid
               
        for(jj_rb_Rebate_Claim__c claim:listClaims)
        {
            List<jj_rb_Rebate_Claim_Line_Item__c> claimLineItems = claim.Rebate_Claim_Line_Items__r;
            Decimal quantity=0;
            for(jj_rb_Rebate_Claim_Line_Item__c claimLI : claimLineItems)
            {                
                String productid=claimLI.jj_rb_Rebate_Product__c; 
                // Calculate avgQty               
                if(mapAvgQtyCal.containsKey(productid))
                {
                    avgcalculation avgCal=mapAvgQtyCal.get(productid);
                    avgCal.itemCount += 1;
                    avgCal.quantity+=claimLI.jj_rb_Quantity__c;                
                    mapAvgQtyCal.put(productid,avgCal);
                }
                else
                {
                    avgcalculation avgCal= new avgcalculation();
                    avgCal.itemCount= 1;
                    avgCal.quantity+=claimLI.jj_rb_Quantity__c;                                   
                    mapAvgQtyCal.put(productid,avgCal);
                }
           }    
        }
        return mapAvgQtyCal;
    }
    class avgcalculation
    {
        String productid;
        Integer itemCount=0;
        Decimal quantity=0;
        public Decimal getAvgQty()
        {
           return quantity/itemCount;
        
        }
    }
}