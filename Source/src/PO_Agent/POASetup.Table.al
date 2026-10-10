//namespace Microsoft.Agent.PurchaseOrderAgent;
table 70000 "POA Setup"

{
    Extensible = false;

    fields
    {
        field(1; ID; Integer)
        {
        }
        field(2; "Agent User Security ID"; Guid)
        {
            ObsoleteReason = 'Replaced by "User Security ID" field.';
            ObsoleteState = Pending;
            ObsoleteTag = '28.0';
        }
        field(3; "Email Account ID"; Guid)
        {
        }
        field(4; "Email Connector"; Enum System.Email."Email Connector")
        {
        }
        field(5; "Incoming Monitoring"; Boolean)
        {
        }
        field(6; "Email Monitoring"; Boolean)
        {
        }
        field(7; Exists; Boolean)
        {
            Caption = 'Exists';
        }
        field(8; State; Option)
        {
            Caption = 'State';
            OptionMembers = Enabled,Disabled;
        }
        field(9; "Agent Scheduled Task ID"; Guid)
        {
        }
        field(10; "Recovery Scheduled Task ID"; Guid)
        {
        }
        field(11; "Quote Review"; Boolean)
        {
            Caption = 'Request Quote Review When Created';
        }
        field(12; "Create Order from Quote"; Boolean)
        {
            Caption = 'Create Order from Quote';
        }
        field(13; "Order Review"; Boolean)
        {
            Caption = 'Request Order Review When Created';
        }
        field(14; "Sales Doc. Configuration"; Boolean)
        {
            Caption = 'Sales Document Configuration';
        }
        field(15; "Search Only Available Items"; Boolean)
        {
            Caption = 'Search Only Available Items';
        }
        field(16; "Activated At"; DateTime)
        {
            Caption = 'Activated At';
        }
        field(17; "Earliest Sync At"; DateTime)
        {
            Caption = 'Earliest Sync At';
        }
        field(18; "Last Sync At"; DateTime)
        {
            Caption = 'Last Sync At';
        }
        field(19; "Email Address"; Text[250])
        {
            Caption = 'Email Address';
        }
        field(20; "Known Sender Input Message Review"; Enum "POA Input Message Review")
        {
            Caption = 'Registered Sender Input Message Review';
        }
        field(21; "Unknown Sender Input Message Review"; Enum "POA Input Message Review")
        {
            Caption = 'Unregistered Sender Input Message Review';
        }
        field(22; "Incl. Capable to Promise"; Boolean)
        {
            Caption = 'Include Capable to Promise';
        }
        field(23; "Instructions Last Sync At"; DateTime)
        {
            Caption = 'Instructions Last Sync At';
        }
        field(24; "Message Limit"; Integer)
        {
            Caption = 'Message Limit';
        }
        field(25; "Analyze Attachments"; Boolean)
        {
            Caption = 'Analyze attachments';
        }
        field(26; "Send Sales Quote"; Boolean)
        {
            Caption = 'Send Sales Quote';
        }
        field(27; "Email Template"; Blob)
        {
            Caption = 'Email Signature';
        }
        field(28; "Configure Email Template"; Boolean)
        {
            Caption = 'Configure Email Signature';
        }
        field(29; "Email Folder"; Text[2048])
        {
            Caption = 'Email Folder';
        }
        field(30; "Email Folder Id"; Text[2048])
        {
            Caption = 'Email Folder Id';
        }
        field(31; "Mark Email As Read"; Boolean)
        {
            Caption = 'Mark email as read';
        }
        field(32; "Agent Instructions"; Blob)
        {
            Caption = 'Agent Instructions';
        }
        field(33; "Owner User Security ID"; Guid)
        {
            Caption = 'Owner User Security ID';
        }
        field(34; "Agent Name"; Text[50])
        {
            Caption = 'Display name';
        }
        field(35; "Agent Initials"; Text[4])
        {
            Caption = 'Initials';
        }
        field(50; "User Security ID"; Guid)
        {
        }
    }
    keys
    {
        key(Key1; ID)
        {
        }
        key(Key2; "Agent User Security ID")
        {
        }
        key(Key3; "User Security ID")
        {
        }
    }

    internal procedure SetEmailSignature(EmailSignatureAsTxt: Text)
    var
        EmailSignatureOutStream: OutStream;
    begin
        Clear(Rec."Email Template");
        Rec."Email Template".CreateOutStream(EmailSignatureOutStream, TextEncoding::UTF8);
        EmailSignatureOutStream.WriteText(EmailSignatureAsTxt);
    end;

    internal procedure SetAgentInstructions(AgentInstructionsAsTxt: Text)
    var
        InstructionsOutStream: OutStream;
    begin
        Clear(Rec."Agent Instructions");
        Rec."Agent Instructions".CreateOutStream(InstructionsOutStream, TextEncoding::UTF8);
        InstructionsOutStream.WriteText(AgentInstructionsAsTxt);
    end;
}
