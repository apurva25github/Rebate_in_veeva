/*******************************************
* Controller class for New button override of 
* Claim Line Item object
*
********************************************/
public class jj_rb_NewClaimLineItemOverride extends jj_rb_NewOverrideBaseClass {
    public jj_rb_NewClaimLineItemOverride(Apexpages.StandardController stdController)
    {
        super(jj_rb_Rebate_Claim__c.SObjectType, jj_rb_Rebate_Claim_Line_Item__c.SObjectType);
    }
}