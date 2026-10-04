codeunit 50000 "Purchase Agent Metadata" implements IAgentFactory, IAgentMetadata, IAgentManualTaskCreation
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCopilotCapability();
    end;

    procedure GetDefaultInitials(): Text[4]
    begin
        exit('PO');
    end;

    procedure GetFirstTimeSetupPageId(): Integer
    begin
        exit(Page::"Purchase Order Agent Setup");
    end;

    procedure ShowCanCreateAgent(): Boolean
    begin
        exit(true);
    end;

    procedure GetCopilotCapability(): Enum "Copilot Capability"
    begin
        exit("Copilot Capability"::"Purchase Order Agent");
    end;

    procedure GetDefaultProfile(var TempAllProfile: Record "All Profile" temporary)
    begin
    end;

    procedure GetDefaultAccessControls(var TempAccessControlBuffer: Record "Access Control Buffer" temporary)
    begin
    end;

    procedure GetInitials(AgentUserId: Guid): Text[4]
    begin
        exit(GetDefaultInitials());
    end;

    procedure GetSetupPageId(AgentUserId: Guid): Integer
    begin
        exit(Page::"Purchase Order Agent Setup");
    end;

    procedure GetSummaryPageId(AgentUserId: Guid): Integer
    begin
        exit(Page::"Agent Tasks List");
    end;

    procedure GetAgentTaskMessagePageId(AgentUserId: Guid; MessageId: Guid): Integer
    begin
        exit(Page::"Agent Task Message Card");
    end;

    procedure GetAgentAnnotations(AgentUserId: Guid; var Annotations: Record "Agent Annotation")
    begin
    end;

    procedure IsManualAgentTaskCreationEnabled(AgentUserId: Guid; ManualTaskType: Enum "Manual Agent Task Creation Type"): Boolean
    begin
        exit(ManualTaskType = ManualTaskType::Default);
    end;

    procedure IsMultipleFileUploadAllowed(AgentUserId: Guid): Boolean
    begin
        exit(false);
    end;

    procedure CreateManualAgentTask(AgentUserId: Guid; Files: List of [FileUpload])
    var
        AgentTaskBuilder: Codeunit "Agent Task Builder";
        AgentTaskMessageBuilder: Codeunit "Agent Task Message Builder";
    begin
        if Files.Count() > 0 then
            Error(FileUploadsNotSupportedErr);

        AgentTaskBuilder.Initialize(AgentUserId, ManualTaskTitleTxt);
        AgentTaskMessageBuilder.Initialize(ManualTaskMessageTxt);
        AgentTaskBuilder.AddTaskMessage(AgentTaskMessageBuilder);
        AgentTaskBuilder.Create(true, true);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Copilot AI Capabilities", OnRegisterCopilotCapability, '', false, false)]
    local procedure OnRegisterCopilotCapability()
    begin
        RegisterCopilotCapability();
    end;

    procedure RegisterCopilotCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
    begin
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Purchase Order Agent") then
            CopilotCapability.RegisterCapability(
                Enum::"Copilot Capability"::"Purchase Order Agent",
                Enum::"Copilot Availability"::Preview,
                Enum::"Copilot Billing Type"::"Microsoft Billed",
                LearnMoreUrlTxt);
    end;

    var
        FileUploadsNotSupportedErr: Label 'This agent does not support uploaded files.';
        LearnMoreUrlTxt: Label 'https://learn.microsoft.com/dynamics365/business-central/', Locked = true;
        ManualTaskMessageTxt: Label 'Review open and released purchase orders that do not have an expected receipt date. For each one, prepare an email draft to the vendor asking them to confirm the delivery date. Do not send any email. Report orders whose vendor has no email address.';
        ManualTaskTitleTxt: Label 'Follow up on purchase orders missing delivery dates';
}
