<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>jj_rb_Email_Alert_For_Master_Data_Request_Submission</fullName>
        <description>Email Alert For Master Data Request Submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>jj_rb_UK_Head_of_BU</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_MasterData_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>jj_rb_Email_notification_for_MDR_Rejection</fullName>
        <description>Email notification for MDR Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Master_Data_Rejection_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>jj_rb_Approve_master_data_request</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approve master data request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Master_data_request_submitted</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Master data request submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>jj_rb_Reject_master_data_request</fullName>
        <field>jj_rb_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Reject master data request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
