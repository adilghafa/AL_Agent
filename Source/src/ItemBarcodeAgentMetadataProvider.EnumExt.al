//namespace Microsoft.Agent.ItemBarcodeAgent;

using System.Agents;

enumextension 70002 "Item Barcode Agent Provider" extends "Agent Metadata Provider"
{
    value(70001; "Item with barcode")
    {
        Caption = 'Item with barcode';
        Implementation = IAgentFactory = "Item Barcode Agent Metadata", IAgentMetadata = "Item Barcode Agent Metadata", IAgentManualTaskCreation = "Item Barcode Agent Metadata", IAgentTaskExecution = "Item Barcode Agent Metadata";
    }
}
