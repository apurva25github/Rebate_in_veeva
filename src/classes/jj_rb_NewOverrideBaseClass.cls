/*
* Base class for the new button override functionality
*/
public abstract class jj_rb_NewOverrideBaseClass {
 private SObjectType parentSobType;
    private SObjectType childSobType;
    public jj_rb_NewOverrideBaseClass(SObjectType parentSobType, SObjectType childSobType) {
        this.parentSobType = parentSobType;
        this.childSobType = childSobType;
    }
    public PageReference url() {
        PageReference p = new PageReference('/' + childSobType.getDescribe().getKeyPrefix() + '/e');
        Map<String, String> m = p.getParameters();
        m.putAll(ApexPages.currentPage().getParameters());
        m.put('RecordType', getChildRecordTypeId(getParentSObjectId(m)));
        m.put('nooverride', '1');
        system.debug('p>>>>' + p);
        return p;
    }
    private Id getChildRecordTypeId(Id parentId) {
        SObject parent = Database.query('select RecordType.DeveloperName from ' + String.valueOf(parentSobType)
                + ' where Id = :parentId');
        system.debug('parent object>>>>' + parent);        
        String parentDeveloperName = (String) parent.getSobject('RecordType').get('DeveloperName');
        system.debug('parentDeveloperName>>>>' + parentDeveloperName);
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