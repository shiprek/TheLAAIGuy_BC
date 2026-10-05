permissionset 50151 "LAAI Post TimeEntry"
{
    Assignable = true;
    Permissions = tabledata "LAAI Time Entry" = RIMD,
        page "LAAI Time Entry API" = X,
        codeunit "LAAI Post Time Entries" = X;
}
