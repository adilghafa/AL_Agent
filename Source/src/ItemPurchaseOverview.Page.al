page 50003 "Item Purchase Overview"
{
    ApplicationArea = All;
    Caption = 'Item Purchase Overview';
    PageType = List;
    SourceTable = "Item Purchase Overview";
    SourceTableView = sorting("Vendor Name", "Item No.");
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            group(Period)
            {
                Caption = 'Reporting period';
                field(PeriodStart; PeriodStart)
                {
                    Caption = 'Period Start';
                    ToolTip = 'Specifies the first posting date included in the rolling 12-month purchase quantities.';
                }
                field(PeriodEnd; PeriodEnd)
                {
                    Caption = 'Period End';
                    ToolTip = 'Specifies today, the last posting date included in purchase quantities and history. Inventory is current across all locations and variants.';
                }
            }
            repeater(Purchases)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the item purchased from this supplier.';
                    StyleExpr = InventoryStyle;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the current item description.';
                    StyleExpr = InventoryStyle;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Caption = 'Supplier';
                    ToolTip = 'Specifies the preferred vendor from the item card.';
                    StyleExpr = InventoryStyle;
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies current item inventory in base units across all locations and variants. Zero-inventory items are highlighted.';
                    StyleExpr = InventoryStyle;
                }
                field("Last Purchase Date"; Rec."Last Purchase Date")
                {
                    ToolTip = 'Specifies the latest purchase posting date for this item, including history before the reporting period. Fully undone purchases are excluded.';
                    StyleExpr = InventoryStyle;
                }
                field("Purchased Qty. 12 Months"; Rec."Purchased Qty. 12 Months")
                {
                    ToolTip = 'Specifies net quantity purchased in base units during the displayed period, excluding undone purchases, returns, and credit memos.';
                    StyleExpr = InventoryStyle;
                }
                field("Period Start"; Rec."Period Start")
                {
                    Visible = false;
                    ToolTip = 'Specifies the first posting date included in the 12-month quantities.';
                }
                field("Period End"; Rec."Period End")
                {
                    Visible = false;
                    ToolTip = 'Specifies the last posting date included in the 12-month quantities.';
                }
            }
            group(Summary)
            {
                Caption = 'Summary';
                field(TotalItems; TotalItems)
                {
                    Caption = 'Total Items';
                    ToolTip = 'Specifies the number of unique items in the overview.';
                }
                field(TotalPurchasedQty; TotalPurchasedQty)
                {
                    Caption = 'Total Purchased Quantity (12 Months)';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the net purchased quantity across all listed items during the reporting period.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshOverview)
            {
                Caption = 'Refresh';
                Image = Refresh;
                ToolTip = 'Recalculate the read-only overview using current posted entries and today as the period end.';

                trigger OnAction()
                begin
                    LoadOverview();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadOverview();
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Inventory = 0 then
            InventoryStyle := 'Unfavorable'
        else
            InventoryStyle := 'Standard';
    end;

    local procedure LoadOverview()
    var
        TempOverviewItem: Record "Item Purchase Overview" temporary;
    begin
        Rec.LoadPurchases();
        PeriodEnd := Today();
        PeriodStart := CalcDate('<-12M>', PeriodEnd) + 1;

        TotalItems := Rec.Count();
        TotalPurchasedQty := 0;
        TempOverviewItem.Copy(Rec, true);
        if TempOverviewItem.FindSet() then
            repeat
                TotalPurchasedQty += TempOverviewItem."Purchased Qty. 12 Months";
            until TempOverviewItem.Next() = 0;
    end;

    var
        PeriodStart: Date;
        PeriodEnd: Date;
        TotalItems: Integer;
        TotalPurchasedQty: Decimal;
        InventoryStyle: Text[30];
}
