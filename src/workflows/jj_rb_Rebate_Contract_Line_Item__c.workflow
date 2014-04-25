<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>jj_rb_Calculate_Rebate</fullName>
        <field>jj_rb_Rebate__c</field>
        <formula>jj_rb_List_Price__c  -  jj_rb_Contract_Price__c</formula>
        <name>Calculate Rebate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_ContractLineItem_status_expired</fullName>
        <description>Set the status of the contract line item to expired.</description>
        <field>jj_rb_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>jj_rb_ContractLineItem_status_expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Contract_line_item_isModified</fullName>
        <description>Check the is modified checkbox whenever an existing line item is edited.</description>
        <field>jj_rb_Is_Modified__c</field>
        <literalValue>1</literalValue>
        <name>jj_rb_Contract_line_item_isModified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Line_Item_Rebate_Per_Unit</fullName>
        <description>Calculate the rebate per unit for homecare contract line items.</description>
        <field>jj_rb_Rebate__c</field>
        <formula>jj_rb_List_Price__c - jj_rb_Contract_Price__c</formula>
        <name>Line Item Rebate Per Unit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_Contract_Line_Item_status</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Modified</literalValue>
        <name>Rebate Contract Line Item status Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_Contract_Status_Update</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Modified</literalValue>
        <name>Rebate Contract Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>jj_rb_Rebate_Contract__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_contact_is_modified</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Modified</literalValue>
        <name>jj_rb_contact_is_modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>jj_rb_Rebate_Contract__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>jj_rb_Calculate_RebatePerUnit</fullName>
        <actions>
            <name>jj_rb_Line_Item_Rebate_Per_Unit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>jj_rb_Rebate_Contract__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Homecare Contract</value>
        </criteriaItems>
        <description>This workflow calculates the rebate per unit for homecare contract line items</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>jj_rb_Contract_Line_Item_expired</fullName>
        <active>true</active>
        <description>This workflow sets the contract line item to expired when the system date is greater than end date.</description>
        <formula>1=1</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>jj_rb_ContractLineItem_status_expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>jj_rb_Rebate_Contract_Line_Item__c.jj_rb_End_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>jj_rb_Contract_Line_Item_ismodified</fullName>
        <actions>
            <name>jj_rb_Contract_line_item_isModified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>jj_rb_Rebate_Contract_Line_Item_status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>jj_rb_Rebate_Contract_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is fired if an existing line item is changed.</description>
        <formula>NOT(ISNEW()) &amp;&amp;  NOT(ISCHANGED(jj_rb_Status__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>jj_rb_New_Record_Is_Modified</fullName>
        <actions>
            <name>jj_rb_Contract_line_item_isModified</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>jj_rb_contact_is_modified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>jj_rb_Rebate_Contract_Line_Item__c.jj_rb_Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>This workflow sets the Is Modified flag for new contract line item records.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>jj_rb_Rebate price update</fullName>
        <actions>
            <name>jj_rb_Calculate_Rebate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>jj_rb_Rebate_Contract_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Homecare Contract</value>
        </criteriaItems>
        <criteriaItems>
            <field>jj_rb_Rebate_Contract_Line_Item__c.jj_rb_Status__c</field>
            <operation>equals</operation>
            <value>New,Modified,Approved,Rejected</value>
        </criteriaItems>
        <description>This workflow is used to calculate the rebate value per unit is equal to the difference in list price and contract price.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
