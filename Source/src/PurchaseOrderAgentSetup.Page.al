//namespace Microsoft.Agent.PurchaseOrderAgent;

using System.Agents;
using System.Email;

page 70001 "Purchase Order Agent Setup"
{
    ApplicationArea = All;
    Caption = 'Configure Purchase Order Agent';
    Extensible = false;
    InstructionalText = 'Choose how the agent follows up on purchase orders and prepares supplier email drafts.';
    PageType = ConfigurationDialog;
    RefreshOnActivate = true;
    SourceTable = "POA Setup";
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
            group(AgentModel)
            {
                Caption = 'Agent model';
                InstructionalText = 'Choose the model the agent uses to complete tasks. Auto uses the default model, which may change over time.';

                field(AgentModelName; SelectedModelDisplayName)
                {
                    ApplicationArea = All;
                    Caption = 'Model';
                    Editable = false;
                    AssistEdit = true;
                    ToolTip = 'Specifies the model used by the agent. Auto means the agent uses the default model.';

                    trigger OnAssistEdit()
                    var
                        TempAgentModel: Record "Agent Model" temporary;
                    begin
                        BuildAgentModelLookup(TempAgentModel);
                        if Page.RunModal(Page::"Agent Model List", TempAgentModel) <> Action::LookupOK then
                            exit;

                        if TempAgentModel."Model ID" = AutoModelIdLbl then begin
                            SelectedModelId := '';
                            SelectedModelDisplayName := AutoLbl;
                        end else begin
                            SelectedModelId := TempAgentModel."Model ID";
                            SelectedModelDisplayName := TempAgentModel."Model Name";
                        end;

                        IsModelUpdated := true;
                    end;
                }
            }
            group(SupplierEmail)
            {
                Caption = 'Monitor supplier email';

                field(EmailMonitoring; Rec."Email Monitoring")
                {
                    ApplicationArea = All;
                    Caption = 'Monitor email';
                    ToolTip = 'Specifies whether the agent monitors supplier email.';
                }
                field(Mailbox; MailboxName)
                {
                    ApplicationArea = All;
                    Caption = 'Account';
                    Editable = false;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the email account that the agent monitors.';

                    trigger OnAssistEdit()
                    begin
                        SelectMailbox();
                    end;
                }
                field(EmailFolder; Rec."Email Folder")
                {
                    ApplicationArea = All;
                    Caption = 'Folder';
                    ToolTip = 'Specifies the email folder monitored by the agent.';
                }
                field(EarliestSyncAt; Rec."Earliest Sync At")
                {
                    ApplicationArea = All;
                    Caption = 'Start date';
                    ToolTip = 'Specifies the earliest date from which the agent monitors supplier email.';
                }
                field(MessageLimit; Rec."Message Limit")
                {
                    ApplicationArea = All;
                    Caption = 'Daily email limit';
                    ToolTip = 'Specifies the maximum number of email messages processed each day.';
                }
            }
            group(EmailProcessing)
            {
                Caption = 'Process supplier email';

                field(KnownSenderReview; Rec."Known Sender Input Message Review")
                {
                    ApplicationArea = All;
                    Caption = 'Registered sender messages';
                    ToolTip = 'Specifies which messages from registered senders require review.';
                }
                field(UnknownSenderReview; Rec."Unknown Sender Input Message Review")
                {
                    ApplicationArea = All;
                    Caption = 'Unregistered sender messages';
                    ToolTip = 'Specifies which messages from unregistered senders require review.';
                }
                field(AnalyzeAttachments; Rec."Analyze Attachments")
                {
                    ApplicationArea = All;
                    Caption = 'Analyze attachments';
                    ToolTip = 'Specifies whether the agent analyzes email attachments.';
                }
                field(MarkEmailAsRead; Rec."Mark Email As Read")
                {
                    ApplicationArea = All;
                    Caption = 'Mark email as read';
                    ToolTip = 'Specifies whether processed email messages are marked as read.';
                }
            }
            group(PurchaseOrderFollowUp)
            {
                Caption = 'Purchase order follow-up';
                InstructionalText = 'The agent finds open and released purchase orders without expected receipt dates and prepares unsent supplier email drafts.';
            }
            group(AgentInstructions)
            {
                Caption = 'Agent instructions';

                field(EditAgentInstructions; InstructionsActionTxt)
                {
                    ApplicationArea = All;
                    Caption = 'Instructions';
                    Editable = false;
                    AssistEdit = true;
                    ToolTip = 'Edit the instructions that guide the purchase order agent.';

                    trigger OnAssistEdit()
                    var
                        POAInstructionEditor: Page "POA Instruction Editor";
                    begin
                        POAInstructionEditor.SetAgentUserSecurityId(AgentUserSecurityId);
                        POAInstructionEditor.SetInstructions(AgentInstructions);
                        POAInstructionEditor.RunModal();
                        if not POAInstructionEditor.WasAccepted() then
                            exit;

                        AgentInstructions := POAInstructionEditor.GetInstructions();
                        IsInstructionsUpdated := true;
                    end;
                }
            }
            group(OutputMail)
            {
                Caption = 'Format outgoing supplier messages';

                field(EmailSignature; EmailSignature)
                {
                    ApplicationArea = All;
                    Caption = 'Email signature';
                    MultiLine = true;
                    ToolTip = 'Specifies the signature added to supplier email drafts.';
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
    var
        ExistingPOASetup: Record "POA Setup";
        UserSecurityIDFilter: Text;
    begin
        UserSecurityIDFilter := Rec.GetFilter("User Security ID");
        if not Evaluate(AgentUserSecurityId, UserSecurityIDFilter) then
            Clear(AgentUserSecurityId);
        IsNewAgent := IsNullGuid(AgentUserSecurityId);

        if not IsNullGuid(AgentUserSecurityId) then begin
            ExistingPOASetup.SetRange("User Security ID", AgentUserSecurityId);
            if ExistingPOASetup.FindFirst() then begin
                Rec := ExistingPOASetup;
                Rec.Insert();
            end;
        end;

        InitializeModelSelection();

        if Rec.IsEmpty() then begin
            Rec.Init();
            Rec.Insert();
        end;

        MailboxName := Rec."Email Address";
        EmailSignature := GetEmailSignatureAsText(Rec);
        AgentInstructions := GetAgentInstructionsAsText(Rec);
        if AgentInstructions = '' then
            AgentInstructions := DefaultInstructionsTxt;

        AgentSetup.GetSetupRecord(
            AgentSetupBuffer,
            AgentUserSecurityId,
            Enum::"Agent Metadata Provider"::"Purchase Order Agent",
            DefaultUserNameTok,
            DefaultDisplayNameLbl,
            AgentSummaryTxt);
        CurrPage.AgentSetupPart.Page.SetAgentSetupBuffer(AgentSetupBuffer);
        CurrPage.AgentSetupPart.Page.Update(false);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::Cancel then
            exit(true);

        CurrPage.AgentSetupPart.Page.GetAgentSetupBuffer(AgentSetupBuffer);
        if IsNullGuid(AgentSetupBuffer."User Security ID") then begin
            AgentUserSecurityId := AgentSetup.SaveChanges(AgentSetupBuffer)
        end else begin
            AgentUserSecurityId := AgentSetupBuffer."User Security ID";
            if AgentSetup.GetChangesMade(AgentSetupBuffer) then
                AgentUserSecurityId := AgentSetup.SaveChanges(AgentSetupBuffer);
        end;

        SaveModelSelection();
        if IsInstructionsUpdated or IsNewAgent then begin
            Rec.SetAgentInstructions(AgentInstructions);
            ApplyAgentInstructions();
        end;
        SavePOASetup();
        exit(true);
    end;

    local procedure SavePOASetup()
    var
        POASetup: Record "POA Setup";
        ExistingPOASetup: Record "POA Setup";
    begin
        ExistingPOASetup.LockTable();
        ExistingPOASetup.SetRange("User Security ID", AgentUserSecurityId);
        if ExistingPOASetup.FindFirst() then begin
            POASetup := ExistingPOASetup;
            POASetup.TransferFields(Rec, false);
            POASetup.ID := ExistingPOASetup.ID;
            POASetup."User Security ID" := AgentUserSecurityId;
            POASetup."Agent Name" := CopyStr(AgentSetupBuffer."Display Name", 1, MaxStrLen(POASetup."Agent Name"));
            POASetup."Agent Initials" := AgentSetupBuffer.Initials;
            POASetup."Email Address" := CopyStr(MailboxName, 1, MaxStrLen(POASetup."Email Address"));
            POASetup."Email Folder" := Rec."Email Folder";
            POASetup.SetEmailSignature(EmailSignature);
            POASetup.Modify();
        end else begin
            POASetup.TransferFields(Rec, false);
            POASetup."User Security ID" := AgentUserSecurityId;
            POASetup."Owner User Security ID" := UserSecurityId();
            POASetup."Agent Name" := CopyStr(AgentSetupBuffer."Display Name", 1, MaxStrLen(POASetup."Agent Name"));
            POASetup."Agent Initials" := AgentSetupBuffer.Initials;
            POASetup."Email Address" := CopyStr(MailboxName, 1, MaxStrLen(POASetup."Email Address"));
            POASetup."Email Folder" := Rec."Email Folder";
            POASetup.SetEmailSignature(EmailSignature);
            ExistingPOASetup.Reset();
            if ExistingPOASetup.FindLast() then
                POASetup.ID := ExistingPOASetup.ID + 1
            else
                POASetup.ID := 1;
            POASetup.Insert();
        end;
    end;

    local procedure SelectMailbox()
    var
        TempEmailAccount: Record "Email Account" temporary;
        EmailAccounts: Page "Email Accounts";
    begin
        EmailAccounts.EnableLookupMode();
        EmailAccounts.SetShowCreateAccount(true);
        if EmailAccounts.RunModal() = Action::LookupOK then begin
            EmailAccounts.GetAccount(TempEmailAccount);
            Rec."Email Account ID" := TempEmailAccount."Account Id";
            Rec."Email Connector" := TempEmailAccount.Connector;
            Rec."Email Address" := TempEmailAccount."Email Address";
            MailboxName := TempEmailAccount."Email Address";
            Clear(Rec."Email Folder");
            Clear(Rec."Email Folder Id");
        end;
    end;

    local procedure InitializeModelSelection()
    var
        Agent: Codeunit Agent;
    begin
        SelectedModelId := '';
        SelectedModelDisplayName := AutoLbl;
        if IsNullGuid(AgentUserSecurityId) then
            exit;

        SelectedModelId := Agent.GetModelId(AgentUserSecurityId);
        if SelectedModelId <> '' then
            SelectedModelDisplayName := Agent.GetModelName(AgentUserSecurityId);
    end;

    local procedure BuildAgentModelLookup(var TempAgentModel: Record "Agent Model" temporary)
    var
        AgentModel: Record "Agent Model";
    begin
        TempAgentModel.Reset();
        TempAgentModel.DeleteAll();

        TempAgentModel.Init();
        TempAgentModel."Model ID" := AutoModelIdLbl;
        TempAgentModel."Model Name" := AutoLbl;
        TempAgentModel.Availability := TempAgentModel.Availability::Available;
        TempAgentModel.Insert();

        AgentModel.SetFilter(Availability, '%1|%2', AgentModel.Availability::Preview, AgentModel.Availability::Available);
        if AgentModel.FindSet() then
            repeat
                TempAgentModel := AgentModel;
                TempAgentModel.Insert();
            until AgentModel.Next() = 0;

        if SelectedModelId <> '' then
            if not TempAgentModel.Get(SelectedModelId) then
                if AgentModel.Get(SelectedModelId) then begin
                    TempAgentModel := AgentModel;
                    TempAgentModel.Insert();
                end else begin
                    TempAgentModel.Init();
                    TempAgentModel."Model ID" := SelectedModelId;
                    TempAgentModel."Model Name" := SelectedModelDisplayName;
                    TempAgentModel.Availability := TempAgentModel.Availability::Preview;
                    TempAgentModel.Insert();
                end;

        if SelectedModelId <> '' then
            TempAgentModel.Get(SelectedModelId)
        else
            TempAgentModel.Get(AutoModelIdLbl);
    end;

    local procedure SaveModelSelection()
    var
        Agent: Codeunit Agent;
    begin
        if not IsModelUpdated and not IsNullGuid(AgentSetupBuffer."User Security ID") then
            exit;

        if SelectedModelId = '' then
            Agent.SetModelIdToAuto(AgentUserSecurityId)
        else
            Agent.SetModelId(AgentUserSecurityId, SelectedModelId);
    end;

    local procedure ApplyAgentInstructions()
    var
        Agent: Codeunit Agent;
    begin
        Agent.SetInstructions(AgentUserSecurityId, SecretStrSubstNo('%1', AgentInstructions));
    end;

    local procedure GetAgentInstructionsAsText(var POASetup: Record "POA Setup"): Text
    var
        InstructionsInStream: InStream;
        InstructionsBuilder: TextBuilder;
        ContentLine: Text;
    begin
        POASetup.CalcFields("Agent Instructions");
        if not POASetup."Agent Instructions".HasValue() then
            exit('');

        POASetup."Agent Instructions".CreateInStream(InstructionsInStream, TextEncoding::UTF8);
        while not InstructionsInStream.EOS do begin
            InstructionsInStream.ReadText(ContentLine);
            InstructionsBuilder.Append(ContentLine);
            if not InstructionsInStream.EOS then
                InstructionsBuilder.AppendLine();
        end;

        exit(InstructionsBuilder.ToText());
    end;

    local procedure GetEmailSignatureAsText(var POASetup: Record "POA Setup"): Text
    var
        EmailSignatureInStream: InStream;
        SignatureBuilder: TextBuilder;
        ContentLine: Text;
    begin
        POASetup.CalcFields("Email Template");
        if not POASetup."Email Template".HasValue() then
            exit('');

        POASetup."Email Template".CreateInStream(EmailSignatureInStream, TextEncoding::UTF8);
        EmailSignatureInStream.ReadText(ContentLine);
        SignatureBuilder.Append(ContentLine);
        while not EmailSignatureInStream.EOS do begin
            EmailSignatureInStream.ReadText(ContentLine);
            SignatureBuilder.Append(' ');
            SignatureBuilder.Append(ContentLine);
        end;

        exit(SignatureBuilder.ToText());
    end;

    var
        AgentSetup: Codeunit "Agent Setup";
        AgentSetupBuffer: Record "Agent Setup Buffer" temporary;
        EmailSignature: Text;
        AgentInstructions: Text;
        InstructionsActionTxt: Label 'Edit instructions...';
        MailboxName: Text;
        SelectedModelId: Code[30];
        SelectedModelDisplayName: Text[70];
        IsModelUpdated: Boolean;
        IsInstructionsUpdated: Boolean;
        IsNewAgent: Boolean;
        AutoLbl: Label 'Auto';
        AutoModelIdLbl: Label 'AUTO', Locked = true;
        AgentSummaryTxt: Label 'Follows up on purchase orders missing expected delivery dates and prepares email drafts for supplier review.';
        DefaultInstructionsTxt: Label 'Use the Purchase Order Agent profile. Open Missing Delivery Dates to review open and released purchase orders without expected receipt dates. For each order, use Request Delivery Date to save an unsent supplier email draft. Never send or enqueue an email. Do not change purchase orders or vendors. Report orders whose vendor has no email address and summarize the drafts saved. Do not monitor incoming email.';
        DefaultDisplayNameLbl: Label 'Purchase Order Agent', MaxLength = 80;
        DefaultUserNameTok: Label 'PURCHASE-AGENT', Locked = true, MaxLength = 50;
        AgentUserSecurityId: Guid;
}
