pageextension 50000 "Purchase Agent Role Center Ext" extends "Purchasing Agent Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group(PurchaseFollowUp)
            {
                Caption = 'Purchase Follow-up';

                action(PurchaseOrdersMissingDates)
                {
                    ApplicationArea = All;
                    Caption = 'Missing Delivery Dates';
                    Image = Email;
                    RunObject = page "Purchase Orders Missing Dates";
                    ToolTip = 'Review purchase orders without expected receipt dates and prepare email requests to vendors.';
                }
            }
        }
    }
}
