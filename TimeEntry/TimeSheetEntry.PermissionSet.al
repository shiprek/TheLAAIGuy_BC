permissionset 50152 "LAAI TimeSheet Entry"
{
    Assignable = true;
    Caption = 'LAAI Time Sheet Entry';
    Permissions = tabledata "LAAI Time Entry" = M,
        codeunit "LAAI Time Sheet Entries" = X;
    // Assign together with the base-app time sheet permissions.
}
