//namespace Microsoft.Agent.PurchaseOrderAgent;

using System.Utilities;

page 70002 "POA Instruction Editor"
{
    ApplicationArea = All;
    Caption = 'Agent instructions';
    PageType = Document;
    Extensible = false;

    layout
    {
        area(Content)
        {
            group(InstructionsGroup)
            {
                ShowCaption = false;

                field(Instructions; AgentInstructions)
                {
                    ApplicationArea = All;
                    Caption = 'Instructions';
                    MultiLine = true;
                    ToolTip = 'Specifies the instructions that guide the purchase order agent.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Save)
            {
                ApplicationArea = All;
                Caption = 'Save';
                Image = Save;
                ToolTip = 'Save the current agent instructions.';

                trigger OnAction()
                begin
                    Accepted := true;
                    CurrPage.Close();
                end;
            }
            action(SaveToHistory)
            {
                ApplicationArea = All;
                Caption = 'Save to history';
                Enabled = CanSaveHistory;
                Image = Save;
                ToolTip = 'Save the current instructions as a version in the history.';

                trigger OnAction()
                var
                    POAInstructionsHistory: Record "POA Instructions History";
                begin
                    POAInstructionsHistory.Init();
                    POAInstructionsHistory."User Security ID" := AgentUserSecurityId;
                    POAInstructionsHistory."Created At" := CurrentDateTime();
                    POAInstructionsHistory."Version Name" := CopyStr(Format(CurrentDateTime(), 0, '<Year4>-<Month,2>-<Day,2> <Hours24,2>:<Minutes,2>:<Seconds,2>'), 1, MaxStrLen(POAInstructionsHistory."Version Name"));
                    POAInstructionsHistory.SetInstructions(AgentInstructions);
                    POAInstructionsHistory.Insert(true);
                    Message(InstructionsSavedMsg);
                end;
            }
            action(ViewHistory)
            {
                ApplicationArea = All;
                Caption = 'View history';
                Enabled = CanSaveHistory;
                Image = History;
                ToolTip = 'View and restore previously saved instruction versions.';

                trigger OnAction()
                var
                    POAInstructionsHistoryList: Page "POA Instructions History";
                begin
                    POAInstructionsHistoryList.SetAgentUserSecurityId(AgentUserSecurityId);
                    POAInstructionsHistoryList.LookupMode(true);
                    if POAInstructionsHistoryList.RunModal() <> Action::LookupOK then
                        exit;

                    AgentInstructions := POAInstructionsHistoryList.GetSelectedInstructions();
                    CurrPage.Update(false);
                end;
            }
            action(DownloadInstructions)
            {
                ApplicationArea = All;
                Caption = 'Download instructions';
                Image = Export;
                ToolTip = 'Download the current agent instructions to a text file.';

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    InstructionsOutStream: OutStream;
                    InstructionsInStream: InStream;
                    InstructionsFileName: Text;
                begin
                    TempBlob.CreateOutStream(InstructionsOutStream, TextEncoding::UTF8);
                    InstructionsOutStream.WriteText(AgentInstructions);
                    TempBlob.CreateInStream(InstructionsInStream, TextEncoding::UTF8);
                    InstructionsFileName := InstructionsFileNameTxt;
                    DownloadFromStream(InstructionsInStream, '', '', '', InstructionsFileName);
                end;
            }
            action(Cancel)
            {
                ApplicationArea = All;
                Caption = 'Cancel';
                Image = Cancel;
                ToolTip = 'Close without saving changes.';

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CanSaveHistory := not IsNullGuid(AgentUserSecurityId);
    end;

    procedure SetAgentUserSecurityId(NewAgentUserSecurityId: Guid)
    begin
        AgentUserSecurityId := NewAgentUserSecurityId;
    end;

    procedure SetInstructions(NewInstructions: Text)
    begin
        AgentInstructions := NewInstructions;
    end;

    procedure GetInstructions(): Text
    begin
        exit(AgentInstructions);
    end;

    procedure WasAccepted(): Boolean
    begin
        exit(Accepted);
    end;

    var
        AgentInstructions: Text;
        AgentUserSecurityId: Guid;
        CanSaveHistory: Boolean;
        Accepted: Boolean;
        InstructionsFileNameTxt: Label 'Purchase Order Agent Instructions.txt', Locked = true;
        InstructionsSavedMsg: Label 'The instructions were saved to history.';
}
