page 50002 "Item List Agent Setup"
{
    ApplicationArea = All;
    Caption = 'Configure Item List Assistant';
    Extensible = false;
    PageType = ConfigurationDialog;
    SourceTable = "Agent Setup Buffer";
    SourceTableTemporary = true;
    InstructionalText = 'Create a read-only assistant for item searches, inventory availability, customer pricing, and sales analysis. Default instructions are applied when the agent is created.';

    layout
    {
        area(Content)
        {
            part(AgentSetupPart; "Agent Setup Part")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            group(Instructions)
            {
                Caption = 'Default instructions';
                field(DefaultInstructions; DefaultInstructions)
                {
                    ApplicationArea = All;
                    Caption = 'Instructions';
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Shows the default instructions for new assistants. Existing agent instructions are preserved when updating setup.';
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
                Caption = 'Save';
                ToolTip = 'Create or update the Item List Assistant.';
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
        ItemListAgentMetadata: Codeunit "Item List Agent Metadata";
        UserSecurityIDFilter: Text;
    begin
        UserSecurityIDFilter := Rec.GetFilter("User Security ID");
        if UserSecurityIDFilter <> '' then
            if not Evaluate(AgentUserSecurityId, UserSecurityIDFilter) then
                Error(InvalidAgentFilterErr);

        DefaultInstructions := ItemListAgentMetadata.GetDefaultInstructions();
        AgentSetup.GetSetupRecord(
            TempAgentSetupBuffer,
            AgentUserSecurityId,
            Enum::"Agent Metadata Provider"::"Item List Assistant",
            DefaultUserNameTok,
            DefaultDisplayNameLbl,
            AgentSummaryTxt);
        CurrPage.AgentSetupPart.Page.SetAgentSetupBuffer(TempAgentSetupBuffer);
        CurrPage.AgentSetupPart.Page.Update(false);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Agent: Codeunit Agent;
        IsNewAgent: Boolean;
    begin
        if CloseAction = Action::Cancel then
            exit(true);

        CurrPage.AgentSetupPart.Page.GetAgentSetupBuffer(TempAgentSetupBuffer);
        IsNewAgent := IsNullGuid(TempAgentSetupBuffer."User Security ID");
        if IsNewAgent or AgentSetup.GetChangesMade(TempAgentSetupBuffer) then
            AgentUserSecurityId := AgentSetup.SaveChanges(TempAgentSetupBuffer)
        else
            AgentUserSecurityId := TempAgentSetupBuffer."User Security ID";

        if IsNewAgent then
            Agent.SetInstructions(AgentUserSecurityId, SecretStrSubstNo('%1', DefaultInstructions));
        exit(true);
    end;

    var
        TempAgentSetupBuffer: Record "Agent Setup Buffer" temporary;
        AgentSetup: Codeunit "Agent Setup";
        AgentUserSecurityId: Guid;
        DefaultInstructions: Text;
        DefaultUserNameTok: Label 'ITEM-LIST-AGENT', Locked = true, MaxLength = 50;
        DefaultDisplayNameLbl: Label 'Item List Assistant', MaxLength = 80;
        AgentSummaryTxt: Label 'Read-only item searches, inventory availability, customer pricing, and sales analysis.';
        InvalidAgentFilterErr: Label 'The agent user security ID filter is not a valid GUID.';
}
