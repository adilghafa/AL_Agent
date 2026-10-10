//namespace Microsoft.Agent.PurchaseOrderAgent;

page 70003 "POA Instructions History"
{
    ApplicationArea = All;
    Caption = 'Agent instructions history';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "POA Instructions History";
    SourceTableView = sorting("User Security ID", "Entry No.") order(descending);
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(History)
            {
                field(VersionName; Rec."Version Name")
                {
                    ApplicationArea = All;
                    Caption = 'Version';
                }
                field(CreatedAt; Rec."Created At")
                {
                    ApplicationArea = All;
                    Caption = 'Created at';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User Security ID", AgentUserSecurityId);
    end;

    procedure SetAgentUserSecurityId(NewAgentUserSecurityId: Guid)
    begin
        AgentUserSecurityId := NewAgentUserSecurityId;
    end;

    procedure GetSelectedInstructions(): Text
    begin
        exit(Rec.GetInstructionsAsText());
    end;

    var
        AgentUserSecurityId: Guid;
}
