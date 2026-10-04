page 50001 "Purchase Order Agent Setup"
{
    ApplicationArea = All;
    Caption = 'Configure Purchase Order Agent_AGTst';
    Extensible = false;
    InstructionalText = 'Choose the user and permissions for the purchase order agent.';
    PageType = ConfigurationDialog;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            part(AgentSetupPart; "Agent Setup Part")
            {
                ApplicationArea = All;
                UpdatePropagation = Both;
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
                ToolTip = 'Create or update the purchase order agent.';
            }

            systemaction(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Close without saving changes.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        AgentSetup.GetSetupRecord(
            AgentSetupBuffer,
            AgentUserSecurityId,
            Enum::"Agent Metadata Provider"::"Purchase Order Agent",
            CopyStr(UserId(), 1, MaxStrLen(DefaultUserName)),
            CopyStr(UserId(), 1, MaxStrLen(DefaultDisplayName)),
            AgentSummaryTxt);
        CurrPage.AgentSetupPart.Page.SetAgentSetupBuffer(AgentSetupBuffer);
        CurrPage.AgentSetupPart.Page.Update();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::Cancel then
            exit(true);

        CurrPage.AgentSetupPart.Page.GetAgentSetupBuffer(AgentSetupBuffer);
        if AgentSetup.GetChangesMade(AgentSetupBuffer) then
            AgentSetup.SaveChanges(AgentSetupBuffer);

        exit(true);
    end;

    var
        AgentSetup: Codeunit "Agent Setup";
        AgentSetupBuffer: Record "Agent Setup Buffer" temporary;
        AgentSummaryTxt: Label 'Follows up on purchase orders missing expected delivery dates and prepares email drafts for supplier review.';
        DefaultDisplayName: Text[80];
        DefaultUserName: Code[50];
        AgentUserSecurityId: Guid;
}
