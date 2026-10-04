enumextension 50000 "Purchase Agent Provider" extends "Agent Metadata Provider"
{
    value(50000; "Purchase Order Agent")
    {
        Caption = 'Purchase Order Agent_AGTst';
        Implementation = IAgentFactory = "Purchase Agent Metadata", IAgentMetadata = "Purchase Agent Metadata", IAgentManualTaskCreation = "Purchase Agent Metadata", IAgentTaskExecution = "Purchase Agent Task Execution";
    }
}
