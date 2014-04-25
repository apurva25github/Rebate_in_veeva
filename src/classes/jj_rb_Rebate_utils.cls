public with sharing class jj_rb_Rebate_utils {
	// Returns the recordTypeId for the specified record type name
	    public static String getRecordTypeId(String recordTypeName)
	    {
	        List<jj_rb_Master_Data_RecordTypes__c> listRecordTypes = [SELECT jj_rb_RecordTypeId__c 
	                                                            FROM jj_rb_Master_Data_RecordTypes__c 
	                                                            WHERE name = :recordTypeName];
	        if(!listRecordTypes.isEmpty())
	            return listRecordTypes[0].jj_rb_RecordTypeId__c;
	        return null;    
	    }
	    
	    //Returns the status Of Rabate Contract Line Items for Specified Status Value
	    public static String getRebateLineItemStatus(String status)
	    {
	        list<jj_rb_Rebate_Contract_Line_Item_Status__c> statusList = [select jj_rb_Rebate_Line_Item_Status__c
	                                                                from jj_rb_Rebate_Contract_Line_Item_Status__c
	                                                                where name =: status];
	        if(!statusList.isEmpty())
	            return statusList[0].jj_rb_Rebate_Line_Item_Status__c;
	        
	        return null;
	    }
	    
	    //Returns the MasterDataOwner's ID
	    /*public static String getMasterDataOwnerID(String OwnerID)
	    {
	        list<jj_rb_Master_Data_OwnerID__c> OwnIDList = [select jj_rb_Owner_ID__c 
	                                                        from jj_rb_Master_Data_OwnerID__c 
	                                                        where name=:OwnerID];
	        
	        if(!OwnIDList.isEmpty())
	            return OwnIDList[0].jj_rb_Owner_ID__c ;
	        
	        return null;
	    }*/
	    
	    //Returns the Account Type For Specified Record
	     public static String getAccountType(String Acc_type)
	     {
	         list<jj_rb_account_type__c> ListAccType = [select jj_rb_Account_Type__c 
	                                                     from jj_rb_account_type__c
	                                                     where name =: Acc_type];
	                                                     
	         if(!ListAccType.isEmpty())
	             return ListAccType[0].jj_rb_Account_Type__c;
	            
	         return null;
	     }
	}