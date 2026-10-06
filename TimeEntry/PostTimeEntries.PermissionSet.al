permissionset 50151 "LAAI TimeEntry Post"
{
    Assignable = true;
    Caption = 'Time Entry Post';
    // Assign together with D365 JOBS, EDIT, which grants the project posting.
    Permissions = tabledata "LAAI Time Entry" = RM,
        codeunit "LAAI Post Time Entries" = X;
}
