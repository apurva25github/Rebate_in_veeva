<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>jj_rb_Rebate_Accrual_Report_Notification</fullName>
        <description>Rebate Accrual Report Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>jj_rb_UK_Rebate_Accrual_Rpt_Receipt</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>jj_rb_UK_Indirect_Rebate_Email_Templates/jj_rb_Rebate_Accrual_Report_Notif</template>
    </alerts>
    <rules>
        <fullName>jj_rb_HCP_Accrual_Report_Finalization</fullName>
        <actions>
            <name>jj_rb_Rebate_Accrual_Report_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>jj_rb_Rebate_Accrual_Report__c.jj_rb_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>jj_rb_Rebate_Accrual_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Homecare Report</value>
        </criteriaItems>
        <description>Send email out on completion of report.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>jj_rb_Retailer_Accrual_Report_Finalization</fullName>
        <actions>
            <name>jj_rb_Rebate_Accrual_Report_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>jj_rb_Rebate_Accrual_Report__c.jj_rb_Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>jj_rb_Rebate_Accrual_Report__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Retailer report</value>
        </criteriaItems>
        <description>Send email out on completion of report.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
