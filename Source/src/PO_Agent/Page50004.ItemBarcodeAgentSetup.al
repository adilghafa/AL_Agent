//////namespace Microsoft.Agent.ItemBarcodeAgent;

using System.Agents;

page 70004 "Item Barcode Agent Setup"
{
    ApplicationArea = All;
    Caption = 'Configure Item with barcode Agent';
    Extensible = false;
    InstructionalText = 'Create an agent that finds an item by its barcode and returns the item name.';
    PageType = ConfigurationDialog;
    SourceTable = "Item Barcode Agent Settings";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            part(AgentSetupPart; "Agent Setup Part")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            group(InstructionsGroup)
            {
                Caption = 'Instructions';

                field(AgentInstructions; InstructionsText)
                {
                    ApplicationArea = All;
                    Caption = 'Agent instructions';
                    MultiLine = true;
                    ToolTip = 'Specifies how the agent finds the item that matches a barcode.';
                }
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(OK)
            {
                Caption = 'Create';
                ToolTip = 'Create or update the Item with barcode agent.';
            }

            systemaction(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Close without saving changes.';
            }
        }
    }

    trigger OnOpenPage()
    var
        ExistingSettings: Record "Item Barcode Agent Settings";
        UserSecurityIDFilter: Text;
    begin
        UserSecurityIDFilter := Rec.GetFilter("User Security ID");
        if not Evaluate(AgentUserSecurityId, UserSecurityIDFilter) then
            Clear(AgentUserSecurityId);
        IsNewAgent := IsNullGuid(AgentUserSecurityId);

        InstructionsText := DefaultInstructionsTxt;
        if not IsNewAgent and ExistingSettings.Get(AgentUserSecurityId) then begin
            Rec := ExistingSettings;
            Rec.Insert();
            InstructionsText := ExistingSettings.GetInstructionsAsText();
        end;

        AgentSetup.GetSetupRecord(
            AgentSetupBuffer,
            AgentUserSecurityId,
            Enum::"Agent Metadata Provider"::"Item with barcode",
            CopyStr(UserId(), 1, MaxStrLen(DefaultUserName)),
            CopyStr(UserId(), 1, MaxStrLen(DefaultDisplayName)),
            AgentSummaryTxt);
        CurrPage.AgentSetupPart.Page.SetAgentSetupBuffer(AgentSetupBuffer);
        CurrPage.AgentSetupPart.Page.Update(false);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Settings: Record "Item Barcode Agent Settings";
        ExistingSettings: Record "Item Barcode Agent Settings";
        Agent: Codeunit Agent;
    begin
        if CloseAction = Action::Cancel then
            exit(true);

        CurrPage.AgentSetupPart.Page.GetAgentSetupBuffer(AgentSetupBuffer);
        if IsNullGuid(AgentSetupBuffer."User Security ID") then
            AgentUserSecurityId := AgentSetup.SaveChanges(AgentSetupBuffer)
        else begin
            AgentUserSecurityId := AgentSetupBuffer."User Security ID";
            if AgentSetup.GetChangesMade(AgentSetupBuffer) then
                AgentUserSecurityId := AgentSetup.SaveChanges(AgentSetupBuffer);
        end;

        Agent.SetInstructions(AgentUserSecurityId, SecretStrSubstNo('%1', InstructionsText));

        if ExistingSettings.Get(AgentUserSecurityId) then begin
            Settings := ExistingSettings;
            Settings.SetInstructions(InstructionsText);
            Settings.Modify();
        end else begin
            Settings.Init();
            Settings."User Security ID" := AgentUserSecurityId;
            Settings.SetInstructions(InstructionsText);
            Settings.Insert();
        end;

        exit(true);
    end;

    var
        AgentSetup: Codeunit "Agent Setup";
        AgentSetupBuffer: Record "Agent Setup Buffer" temporary;
        InstructionsText: Text;
        DefaultUserName: Code[50];
        DefaultDisplayName: Text[80];
        AgentUserSecurityId: Guid;
        IsNewAgent: Boolean;
        AgentSummaryTxt: Label 'Finds an item by its barcode and returns the item name.';
        DefaultInstructionsTxt: Label 'When the user provides a barcode, find the matching item and return its item number and name. Search both the item GTIN field and item reference entries with reference type Bar Code. Match the barcode exactly. If no barcode is provided, ask the user for one. If no item matches, say that no matching item was found. If more than one item matches, list the possible matches and ask the user to clarify.';
}
