trigger jj_rb_Rebate_claimInvoice_attachment on Attachment (after insert, after update,after Delete,before delete) 
{
    if(trigger.isAfter)
    {
        if(trigger.isInsert || trigger.isUpdate)
        {
            jj_rb_Rebate_claimInvoice_triggerhandler.updateRebateClaim(Trigger.new,True);
        }
        else if(trigger.isDelete)
        {
			jj_rb_Rebate_claimInvoice_triggerhandler.updateRebateClaim(Trigger.OLD,False);       
        }
    }
    else if(trigger.isBefore)
    {
        jj_rb_Rebate_claimInvoice_triggerhandler.BeforeDeleteAttactment(Trigger.OLD);
    }
}