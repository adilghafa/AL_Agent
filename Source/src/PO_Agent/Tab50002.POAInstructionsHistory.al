//namespace Microsoft.Agent.PurchaseOrderAgent;

table 70002 "POA Instructions History"
{
    Caption = 'Purchase Order Agent Instructions History';
    DataClassification = CustomerContent;
    Extensible = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "User Security ID"; Guid)
        {
        }
        field(3; "Version Name"; Text[100])
        {
        }
        field(4; "Created At"; DateTime)
        {
        }
        field(5; Instructions; Blob)
        {
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(UserSecurityID; "User Security ID", "Entry No.")
        {
        }
    }

    internal procedure SetInstructions(InstructionsAsText: Text)
    var
        InstructionsOutStream: OutStream;
    begin
        Clear(Instructions);
        Instructions.CreateOutStream(InstructionsOutStream, TextEncoding::UTF8);
        InstructionsOutStream.WriteText(InstructionsAsText);
    end;

    internal procedure GetInstructionsAsText(): Text
    var
        InstructionsInStream: InStream;
        InstructionsBuilder: TextBuilder;
        ContentLine: Text;
    begin
        CalcFields(Instructions);
        if not Instructions.HasValue() then
            exit('');

        Instructions.CreateInStream(InstructionsInStream, TextEncoding::UTF8);
        while not InstructionsInStream.EOS do begin
            InstructionsInStream.ReadText(ContentLine);
            InstructionsBuilder.Append(ContentLine);
            if not InstructionsInStream.EOS then
                InstructionsBuilder.AppendLine();
        end;

        exit(InstructionsBuilder.ToText());
    end;
}
