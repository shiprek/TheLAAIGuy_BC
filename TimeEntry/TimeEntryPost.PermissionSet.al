permissionset 50151 "LAAI TimeEntry Post"
{
    Assignable = true;
    Caption = 'LAAI TimeEntry Post';
    Permissions = tabledata "LAAI Time Entry" = M,
        codeunit "LAAI Post Time Entries" = X;
    // Assign together with D365 JOBS, EDIT, which grants the project posting.
}
