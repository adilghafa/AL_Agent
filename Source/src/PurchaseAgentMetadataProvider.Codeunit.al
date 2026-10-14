codeunit 70000 "Purchase Agent Metadata" implements IAgentFactory, IAgentMetadata, IAgentManualTaskCreation
{
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
    var
        Agent: Codeunit Agent;
        CurrentModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(CurrentModuleInfo);
        Agent.PopulateDefaultProfile(PurchaseOrderAgentProfileTok, CurrentModuleInfo.Id, TempAllProfile);
    end;

    procedure GetDefaultAccessControls(var TempAccessControlBuffer: Record "Access Control Buffer" temporary)
    var
        CurrentModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(CurrentModuleInfo);
        TempAccessControlBuffer.Init();
        TempAccessControlBuffer."Company Name" := CopyStr(CompanyName(), 1, MaxStrLen(TempAccessControlBuffer."Company Name"));
        TempAccessControlBuffer.Scope := TempAccessControlBuffer.Scope::System;
        TempAccessControlBuffer."App ID" := CurrentModuleInfo.Id;
        TempAccessControlBuffer."Role ID" := PurchaseOrderAgentPermissionSetTok;
        TempAccessControlBuffer.Insert();
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
        if CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Purchase Order Agent") then
            CopilotCapability.ModifyCapability(
                Enum::"Copilot Capability"::"Purchase Order Agent",
                Enum::"Copilot Availability"::Preview,
                Enum::"Copilot Billing Type"::"Microsoft Billed",
                LearnMoreUrlTxt)
        else
            CopilotCapability.RegisterCapability(
                Enum::"Copilot Capability"::"Purchase Order Agent",
                Enum::"Copilot Availability"::Preview,
                Enum::"Copilot Billing Type"::"Microsoft Billed",
                LearnMoreUrlTxt);
    end;

    var
        FileUploadsNotSupportedErr: Label 'This agent does not support uploaded files.';
        LearnMoreUrlTxt: Label 'https://learn.microsoft.com/dynamics365/business-central/', Locked = true;
        PurchaseOrderAgentPermissionSetTok: Label 'PURCHASE ORDER AGENT', Locked = true, MaxLength = 20;
        PurchaseOrderAgentProfileTok: Label 'Purchase Order Agent', Locked = true;
        ManualTaskMessageTxt: Label 'Open Missing Delivery Dates in the Purchase Order Agent profile. Review open and released purchase orders without expected receipt dates. For each order, use Request Delivery Date to save an unsent supplier email draft. Never send or enqueue an email. Do not change purchase orders or vendors. Report orders whose vendor has no email address and summarize the drafts saved.';
        ManualTaskTitleTxt: Label 'Follow up on purchase orders missing delivery dates';
}
