codeunit 70002 "Purchase Agent Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerDatabase()
    var
        PurchaseAgentMetadata: Codeunit "Purchase Agent Metadata";
        ItemListAgentMetadata: Codeunit "Item List Agent Metadata";
    begin
        PurchaseAgentMetadata.RegisterCopilotCapability();
        ItemListAgentMetadata.RegisterCopilotCapability();
    end;
}
