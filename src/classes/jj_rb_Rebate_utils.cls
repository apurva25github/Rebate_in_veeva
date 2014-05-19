/**
 *    @author  Sarabdeep Ahluwalia
 *    @date  15/04/2014
     @description  Utils method for rebate classes 
      
     Modification Log:
     ------------------------------------------------------------------------------------
     Developer              Date            Description
     ------------------------------------------------------------------------------------
     Sarabdeep Ahluwalia    15/04/2014      Original Version
 */
public with sharing class jj_rb_Rebate_utils {
        public static Id RECORDTYPE_HOSPITAL_VOD;
        
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
        
        public static Id getHospitalRecordTypeId()
        {
        	if(RECORDTYPE_HOSPITAL_VOD == null) {
        		RECORDTYPE_HOSPITAL_VOD = jj_rb_Test_BaseClass.getRecordTypeId('Hospital_vod', 'Account');
        	}
        		
        	return RECORDTYPE_HOSPITAL_VOD;	
        }
        
        // Checks if passed customer is a hospital
        public static Boolean isHospital(Account customer)
        {
            if(customer.Account_Type__c == 'Acute Trust' && 
            	customer.Structure_Type_JJ__c == 'Department' && 
            	customer.RecordTypeId == getHospitalRecordTypeId())
            {
                return true;
            }
            
        	return false;            
        } 
        
        // Checks if passed customer is a Trust
        public static Boolean isTrust(Account customer)
        {
            if(customer.Account_Type__c == 'Acute Trust' && 
            	customer.Structure_Type_JJ__c == 'Primary Organisation' && 
            	customer.RecordTypeId == getHospitalRecordTypeId())
            {
                return true;
            }      
                  
        	return false;            
        }
        
        //Checks if passed customer is a Retailer
        public static Boolean isRetailer(Account customer)
        {
            if(customer.Account_Type__c == 'Retail Shop' && customer.RecordTypeId == getHospitalRecordTypeId())
            {
                return true;
            }            
       		return false;            
        }
        
        // checks if passed customer is a homecare
        public static Boolean isHomecare(Account customer)
        {
            if(customer.Account_Type__c == 'Wholesaler Chemist' && customer.RecordTypeId == getHospitalRecordTypeId())
            {
                return true;
            }        
        	return false;
            
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
        private static Map<String, String> mapAccountType = new Map<String, String>();
        public static String getAccountType(String Acc_type)
         {
             if(mapAccountType.isEmpty()) {
                 list<jj_rb_account_type__c> ListAccType = [select jj_rb_Account_Type__c,name 
                                                             from jj_rb_account_type__c];
                 
                                                             
                 if(!ListAccType.isEmpty()) {
                     for(jj_rb_account_type__c accountType : ListAccType) {
                        mapAccountType.put(accountType.name, accountType.jj_rb_Account_Type__c);
                     }
                     return mapAccountType.get(Acc_type);
                 }    
             }   
            
             return mapAccountType.get(Acc_type);
         }
    }