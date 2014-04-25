<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>jj_rb_Claim_Rejection_notification</fullName>
        <description>Claim Rejection notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Rebate_claim_rejection_notification</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Email_alert_for_FD_Approval</fullName>
        <description>Email alert for FD Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>jj_rb_UK_Finance_Director</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/Rebate_claim_approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Email_alert_for_Head_of_BU_Approval</fullName>
        <description>Email alert for Head of BU Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>jj_rb_UK_Head_of_BU</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/Rebate_claim_approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Rebate_claim_final_report</fullName>
        <description>Rebate claim final report</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Rebate_Claim_Report_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_claim_Approved</fullName>
        <description>Rebate claim Approved</description>
        <field>jj_rb_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Rebate claim Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_claim_Rejected</fullName>
        <description>Rebate claim Rejected</description>
        <field>jj_rb_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Rebate claim Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Rebate_claim_submitted</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Rebate claim submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
