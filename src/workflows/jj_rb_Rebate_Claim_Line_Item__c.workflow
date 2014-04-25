<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>jj_rb_Claim_Line_Item_Calculated_VAT</fullName>
        <field>jj_rb_Calculated_VAT__c</field>
        <formula>jj_rb_VAT_Code__r.jj_rb_VAT__c * jj_rb_Net_Rebate__c</formula>
        <name>Claim Line Item Calculated VAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Claim_Line_Item_Net_Rebate_Inc_VAT</fullName>
        <description>This field update will sum the net rebate and calculated vat</description>
        <field>jj_rb_Net_Rebate_including_VAT__c</field>
        <formula>jj_rb_Net_Rebate__c + jj_rb_Calculated_VAT__c</formula>
        <name>Claim Line Item Net Rebate Including VAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Homecare_rebateperunit_calc</fullName>
        <description>Calculate the rebate per unit for homecare claims</description>
        <field>jj_rb_Rebate_Per_Unit__c</field>
        <formula>jj_rb_Unit_List_Price__c -  jj_rb_Unit_Contract_Price__c</formula>
        <name>Homecare rebate per unit calc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>jj_rb_Claim Line Item calculations</fullName>
        <actions>
            <name>jj_rb_Claim_Line_Item_Calculated_VAT</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>jj_rb_Claim_Line_Item_Net_Rebate_Inc_VAT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is used to calculate the calculated VAT, net rebate including VAT at the line item level.</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>jj_rb_Homecare_rebateperunit_calc</fullName>
        <actions>
            <name>jj_rb_Homecare_rebateperunit_calc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>jj_rb_Rebate_Claim_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Homecare Claim</value>
        </criteriaItems>
        <description>Calculate the rebate per unit for homecare claims.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
