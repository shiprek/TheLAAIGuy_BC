permissionset 50100 "LAAI LEADS"
{
    Assignable = true;
    Caption = 'LAAI Leads and Website Intakes';

    Permissions =
        tabledata "LAAI Lead" = RIMD,
        tabledata "LAAI Website Intake" = RIMD,
        tabledata "LAAI Intake Event" = RIMD,
        table "LAAI Lead" = X,
        table "LAAI Website Intake" = X,
        table "LAAI Intake Event" = X,
        page "LAAI Lead Card" = X,
        page "LAAI Lead List" = X,
        page "LAAI Website Intake Card" = X,
        page "LAAI Website Intake List" = X,
        page "LAAI Website Intake API" = X,
        page "LAAI Intake Event ListPart" = X,
        codeunit "LAAI Lead-to-Customer Mgt" = X,
        codeunit "LAAI Website Intake Mgt" = X,
        xmlport "LAAI Website Intake CSV" = X;
}
