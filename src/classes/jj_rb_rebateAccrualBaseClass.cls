/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  1/04/2014
     @description  Base class for rebate accrual process
 
     Function: Base class for rebate accrual process
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    1/04/2014      Original Version
 */
global abstract class jj_rb_rebateAccrualBaseClass
{
    // handles the accrual calculation for the new customer scenario
    protected void processAccrualForNewCustomer(Account customer, 
                                                    Map<Id, List<jj_rb_Estimated_Rebate_Accrual__c>> mapEstimatedAccruals,
                                                    Map<Id, jj_rb_Rebate_Accrual__c> mapRebateAccrual,
                                                    Map<Id, List<jj_rb_Rebate_Accrual_Line_Item__c>> mapRebateAccrualLI,id Recodtyp)
 {
    // for a new customer with no rebate claim, 
    // create a accrual record with the estimated accrual value
    // from the customer record.
    // get all the estimated accrual values for the customer
    List<jj_rb_Estimated_Rebate_Accrual__c> listEstimatedAccrual = mapEstimatedAccruals.get(customer.Id);
    
    if(listEstimatedAccrual != null && !listEstimatedAccrual.isEmpty()) 
    {
        // create the rebate accrual record first
        List<jj_rb_Rebate_Accrual_Line_Item__c> listRebateAccrualLI = new List<jj_rb_Rebate_Accrual_Line_Item__c>();
        jj_rb_Rebate_Accrual__c rebateAccrual = new jj_rb_Rebate_Accrual__c();
        rebateAccrual.RecordTypeID = Recodtyp;
        rebateAccrual.jj_rb_Customer__c = customer.Id;
        rebateAccrual.jj_rb_Month__c = Datetime.now().format('MM');
        rebateAccrual.jj_rb_Year__c = Datetime.now().format('YYYY');
        rebateAccrual.jj_rb_Customer_NCM__c = customer.jj_rb_National_Channel_Manager__c;
        mapRebateAccrual.put(customer.Id, rebateAccrual);
        
        for(jj_rb_Estimated_Rebate_Accrual__c estimatedAccrual : listEstimatedAccrual)
        {
            jj_rb_Rebate_Accrual_Line_Item__c rebateAccrualLI = new jj_rb_Rebate_Accrual_Line_Item__c();
            rebateAccrualLI.jj_rb_Rebate_Accrual__c = rebateAccrual.Id;     
            rebateAccrualLI.jj_rb_Product__c = estimatedAccrual.jj_rb_Rebate_Product__c;
            rebateAccrualLI.jj_rb_Net_Rebate_Accrual_Amount__c = estimatedAccrual.jj_rb_Estimated_Accrual__c;
            rebateAccrualLI.jj_rb_Volume__c = 0;
            
            system.debug('rebateAccrualLI >>>>>>' + rebateAccrualLI);
            listRebateAccrualLI.add(rebateAccrualLI);   
        }
        mapRebateAccrualLI.put(customer.Id, listRebateAccrualLI);
    }   
 }  
 
 global void calcAccrualForExistingCustomer(Account customer, List<jj_rb_Rebate_Claim__c> listClaims, 
                                                    Map<Id, jj_rb_Rebate_Accrual__c> mapRebateAccrual,
                                                    Map<Id, List<jj_rb_Rebate_Accrual_Line_Item__c>> mapRebateAccrualLI, id Recodtyp)
 {
    // take the average of quantity and net rebate
    Map<Id, accrualCalc> mapAccrualCal = new map<Id, accrualCalc>();
    
    // find the minimum difference in the claim period and accrual execution month
    Integer monthDiff = 99;
    for(jj_rb_Rebate_Claim__c claim : listClaims)
    {       
        Integer monthInBetween = claim.jj_rb_Claim_Date__c.monthsBetween(Date.today());
        system.debug('claim date >>>>>' + claim.jj_rb_Claim_Date__c + ' monthInBetween>>>' + monthInBetween);
        if (monthInBetween < monthDiff)
        {
            // reducing one month so that rollup does not happen for the current month.
            monthDiff = monthInBetween;
        }       
    }
    
    if(monthDiff == 99)
        monthDiff = 1; 
        
    system.debug('monthDiff>>>' + monthDiff);   
    
    // calculate 
    for(jj_rb_Rebate_Claim__c claim : listClaims)
    {
        List<jj_rb_Rebate_Claim_Line_Item__c> claimLineItems = claim.Rebate_Claim_Line_Items__r;
        Decimal qty = 0;
        Decimal netRebate = 0;
        for(jj_rb_Rebate_Claim_Line_Item__c claimLI : claimLineItems)
        {
            String productId = claimLI.jj_rb_Rebate_Product__c;
            
            // Calculate qty
            if(mapAccrualCal.containsKey(productId))
            {
                accrualCalc calc = mapAccrualCal.get(productId);
                calc.itemCount += 1;
                calc.Qty += claimLI.jj_rb_Quantity__c;
                calc.netRebate += claimLI.jj_rb_Net_Rebate__c;
                mapAccrualCal.put(productId, calc);                         
            } else {
                accrualCalc calc = new accrualCalc();
                calc.itemCount = 1;
                calc.Qty = claimLI.jj_rb_Quantity__c;
                calc.netRebate = claimLI.jj_rb_Net_Rebate__c;
                mapAccrualCal.put(productId, calc);         
            }           
        }
    }
    
    system.debug('mapAccrualCal>>>>' + mapAccrualCal);
    
    // create rebate Accrual record
    
    jj_rb_Rebate_Accrual__c rebateAccrual = new jj_rb_Rebate_Accrual__c(); 
    rebateAccrual.jj_rb_Customer__c = customer.Id;
    rebateAccrual.RecordTypeId = Recodtyp; 
    rebateAccrual.jj_rb_Month__c = Datetime.now().format('MM');
    rebateAccrual.jj_rb_Year__c = Datetime.now().format('YYYY');
    rebateAccrual.jj_rb_Customer_NCM__c = customer.jj_rb_National_Channel_Manager__c;
    mapRebateAccrual.put(customer.Id, rebateAccrual);
    
    // Create rebate accrual line item records
    List<jj_rb_Rebate_Accrual_Line_Item__c> accrualLineItems = new List<jj_rb_Rebate_Accrual_Line_Item__c>();
    for(String productId : mapAccrualCal.KeySet())
    {
        accrualCalc calc = mapAccrualCal.get(productId);
        
        jj_rb_Rebate_Accrual_Line_Item__c rebateAccrualLI = new jj_rb_Rebate_Accrual_Line_Item__c();
        rebateAccrualLI.jj_rb_Volume__c = Math.round(calc.getAvgQty()) * monthDiff;
        rebateAccrualLI.jj_rb_Net_Rebate_Accrual_Amount__c = calc.getAvgNetRebate() * monthDiff;  
        rebateAccrualLI.jj_rb_Product__c = productId;
        accrualLineItems.add(rebateAccrualLI); 
    }
    mapRebateAccrualLI.put(customer.Id, accrualLineItems);
                                                        
 }
 protected void createAccruals(Map<Id, jj_rb_Rebate_Accrual__c> mapRebateAccrual,
                                                    Map<Id, List<jj_rb_Rebate_Accrual_Line_Item__c>> mapRebateAccrualLI)
 {
     list<jj_rb_Rebate_Accrual__c> listupdateAcc = new list<jj_rb_Rebate_Accrual__c>();
     List<jj_rb_Rebate_Accrual_Line_Item__c> listRebateAccrualLI = new List<jj_rb_Rebate_Accrual_Line_Item__c>();
     system.debug('mapRebateAccrual>>>>' + mapRebateAccrual); 
     system.debug('mapRebateAccrualLI>>>>' + mapRebateAccrualLI);  
     if(!mapRebateAccrual.values().isEmpty())
     {
         /*
         for(jj_rb_Rebate_Accrual__c RebateAcc : mapRebateAccrual.values())
         { 
             RebateAcc.RecordTypeId = Recodtyp;
             listupdateAcc .add(RebateAcc);
         }
         */
        insert mapRebateAccrual.values();       
     } 
     if(!mapRebateAccrualLI.keySet().isEmpty()) 
     {
        for(String custId : mapRebateAccrualLI.keySet()) 
         { 
              jj_rb_Rebate_Accrual__c rebateAccrual = mapRebateAccrual.get(custId);
              if(rebateAccrual!=null)
              {
                List<jj_rb_Rebate_Accrual_Line_Item__c> listRALI = mapRebateAccrualLI.get(custId);
                if(listRALI != null && !listRALI.isEmpty())
                {
                    for(jj_rb_Rebate_Accrual_Line_Item__c rali : listRALI)
                    {
                        rali.jj_rb_Rebate_Accrual__c = rebateAccrual.id;
                        listRebateAccrualLI.add(rali);
                    }
                    
                }
              }   
         }
        insert  listRebateAccrualLI;
     }
     
     // create the approval process for Rebate accrual
     for(jj_rb_Rebate_Accrual__c rebateaccrual : mapRebateAccrual.values())
     {
       Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
       system.debug('approval rebate accrual>>>' + rebateaccrual);
       req1.setObjectId(rebateaccrual.id);  
       Approval.ProcessResult result = Approval.process(req1);
      }
 }                                                   
 class accrualCalc {
  String productId;
  Integer itemCount;
  Decimal Qty;
  Decimal netRebate;
  
  public Decimal getAvgQty()
  {
    return Qty/itemCount;
  }
  public Decimal getAvgNetRebate()
  {
    return netRebate/itemCount;
  }
} 
}