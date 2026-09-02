table 50101 "LAAI Website Intake"
{
    Caption = 'Website Intake';
    DataClassification = CustomerContent;
    LookupPageId = "LAAI Website Intake List";
    DrillDownPageId = "LAAI Website Intake List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Submission Id"; Text[100])
        {
            Caption = 'Submission Id';
            DataClassification = SystemMetadata;
        }
        field(3; "Schema Version"; Integer)
        {
            Caption = 'Schema Version';
            InitValue = 1;
            MinValue = 1;
            DataClassification = SystemMetadata;
        }
        field(4; "Source Code"; Code[50])
        {
            Caption = 'Source Code';
            InitValue = 'squarespace_visitor_choice';
            DataClassification = SystemMetadata;
        }
        field(5; "Intake Type"; Enum "LAAI Intake Type")
        {
            Caption = 'Intake Type';
            DataClassification = CustomerContent;
        }
        field(6; "Received At"; DateTime)
        {
            Caption = 'Received At';
            DataClassification = SystemMetadata;
        }
        field(7; "First Name"; Text[50])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
        }
        field(8; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(9; Email; Text[100])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(10; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            DataClassification = CustomerContent;
        }
        field(11; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(12; "Company Role"; Text[100])
        {
            Caption = 'Company Role';
            DataClassification = CustomerContent;
        }
        field(13; "Company Size"; Enum "LAAI Intake Company Size")
        {
            Caption = 'Company Size';
            DataClassification = CustomerContent;
        }
        field(14; "Existing Client"; Boolean)
        {
            Caption = 'Existing Client';
            DataClassification = CustomerContent;
        }
        field(15; "AI Maturity"; Enum "LAAI Intake AI Maturity")
        {
            Caption = 'AI Maturity';
            DataClassification = CustomerContent;
        }
        field(16; "Service Categories"; Text[250])
        {
            Caption = 'Service Categories';
            DataClassification = CustomerContent;
        }
        field(17; "Current Platforms"; Text[2048])
        {
            Caption = 'Current Platforms';
            DataClassification = CustomerContent;
        }
        field(18; "Desired Outcome"; Text[2048])
        {
            Caption = 'Desired Outcome';
            DataClassification = CustomerContent;
        }
        field(19; "Target Timing"; Enum "LAAI Intake Timing")
        {
            Caption = 'Target Timing';
            DataClassification = CustomerContent;
        }
        field(20; "Next Step"; Enum "LAAI Intake Next Step")
        {
            Caption = 'Next Step';
            DataClassification = CustomerContent;
        }
        field(21; "Meeting Preference"; Enum "LAAI Intake Meeting")
        {
            Caption = 'Meeting Preference';
            DataClassification = CustomerContent;
        }
        field(22; "Requested Window"; Text[250])
        {
            Caption = 'Requested Window';
            DataClassification = CustomerContent;
        }
        field(23; "Preferred Contact Time"; Text[250])
        {
            Caption = 'Preferred Contact Time';
            DataClassification = CustomerContent;
        }
        field(24; "Additional Context"; Text[2048])
        {
            Caption = 'Additional Context';
            DataClassification = CustomerContent;
        }
        field(25; Status; Enum "LAAI Intake Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(26; "Raw Submission"; Text[2048])
        {
            Caption = 'Raw Submission';
            DataClassification = CustomerContent;
        }
        field(27; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            TableRelation = "LAAI Lead";
            DataClassification = CustomerContent;
        }
        field(28; "Integration Error"; Text[2048])
        {
            Caption = 'Integration Error';
            DataClassification = SystemMetadata;
        }
        field(29; "Processed At"; DateTime)
        {
            Caption = 'Processed At';
            DataClassification = SystemMetadata;
        }
        field(30; "SOW Required"; Boolean)
        {
            Caption = 'SOW Required';
            InitValue = true;
            DataClassification = CustomerContent;
        }
        field(31; "Flat Fee Available"; Boolean)
        {
            Caption = 'Flat Fee Available';
            InitValue = true;
            DataClassification = CustomerContent;
        }
        field(32; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(33; "Sales Quote No."; Code[20])
        {
            Caption = 'Sales Quote No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Quote));
            DataClassification = CustomerContent;
        }
        field(34; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
            DataClassification = CustomerContent;
        }
        field(35; "Last Conversion At"; DateTime)
        {
            Caption = 'Last Conversion At';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Submission; "Submission Id") { Unique = true; }
        key(Status; Status, "Received At") { }
        key(Email; Email, "Received At") { }
    }

    trigger OnInsert()
    begin
        if "Submission Id" = '' then
            "Submission Id" := CopyStr(Format(CreateGuid()), 1, MaxStrLen("Submission Id"));
        if "Received At" = 0DT then
            "Received At" := CurrentDateTime();
        if Status = Status::New then
            Status := Status::"Review Required";
    end;
}
