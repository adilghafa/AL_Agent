permissionset 50001 "ITEM LIST AGENT"
{
    Assignable = true;
    Caption = 'Purchased Item Overview Assistant';
    IncludedPermissionSets = "D365 Agent", "Inventory - View";

    Permissions =
        tabledata Item = R,
        tabledata Vendor = R,
        tabledata "Item Ledger Entry" = R,
        table "Item Purchase Overview" = X,
        page "Item List Agent Role Center" = X,
        page "Item Purchase Overview" = X,
        codeunit "Item List Agent Metadata" = X;
}