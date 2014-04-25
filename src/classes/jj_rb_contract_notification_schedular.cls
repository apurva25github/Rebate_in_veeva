global class jj_rb_contract_notification_schedular implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        jj_rb_Contract_notifications batch = new jj_rb_Contract_notifications();
        database.executebatch(batch) ;
    }
}