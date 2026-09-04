table 50100 "LAAI Lead"
{
    Caption = 'Lead';
    DataClassification = CustomerContent;
    LookupPageId = "LAAI Lead List";
    DrillDownPageId = "LAAI Lead List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Name"; Text[100])
        {
            Caption = 'Name';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(3; "Company Name"; Text[100])
        {
            Caption = 'Company Name';
            DataClassification = CustomerContent;
        }
        field(4; "Email"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(5; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum "LAAI Lead Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(7; Source; Enum "LAAI Lead Source")
        {
            Caption = 'Source';
            DataClassification = CustomerContent;
        }
        field(8; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
        field(9; "Estimated Value"; Decimal)
        {
            Caption = 'Estimated Value';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(10; "Expected Close Date"; Date)
        {
            Caption = 'Expected Close Date';
            DataClassification = CustomerContent;
        }
        field(11; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(12; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14; "Notes"; Text[2048])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
        field(15; "Contacted Date"; Date)
        {
            Caption = 'Contacted Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Status; Status, "Salesperson Code")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then
            "No." := GetNextLeadNo();
        if "Created Date" = 0D then
            "Created Date" := Today;
    end;

    // Simple self-contained numbering (LEAD-000001, LEAD-000002, ...).
    // Swap this for a proper No. Series setup if you want users to control
    // the numbering pattern from Sales & Receivables Setup.
    local procedure GetNextLeadNo(): Code[20]
    var
        LeadRec: Record "LAAI Lead";
        LastNo: Integer;
    begin
        LeadRec.SetCurrentKey("No.");
        if LeadRec.FindLast() then
            Evaluate(LastNo, DelStr(LeadRec."No.", 1, StrLen('LEAD-')));
        exit('LEAD-' + Format(LastNo + 1, 0, '<Integer,6><Filler Character,0>'));
    end;
}
