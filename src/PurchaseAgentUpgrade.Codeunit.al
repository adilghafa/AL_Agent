codeunit 50002 "Purchase Agent Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerDatabase()
    var
        PurchaseAgentMetadata: Codeunit "Purchase Agent Metadata";
    begin
        PurchaseAgentMetadata.RegisterCopilotCapability();
    end;
}
