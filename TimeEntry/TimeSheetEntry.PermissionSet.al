permissionset 50152 "LAAI TimeSheet Entry"
{
    Assignable = true;
    Caption = 'LAAI Time Sheet Entry';
    Permissions = tabledata "LAAI Time Entry" = RM,
        codeunit "LAAI Time Sheet Entries" = X,
        tabledata "Job Ledger Entry" = R;
    // Assign together with the base-app time sheet permissions.
}
