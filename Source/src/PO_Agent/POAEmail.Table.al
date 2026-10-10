table 70001 "POA Email"
{
    fields
    {
        field(1; "Email Inbox ID"; BigInteger)
        {
        }
        field(2; Processed; Boolean)
        {
        }
        field(9; "Sender Name"; Text[250])
        {
        }
        field(10; "Sender Address"; Text[250])
        {
        }
        field(11; "Received DateTime"; DateTime)
        {
        }
        field(12; "Sent DateTime"; DateTime)
        {
        }
        field(100; "Task ID"; BigInteger)
        {
        }
        field(101; "Task Message ID"; Guid)
        {
        }
        field(102; "Attachment Transferred"; Boolean)
        {
        }
        field(103; "Agent User Security ID"; Guid)
        {
        }
        field(120; "Agent Task Message Exist"; Boolean)
        {
        }
    }
    keys
    {
        key(Key1; "Email Inbox ID")
        {
        }
        key(Key2; "Agent User Security ID", Processed)
        {
        }
    }
}
