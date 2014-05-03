@isTest
public class jj_rb_Test_Contract 
{
    static jj_rb_Rebate_Product__c newproduct = jj_rb_Test_MDR_class.rebateProductCreator();
    //Retailer contract creator
    public static jj_rb_Rebate_Contract__c retailerContractCreator()
    {
        jj_rb_Rebate_Contract__c RContract= new jj_rb_Rebate_Contract__c();                   
        RContract.jj_rb_Customer__c= jj_rb_Test_MDR_class.accountCreator().id ;
        RContract.jj_rb_Description__c='Retailer Contract';
        RContract.jj_rb_Status__c= jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');
         RContract.jj_rb_National_Channel_Manager__c =  jj_rb_Test_MDR_class.getRebateUser().id; 
        Rcontract.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Rebate_Contract_Retailer',jj_rb_Test_MDR_class.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract__c'));
        //Rcontract.RecordTypeId = '012110000004Smv';
        insert RContract;
        return RContract;
    }
    //Retialer contract Line Item Creator  
    public static jj_rb_Rebate_Contract_Line_Item__c retailerContractLineItemCreator(id contractId)
    {
        jj_rb_Rebate_Contract_Line_Item__c Rebatecontractlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        Rebatecontractlineitem.jj_rb_Rebate_Contract__c=contractId;
        Rebatecontractlineitem.jj_rb_Product__c = newproduct.id;
        Rebatecontractlineitem.jj_rb_Start_Date__c=Date.today();
        Rebatecontractlineitem.jj_rb_End_Date__c=Date.Today()+60;
        Rebatecontractlineitem.jj_rb_Rebate__c=50;
        Rebatecontractlineitem.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');  
        Rebatecontractlineitem.jj_rb_Is_Modified__c= true;  
        Rebatecontractlineitem.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Contract_LineItem_Retailer',jj_rb_Test_MDR_class.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract_Line_Item__c'));
        insert Rebatecontractlineitem;
        return Rebatecontractlineitem;
    }
    
    //Homecare contract creator
    public static jj_rb_Rebate_Contract__c HCPContractCreator()    
    {        
        jj_rb_Rebate_Contract__c HCPContract= new jj_rb_Rebate_Contract__c();                           
        HCPContract.jj_rb_Product__c = newproduct.id;         
        HCPContract.jj_rb_Description__c = 'Homecare contract';        
        HCPContract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');        
        HCPContract.jj_rb_National_Channel_Manager__c = jj_rb_Test_MDR_class.getRebateUser().id;             
        HCPContract.RecordTypeId =  jj_rb_Test_MDR_class.ReocrdTypeCreator('Homecare_Contract',jj_rb_Test_MDR_class.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract__c'));     
        //HCPContract.RecordTypeId = '012110000004Smt';
        insert HCPContract;
        return HCPContract;    
    }
    
    //Homecare contract Line item creator
    public static jj_rb_Rebate_Contract_Line_Item__c HCPcontractlntitmcreator(id contractid)
    {
        jj_rb_Rebate_Contract_Line_Item__c HCPlineitem = new jj_rb_Rebate_Contract_Line_Item__c();
        HCPlineitem.jj_rb_Rebate_Contract__c = contractid;
        HCPlineitem.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('New', 'New');   
        HCPlineitem.jj_rb_Description__c = 'Homecare contract line item';
		HCPlineitem.jj_rb_Start_Date__c = Date.Today() + 60;
        HCPlineitem.jj_rb_End_Date__c = Date.Today() + 160;
        HCPlineitem.RecordTypeId = jj_rb_Test_MDR_class.ReocrdTypeCreator('Homecare_Contract_Line_Item',jj_rb_Test_MDR_class.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract_Line_Item__c'));  
    	//HCPlineitem.RecordTypeId = '012110000004Smo';
        insert HCPlineitem;
        //System.debug('Inserted HCP line item ********* '+HCPlineitem);
        return HCPlineitem;
    }
    
    //Close contract functionality - 94%
    public static testmethod void Test_close_contract_CTE()
    {
                jj_rb_Test_MDR_class.ReocrdTypeCreator('Homecare_Contract_Line_Item',jj_rb_Test_MDR_class.getRecordtype('Homecare Contract','jj_rb_Rebate_Contract_Line_Item__c'));

        //Retailer Contract  
        jj_rb_Test_MDR_class.ReocrdTypeCreator('Contract_LineItem_Retailer',jj_rb_Test_MDR_class.getRecordtype('Retailer Contract','jj_rb_Rebate_Contract_Line_Item__c'));
        jj_rb_Rebate_Contract__c contract = jj_rb_test_Contract.retailerContractCreator();
        jj_rb_test_Contract.retailerContractLineItemCreator(contract.id);
        contract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Submitted', 'Submitted'); 
        update contract;
         ApexPages.StandardController sc_contract = new ApexPages.StandardController(contract);
        jj_rb_Close_contract closeContract = new jj_rb_Close_contract(sc_contract);
        PageReference pgref = new PageReference('jj_rb_Close_Rebate_Contract');
        pgref.getParameters().put('id',string.valueOf(contract.id));
        test.setCurrentPage(pgref);
        closeContract.close_contract();
        
        //Homecare contract
        jj_rb_Rebate_Contract__c hcp_contract = jj_rb_test_Contract.HCPContractCreator();
        //System.debug('HCP contract ****** '+hcp_contract);
        
        jj_rb_test_Contract.HCPcontractlntitmcreator(hcp_contract.id);
        //System.debug('HCP line Item ******** '+jj_rb_test_Contract.HCPcontractlntitmcreator(hcp_contract.id));
        hcp_contract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Submitted', 'Submitted'); 
        update hcp_contract;
        //System.debug('updates HCP line item **** '+hcp_contract);
        ApexPages.StandardController hcp_controller = new ApexPages.StandardController(hcp_contract);
        //System.debug('controller ***** '+hcp_controller);
        jj_rb_Close_contract hcpcloseContract = new jj_rb_Close_contract(hcp_controller);
        PageReference pagref = new PageReference('jj_rb_Close_Rebate_Contract');
        pagref.getParameters().put('id',string.valueOf(hcp_contract.id));
        test.setCurrentPage(pagref);
        hcpcloseContract.close_contract();
        
        contract.jj_rb_Status__c = jj_rb_Test_MDR_class.customsStatusCreator('Approved', 'Approved'); 		
        update contract;
    }
    /*
    // jj_rb_Rebate_Contract_After_Update trigger  - 88%
    public static testmethod void test_contract_afterUpdate()
    {
        jj_rb_Rebate_Contract__c newContract = jj_rb_Test_Contract.retailerContractCreator();
        jj_rb_Rebate_Contract_Line_Item__c newLineItem = jj_rb_Test_Contract.retailerContractLineItemCreator(newContract.id);
        
    }
*/
}