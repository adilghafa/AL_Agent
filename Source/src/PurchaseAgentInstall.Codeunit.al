codeunit 70003 "Purchase Agent Install"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    var
        PurchaseAgentMetadata: Codeunit "Purchase Agent Metadata";
        ItemListAgentMetadata: Codeunit "Item List Agent Metadata";
    begin
        PurchaseAgentMetadata.RegisterCopilotCapability();
        ItemListAgentMetadata.RegisterCopilotCapability();
    end;
}
