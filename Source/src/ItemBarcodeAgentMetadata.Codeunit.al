////namespace Microsoft.Agent.ItemBarcodeAgent;

using System.Agents;
using System.AI;
using System.Reflection;
using System.Security.AccessControl;

codeunit 70004 "Item Barcode Agent Metadata" implements IAgentFactory, IAgentMetadata, IAgentManualTaskCreation, IAgentTaskExecution
{
    procedure GetDefaultInitials(): Text[4]
    begin
        exit('ITM');
    end;

    procedure GetFirstTimeSetupPageId(): Integer
    begin
        exit(Page::"Item Barcode Agent Setup");
    end;

    procedure ShowCanCreateAgent(): Boolean
    begin
        exit(true);
    end;

    procedure GetCopilotCapability(): Enum "Copilot Capability"
    begin
        exit("Copilot Capability"::"Item with barcode");
    end;

    procedure GetDefaultProfile(var TempAllProfile: Record "All Profile" temporary)
    var
        Agent: Codeunit Agent;
        CurrentModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(CurrentModuleInfo);
        Agent.PopulateDefaultProfile(ItemBarcodeAgentProfileTok, CurrentModuleInfo.Id, TempAllProfile);
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
        TempAccessControlBuffer."Role ID" := ItemBarcodeAgentPermissionSetTok;
        TempAccessControlBuffer.Insert();
    end;

    procedure GetInitials(AgentUserId: Guid): Text[4]
    begin
        exit(GetDefaultInitials());
    end;

    procedure GetSetupPageId(AgentUserId: Guid): Integer
    begin
        exit(Page::"Item Barcode Agent Setup");
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

    procedure AnalyzeAgentTaskMessage(AgentTaskMessage: Record "Agent Task Message"; var Annotations: Record "Agent Annotation")
    begin
    end;

    procedure GetAgentTaskUserInterventionSuggestions(AgentTaskUserInterventionRequestDetails: Record "Agent User Int Request Details"; var Suggestions: Record "Agent Task User Int Suggestion")
    begin
    end;

    procedure GetAgentTaskPageContext(AgentTaskPageContextRequest: Record "Agent Task Page Context Req."; var AgentTaskPageContext: Record "Agent Task Page Context")
    begin
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
        if CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Item with barcode") then
            CopilotCapability.ModifyCapability(
                Enum::"Copilot Capability"::"Item with barcode",
                Enum::"Copilot Availability"::Preview,
                Enum::"Copilot Billing Type"::"Microsoft Billed",
                LearnMoreUrlTxt)
        else
            CopilotCapability.RegisterCapability(
                Enum::"Copilot Capability"::"Item with barcode",
                Enum::"Copilot Availability"::Preview,
                Enum::"Copilot Billing Type"::"Microsoft Billed",
                LearnMoreUrlTxt);
    end;

    var
        FileUploadsNotSupportedErr: Label 'This agent does not support uploaded files.';
        LearnMoreUrlTxt: Label 'https://learn.microsoft.com/dynamics365/business-central/', Locked = true;
        ItemBarcodeAgentPermissionSetTok: Label 'ITEM BARCODE AGENT', Locked = true, MaxLength = 20;
        ItemBarcodeAgentProfileTok: Label 'Item Barcode Agent', Locked = true;
        ManualTaskMessageTxt: Label 'Find the item identified by a barcode. If no barcode is provided, ask the user for one before searching. Search the item GTIN field and item reference entries where the reference type is Bar Code. Match the barcode exactly. Return the item number and item name; if there is no match or more than one match, explain that clearly.';
        ManualTaskTitleTxt: Label 'Find item by barcode';
}
