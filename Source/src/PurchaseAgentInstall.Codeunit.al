codeunit 70003 "Purchase Agent Install"
{
    Subtype = Install;

    trigger OnInstallAppPerDatabase()
    var
        PurchaseAgentMetadata: Codeunit "Purchase Agent Metadata";
        ItemBarcodeAgentMetadata: Codeunit "Item Barcode Agent Metadata";
    begin
        PurchaseAgentMetadata.RegisterCopilotCapability();
        ItemBarcodeAgentMetadata.RegisterCopilotCapability();
    end;
}
