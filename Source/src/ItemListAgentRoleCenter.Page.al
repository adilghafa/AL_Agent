page 50001 "Item List Agent Role Center"
{
    ApplicationArea = All;
    Caption = 'Purchased Item Overview Assistant';
    Extensible = false;
    PageType = RoleCenter;

    actions
    {
        area(Embedding)
        {
            action(ItemPurchaseOverview)
            {
                ApplicationArea = All;
                Caption = 'Item Purchase Overview';
                Image = Purchase;
                RunObject = page "Item Purchase Overview";
                ToolTip = 'View each purchased item with its preferred supplier, current inventory, last purchase date, 12-month purchased quantity, and report totals.';
            }
            action(AgentTasks)
            {
                ApplicationArea = All;
                Caption = 'Agent Tasks';
                Image = Entries;
                RunObject = page "Agent Tasks List";
                ToolTip = 'View the assistant tasks and their results.';
            }
        }
    }
}
