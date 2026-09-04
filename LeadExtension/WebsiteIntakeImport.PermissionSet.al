permissionset 50101 "LAAI INTAKE IMPORT"
{
    Assignable = true;
    Caption = 'Website Intake Import Only';
    Permissions =
        tabledata "LAAI Website Intake" = RI,
        table "LAAI Website Intake" = X,
        page "LAAI Website Intake API" = X;
}
