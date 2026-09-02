table 50102 "LAAI Intake Event"
{
    Caption = 'Website Intake Event';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; DataClassification = SystemMetadata; }
        field(2; "Intake Entry No."; Integer) { TableRelation = "LAAI Website Intake"; DataClassification = SystemMetadata; }
        field(3; "Submission Id"; Text[100]) { DataClassification = SystemMetadata; }
        field(4; "Event Type"; Enum "LAAI Intake Event Type") { DataClassification = CustomerContent; }
        field(5; "Occurred At"; DateTime) { DataClassification = SystemMetadata; }
        field(6; "User Id"; Text[132]) { DataClassification = EndUserIdentifiableInformation; }
        field(7; "Lead No."; Code[20]) { TableRelation = "LAAI Lead"; DataClassification = CustomerContent; }
        field(8; "Customer No."; Code[20]) { TableRelation = Customer; DataClassification = CustomerContent; }
        field(9; "Sales Quote No."; Code[20]) { DataClassification = CustomerContent; }
        field(10; "Sales Order No."; Code[20]) { DataClassification = CustomerContent; }
        field(11; Details; Text[250]) { DataClassification = CustomerContent; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Intake; "Intake Entry No.", "Occurred At") { }
    }
}
