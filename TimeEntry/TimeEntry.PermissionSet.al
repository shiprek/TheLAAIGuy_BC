permissionset 50150 "LAAI Time Entry"
{
    Assignable = true;
    Caption = 'LAAI Time Entry';
    Permissions =
        tabledata "LAAI Time Entry" = RI,
        table "LAAI Time Entry" = X,
        page "LAAI Time Entry List" = X,
        page "LAAI Time Entry API" = X;
}
