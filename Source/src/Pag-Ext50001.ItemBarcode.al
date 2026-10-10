namespace AL_Agent.AL_Agent;

using Microsoft.Inventory.Item;

pageextension 70001 ItemBarcode extends "Item Card"
{
    layout
    {
        addlast(Item)
        {
            field("Barcode"; Rec.GTIN)
            {
                Caption = 'Barcode';
                ExtendedDatatype = Barcode;
                applicationarea = All;
            }
        }
    }
}
