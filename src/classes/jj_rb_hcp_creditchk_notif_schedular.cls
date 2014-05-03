global class jj_rb_hcp_creditchk_notif_schedular implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        jj_rb_Homecare_CreditCheck_notification batch = new jj_rb_Homecare_CreditCheck_notification();
        database.executebatch(batch) ;
    }
}