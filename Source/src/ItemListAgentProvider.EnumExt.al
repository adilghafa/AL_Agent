enumextension 50000 "Item List Agent Provider" extends "Agent Metadata Provider"
{
    value(50000; "Item List Assistant")
    {
        Caption = 'Item List Assistant';
        Implementation = IAgentFactory = "Item List Agent Metadata", IAgentMetadata = "Item List Agent Metadata", IAgentManualTaskCreation = "Item List Agent Metadata", IAgentTaskExecution = "Item List Agent Metadata";
    }
}
