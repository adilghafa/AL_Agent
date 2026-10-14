page 50000 "Purchase Agent Role Center"
{
    ApplicationArea = All;
    Caption = 'Purchase Order Agent';
    Extensible = false;
    PageType = RoleCenter;

    actions
    {
        area(Embedding)
        {
            action(MissingDeliveryDates)
            {
                ApplicationArea = All;
                Caption = 'Missing Delivery Dates';
                Image = Email;
                RunObject = page "Purchase Orders Missing Dates";
                ToolTip = 'Review open and released purchase orders without expected receipt dates and save supplier email drafts.';
            }
            action(Vendors)
            {
                ApplicationArea = All;
                Caption = 'Vendors';
                Image = Vendor;
                RunObject = page "Vendor List";
                ToolTip = 'Look up supplier contact details and email addresses.';
            }
            action(AgentTasks)
            {
                ApplicationArea = All;
                Caption = 'Agent Tasks';
                Image = Entries;
                RunObject = page "Agent Tasks List";
                ToolTip = 'View the tasks completed or pending for this agent.';
            }
        }
    }
}
