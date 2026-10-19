table 50000 "Item Purchase Overview"
{
    Caption = 'Item Purchase Overview';
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
        }
        field(5; Inventory; Decimal)
        {
            Caption = 'Current Inventory (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(6; "Last Purchase Date"; Date)
        {
            Caption = 'Last Purchase Posting Date';
        }
        field(7; "Purchased Qty. 12 Months"; Decimal)
        {
            Caption = 'Net Purchased Qty. Last 12 Months (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(10; "Period Start"; Date)
        {
            Caption = 'Period Start';
        }
        field(11; "Period End"; Date)
        {
            Caption = 'Period End';
        }
    }

    keys
    {
        key(PK; "Item No.")
        {
            Clustered = true;
        }
        key(VendorNameSort; "Vendor Name", "Item No.")
        {
        }
    }

    procedure LoadPurchases()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TempDocumentLine: Record "Item Ledger Entry" temporary;
        DocumentLines: Dictionary of [Text, Integer];
        DocumentLineKey: Text;
        EntryNo: Integer;
        PeriodStart: Date;
        PeriodEnd: Date;
    begin
        Reset();
        DeleteAll();
        PeriodEnd := Today();
        PeriodStart := CalcDate('<-12M>', PeriodEnd) + 1;

        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SetRange("Source Type", ItemLedgerEntry."Source Type"::Vendor);
        ItemLedgerEntry.SetLoadFields("Document Type", "Document No.", "Document Line No.",
            "Posting Date", "Source No.", "Item No.", Quantity);
        ItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3|%4',
            ItemLedgerEntry."Document Type"::"Purchase Receipt",
            ItemLedgerEntry."Document Type"::"Purchase Invoice",
            ItemLedgerEntry."Document Type"::"Purchase Return Shipment",
            ItemLedgerEntry."Document Type"::"Purchase Credit Memo");
        ItemLedgerEntry.SetRange("Posting Date", 0D, PeriodEnd);
        if ItemLedgerEntry.FindSet() then
            repeat
                // Net undo entries per posted document line before applying the receipt date.
                DocumentLineKey := StrSubstNo('%1:%2:%3', ItemLedgerEntry."Document Type".AsInteger(),
                    ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                if DocumentLines.Get(DocumentLineKey, EntryNo) then begin
                    TempDocumentLine.Get(EntryNo);
                    TempDocumentLine.Quantity += ItemLedgerEntry.Quantity;
                    TempDocumentLine.Modify();
                end else begin
                    TempDocumentLine := ItemLedgerEntry;
                    TempDocumentLine.Insert();
                    DocumentLines.Add(DocumentLineKey, ItemLedgerEntry."Entry No.");
                end;
            until ItemLedgerEntry.Next() = 0;

        TempDocumentLine.SetFilter("Document Type", '%1|%2',
            TempDocumentLine."Document Type"::"Purchase Receipt",
            TempDocumentLine."Document Type"::"Purchase Invoice");
        TempDocumentLine.SetFilter(Quantity, '>0');
        if TempDocumentLine.FindSet() then
            repeat
                AddPurchase(TempDocumentLine, PeriodStart, PeriodEnd);
            until TempDocumentLine.Next() = 0;

        TempDocumentLine.SetFilter("Document Type", '%1|%2',
            TempDocumentLine."Document Type"::"Purchase Return Shipment",
            TempDocumentLine."Document Type"::"Purchase Credit Memo");
        TempDocumentLine.SetFilter(Quantity, '<0');
        TempDocumentLine.SetRange("Posting Date", PeriodStart, PeriodEnd);
        if TempDocumentLine.FindSet() then
            repeat
                if Get(TempDocumentLine."Item No.") then begin
                    "Purchased Qty. 12 Months" += TempDocumentLine.Quantity;
                    Modify();
                end;
            until TempDocumentLine.Next() = 0;

        Reset();
    end;

    local procedure AddPurchase(ItemLedgerEntry: Record "Item Ledger Entry"; PeriodStart: Date; PeriodEnd: Date)
    var
        Item: Record Item;
        Vendor: Record Vendor;
    begin
        if not Get(ItemLedgerEntry."Item No.") then begin
            Item.Get(ItemLedgerEntry."Item No.");
            Item.CalcFields(Inventory);
            Init();
            "Item No." := Item."No.";
            Description := Item.Description;
            "Vendor No." := Item."Vendor No.";
            if Vendor.Get(Item."Vendor No.") then
                "Vendor Name" := Vendor.Name;
            Inventory := Item.Inventory;
            "Period Start" := PeriodStart;
            "Period End" := PeriodEnd;
            Insert();
        end;

        if ItemLedgerEntry."Posting Date" > "Last Purchase Date" then
            "Last Purchase Date" := ItemLedgerEntry."Posting Date";
        if ItemLedgerEntry."Posting Date" >= PeriodStart then
            "Purchased Qty. 12 Months" += ItemLedgerEntry.Quantity;
        Modify();
    end;
}
