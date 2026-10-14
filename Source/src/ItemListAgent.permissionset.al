permissionset 50001 "ITEM LIST AGENT"
{
    Assignable = true;
    Caption = 'Read-only Item List Assistant';
    IncludedPermissionSets = "D365 Agent", "Inventory - View";

    Permissions =
        tabledata Customer = R,
        tabledata "Customer Price Group" = R,
        tabledata "Customer Discount Group" = R,
        tabledata "Price List Header" = R,
        tabledata "Price List Line" = R,
        tabledata "Sales Price" = R,
        tabledata "Sales Line Discount" = R,
        tabledata "Purchase Header" = R,
        tabledata "Purchase Line" = R,
        tabledata "Sales Header" = R,
        tabledata "Sales Line" = R,
        tabledata "Currency Exchange Rate" = R,
        tabledata Currency = R,
        page "Item List Agent Role Center" = X,
        page "Customer List" = X,
        page "Customer Card" = X,
        page "Sales Price Lists" = X,
        page "Sales Price List" = X,
        page "Price List Lines" = X,
        page "Sales Prices" = X,
        page "Sales Line Discounts" = X,
        page "Purchase Lines" = X,
        codeunit "Item List Agent Metadata" = X;
}
