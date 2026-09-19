permissionset 50102 "LAAI AGENT READ"
{
    Assignable = true;
    Caption = 'LAAI Lead Agent - Read Only';

    Permissions =
        tabledata "LAAI Lead" = R,
        table "LAAI Lead" = X,
        page "LAAI Lead API" = X;
}
