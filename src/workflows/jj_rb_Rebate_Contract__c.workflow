<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contract_Approval_notification</fullName>
        <description>Contract Approval notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>jj_rb_UK_Head_of_BU</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Home_care_Contract_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Email_Alert_For_Retailer_Contract_notification</fullName>
        <description>Email Alert For Retailer Contract notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>jj_rb_UK_Head_of_BU</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_RebateContract_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Homecare_provider_contract_Rejected_Notification</fullName>
        <description>Homecare provider contract Rejected Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Home_care_provider_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Rebate_Contract_Rejected_Notification</fullName>
        <description>Rebate Contract Rejected Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_RebateContract_Rejection_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_Contract_Expired</fullName>
        <description>This field update will set the status of the contract to expired.</description>
        <field>jj_rb_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Rebate_Contract_Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_Contract_Rejected</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rebate Contract Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_contract_Approved</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Rebate contract Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_contract_submitted</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Rebate contract submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>jj_rb_Contract_Expired</fullName>
        <actions>
            <name>jj_rb_Rebate_Contract_Expired</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set the status of the contract to expired if all the line items are expired.</description>
        <formula>(jj_rb_Total_Expired_Line_Items__c =  jj_rb_Total_Line_Items__c) &amp;&amp; jj_rb_Total_Line_Items__c &gt; 0</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
