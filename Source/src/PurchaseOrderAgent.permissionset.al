permissionset 50000 "PURCHASE ORDER AGENT"
{
    Assignable = true;
    Caption = 'Purchase order follow-up agent';
    IncludedPermissionSets = "D365 Agent", "Email - Edit";

    Permissions =
        tabledata "Purchase Header" = R,
        tabledata "Purchase Line" = R,
        tabledata Vendor = R,
        tabledata "POA Setup" = R,
        tabledata "POA Email" = R,
        tabledata "POA Instructions History" = R,
        page "Purchase Agent Role Center" = X,
        page "Purchase Orders Missing Dates" = X,
        page "Vendor List" = X,
        page "Vendor Card" = X,
        codeunit "Purchase Agent Metadata" = X,
        codeunit "Purchase Agent Task Execution" = X;
}
