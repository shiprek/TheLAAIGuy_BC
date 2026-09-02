tableextension 50105 "LAAI Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "LAAI Website Origin"; Boolean)
        {
            Caption = 'Website Origin';
            DataClassification = SystemMetadata;
        }
        field(50101; "LAAI Intake Entry No."; Integer)
        {
            Caption = 'Website Intake Entry No.';
            DataClassification = SystemMetadata;
            TableRelation = "LAAI Website Intake"."Entry No.";
        }
        field(50102; "LAAI Submission Id"; Text[100])
        {
            Caption = 'Website Submission Id';
            DataClassification = SystemMetadata;
        }
    }
}
