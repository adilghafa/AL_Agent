page 50002 "Item List Agent Setup"
{
    ApplicationArea = All;
    Caption = 'Configure Purchased Item Overview Assistant';
    Extensible = false;
    PageType = ConfigurationDialog;
    SourceTable = "Agent Setup Buffer";
    SourceTableTemporary = true;
    InstructionalText = 'Create a read-only assistant that lists purchased items by supplier. Default instructions are applied when the agent is created.';

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
                    ToolTip = 'Shows the default instructions for new assistants.';
                }
                field(ApplyDefaultInstructions; ApplyDefaultInstructions)
                {
                    ApplicationArea = All;
                    Caption = 'Apply Default Instructions';
                    ToolTip = 'Specifies whether saving setup replaces the agent instructions with the purchased-item overview defaults. This is selected by default for existing agents; clear it to preserve custom instructions.';
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
                ToolTip = 'Create or update the Purchased Item Overview Assistant.';
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

        ApplyDefaultInstructions := not IsNullGuid(AgentUserSecurityId);
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

        if IsNewAgent or ApplyDefaultInstructions then
            Agent.SetInstructions(AgentUserSecurityId, SecretStrSubstNo('%1', DefaultInstructions));
        exit(true);
    end;

    var
        TempAgentSetupBuffer: Record "Agent Setup Buffer" temporary;
        AgentSetup: Codeunit "Agent Setup";
        AgentUserSecurityId: Guid;
        DefaultInstructions: Text;
        ApplyDefaultInstructions: Boolean;
        DefaultUserNameTok: Label 'ITEM-LIST-AGENT', Locked = true, MaxLength = 50;
        DefaultDisplayNameLbl: Label 'Purchased Item Overview Assistant', MaxLength = 80;
        AgentSummaryTxt: Label 'Read-only overview of purchased items by supplier.';
        InvalidAgentFilterErr: Label 'The agent user security ID filter is not a valid GUID.';
}