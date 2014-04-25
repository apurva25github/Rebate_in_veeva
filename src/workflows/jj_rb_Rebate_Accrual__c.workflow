<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>jj_rb_Email_alert_for_Head_of_BU_for_accrual</fullName>
        <description>Email alert for Head of BU for  accrual</description>
        <protected>false</protected>
        <recipients>
            <recipient>jj_rb_UK_Head_of_BU</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Rebate_Accrual_approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Email_alert_for_NCM</fullName>
        <description>Email alert for NCM</description>
        <protected>false</protected>
        <recipients>
            <field>jj_rb_Customer_NCM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Rebate_Accrual_rejection_notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_Accreual_Submitted</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Rebate Accreual Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_Accrual_Submitted</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Rebate Accrual Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_accrual_approved</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Rebate accrual approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_accrual_rejected</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rebate accrual rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
