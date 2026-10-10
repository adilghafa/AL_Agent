//////namespace Microsoft.Agent.ItemBarcodeAgent;

table 70003 "Item Barcode Agent Settings"
{
    Caption = 'Item Barcode Agent Settings';
    DataClassification = CustomerContent;
    Extensible = false;

    fields
    {
        field(1; "User Security ID"; Guid)
        {
        }
        field(2; Instructions; Blob)
        {
        }
    }

    keys
    {
        key(PK; "User Security ID")
        {
            Clustered = true;
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
