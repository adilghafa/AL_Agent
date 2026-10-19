enumextension 50000 "Item List Agent Provider" extends "Agent Metadata Provider"
{
    value(50000; "Item List Assistant")
    {
        Caption = 'Purchased Item Overview Assistant';
        Implementation = IAgentFactory = "Item List Agent Metadata", IAgentMetadata = "Item List Agent Metadata", IAgentManualTaskCreation = "Item List Agent Metadata", IAgentTaskExecution = "Item List Agent Metadata";
    }
}