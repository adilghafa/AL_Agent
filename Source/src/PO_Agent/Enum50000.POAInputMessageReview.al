//namespace Microsoft.Agent.PurchaseOrderAgent;

enum 70000 "POA Input Message Review"
{
    value(0; "All Messages")
    {
        Caption = 'All';
    }
    value(1; "First Message")
    {
        Caption = 'First message in a conversation';
    }
    value(2; "No Review")
    {
        Caption = 'No review (advanced)';
    }
}
