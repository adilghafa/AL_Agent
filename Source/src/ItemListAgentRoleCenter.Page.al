page 50001 "Item List Agent Role Center"
{
    ApplicationArea = All;
    Caption = 'Item List Assistant';
    Extensible = false;
    PageType = RoleCenter;

    actions
    {
        area(Embedding)
        {
            action(Items)
            {
                ApplicationArea = All;
                Caption = 'Items';
                Image = Item;
                RunObject = page "Item List";
                ToolTip = 'Find items and inspect inventory, categories, attributes, availability, and substitutions.';
            }
            action(Customers)
            {
                ApplicationArea = All;
                Caption = 'Customers';
                Image = Customer;
                RunObject = page "Customer List";
                ToolTip = 'Look up customer pricing and discount groups.';
            }
            action(SalesPrices)
            {
                ApplicationArea = All;
                Caption = 'Sales Prices';
                Image = Price;
                RunObject = page "Sales Price Lists";
                ToolTip = 'Read sales price lists, customer applicability, and discount conditions.';
            }
            action(PurchaseLines)
            {
                ApplicationArea = All;
                Caption = 'Purchase Lines';
                Image = Purchase;
                RunObject = page "Purchase Lines";
                RunPageView = where("Document Type" = const(Order), Type = const(Item));
                ToolTip = 'Read item purchase order lines, outstanding quantities, and expected receipt dates.';
            }
            action(ItemLedgerEntries)
            {
                ApplicationArea = All;
                Caption = 'Item Ledger Entries';
                Image = ItemLedger;
                RunObject = page "Item Ledger Entries";
                ToolTip = 'Analyze posted item transactions and sales trends using date and entry-type filters.';
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
