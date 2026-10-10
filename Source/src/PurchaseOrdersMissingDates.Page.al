page 70000 "Purchase Orders Missing Dates"
{
    ApplicationArea = All;
    Caption = 'Purchase Orders Missing Delivery Dates';
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header";
    SourceTableView = sorting("Document Type", "No.") where("Document Type" = const(Order), "Expected Receipt Date" = const(0D));
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order number.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor number.';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor name.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase order status.';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected receipt date. The list only includes orders where this date is missing.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RequestDeliveryDate)
            {
                ApplicationArea = All;
                Caption = 'Request Delivery Date';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Prepare an unsent email asking the vendor to confirm the delivery date.';

                trigger OnAction()
                var
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    Vendor: Record Vendor;
                begin
                    if Rec."Document Type" <> Rec."Document Type"::Order then
                        Error(PurchaseOrderOnlyErr);
                    if (Rec.Status <> Rec.Status::Open) and (Rec.Status <> Rec.Status::Released) then
                        Error(InvalidStatusErr, Rec."No.");
                    if Rec."Expected Receipt Date" <> 0D then
                        Error(DeliveryDateAlreadySetErr, Rec."No.");
                    if not Vendor.Get(Rec."Buy-from Vendor No.") then
                        Error(VendorNotFoundErr, Rec."Buy-from Vendor No.");
                    if Vendor."E-Mail" = '' then
                        Error(VendorEmailMissingErr, Vendor."No.");

                    EmailMessage.Create(
                        Vendor."E-Mail",
                        StrSubstNo(DeliveryDateSubjectLbl, Rec."No."),
                        StrSubstNo(DeliveryDateBodyLbl, Vendor.Name, Rec."No."),
                        false);
                    Email.OpenInEditor(EmailMessage);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter(Status, '%1|%2', Rec.Status::Open, Rec.Status::Released);
    end;

    var
        DeliveryDateAlreadySetErr: Label 'Purchase order %1 already has an expected receipt date.', Comment = '%1 = purchase order number.';
        DeliveryDateBodyLbl: Label 'Dear %1, please confirm the expected delivery date for purchase order %2. Thank you.', Comment = '%1 = vendor name; %2 = purchase order number.';
        DeliveryDateSubjectLbl: Label 'Request for delivery date - Purchase Order %1', Comment = '%1 = purchase order number.';
        InvalidStatusErr: Label 'Purchase order %1 must be open or released to request a delivery date.', Comment = '%1 = purchase order number.';
        PurchaseOrderOnlyErr: Label 'A delivery date can only be requested for a purchase order.';
        VendorEmailMissingErr: Label 'Vendor %1 does not have an email address. Add an email address to the vendor card before preparing the request.', Comment = '%1 = vendor number.';
        VendorNotFoundErr: Label 'Vendor %1 could not be found.', Comment = '%1 = vendor number.';
}
