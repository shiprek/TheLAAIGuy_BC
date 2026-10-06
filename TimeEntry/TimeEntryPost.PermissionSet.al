permissionset 50151 "LAAI TimeEntry Post"
{
    Assignable = true;
    Permissions = tabledata "LAAI Time Entry" = RM,
        codeunit "LAAI Post Time Entries" = X,
        page "LAAI Time Entry API" = X;
}
