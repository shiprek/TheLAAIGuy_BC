permissionset 50103 "LAAI Time Entry API Access"
{
    Assignable = true;
    Permissions = tabledata "LAAI Time Entry" = RIMD,
        page "LAAI Time Entry List" = X,
        page "LAAI Time Entry API" = X;
}
