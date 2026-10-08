permissionset 50200 "LAAI Std API Read"
{
    Assignable = true;
    Permissions = tabledata "Job Ledger Entry" = R,
        tabledata "Time Sheet Line" = R,
        table "Job Ledger Entry" = X,
        table "Time Sheet Line" = X,
        page "LAAI Job Ledger Entry API" = X,
        page "LAAI Time Sheet Line API" = X;
}
