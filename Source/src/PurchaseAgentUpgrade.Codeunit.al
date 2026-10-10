codeunit 70002 "Purchase Agent Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerDatabase()
    var
        PurchaseAgentMetadata: Codeunit "Purchase Agent Metadata";
        ItemBarcodeAgentMetadata: Codeunit "Item Barcode Agent Metadata";
    begin
        PurchaseAgentMetadata.RegisterCopilotCapability();
        ItemBarcodeAgentMetadata.RegisterCopilotCapability();
    end;
}
