/*
* Base class for the new button override functionality
*/
public abstract class jj_rb_NewOverrideBaseClass {
 	private SObjectType parentSobType;
    private SObjectType childSobType;
    Apexpages.Standardcontroller stdController;
    
    public jj_rb_NewOverrideBaseClass(SObjectType parentSobType, SObjectType childSobType) {
        this.parentSobType = parentSobType;
        this.childSobType = childSobType;
    }
    
    public jj_rb_NewOverrideBaseClass(SObjectType parentSobType, SObjectType childSobType, Apexpages.Standardcontroller controller) {
        this.parentSobType = parentSobType;
        this.childSobType = childSobType;
        this.stdController = controller; 
    }
    
    public PageReference url() {
        PageReference p = new PageReference('/' + childSobType.getDescribe().getKeyPrefix() + '/e');
        Map<String, String> m = p.getParameters();
        system.debug('Params>>>'  + ApexPages.currentPage().getParameters());
        
        // get the parent record id
        m.putAll(ApexPages.currentPage().getParameters());
        Id parentSObjectId = getParentSObjectId(m);        
        if(parentSObjectId != null) {                
	        m.put('RecordType', getChildRecordTypeId(getParentSObjectId(m)));        
	        m.put('nooverride', '1');    
        } else {
        	m.put('save_new','1');
        	m.put('nooverride', '1');        	
        	m.remove('save_new');
        	m.remove('sfdc.override');
        }
        
        system.debug('pageRef>>>' + p);
                
        return p;
    }
    
    private Id getChildRecordTypeId(Id parentId) {        
        SObject parent = Database.query('select RecordType.DeveloperName from ' + String.valueOf(parentSobType)
                + ' where Id = :parentId');
                
        String parentDeveloperName = (String) parent.getSobject('RecordType').get('DeveloperName');        
        return [select Id from RecordType where SObjectType = :String.valueOf(childSobType)
                and DeveloperName = :parentDeveloperName].Id;
    }
    private Id getParentSObjectId(Map<String, String> m) {
    
        for (String key : m.keySet()) {            
            if (key.endsWith('_lkid')) {
                return m.get(key);
            }                
        }
        return null;
    }
}