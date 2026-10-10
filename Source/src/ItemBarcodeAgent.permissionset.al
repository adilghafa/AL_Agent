////namespace Microsoft.Agent.ItemBarcodeAgent;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Catalog;

permissionset 70000 "ITEM BARCODE AGENT"
{
    Assignable = true;
    Caption = 'Item with barcode agent';

    Permissions =
        tabledata Item = R,
        tabledata "Item Reference" = R,
        page "Item Card" = X,
        page "Item List" = X,
        tabledata "Item Barcode Agent Settings" = R,
        page "Item Barcode Agent Setup" = X,
        page "Item Barcode Agent Role Center" = X,
        tabledata "POA Email" = R,
        tabledata "POA Setup" = R,
        tabledata "POA Instructions History" = R;
}
