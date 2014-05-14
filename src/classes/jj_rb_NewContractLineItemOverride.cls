/*******************************************
* Controller class for New button override of 
* Contract Line Item object
*
********************************************/
public class jj_rb_NewContractLineItemOverride extends jj_rb_NewOverrideBaseClass {
	public jj_rb_NewContractLineItemOverride(Apexpages.StandardController stdController)
	{
		super(jj_rb_Rebate_Contract__c.SObjectType, jj_rb_Rebate_Contract_Line_Item__c.SObjectType);
		
	}
}