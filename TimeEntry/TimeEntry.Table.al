table 50150 "LAAI Time Entry"
{
    DataClassification = CustomerContent;
    Caption = 'Time Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; Customer; Code[20])
        {
            Caption = 'Customer';
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(3; Billable; Boolean)
        {
            Caption = 'Billable';
            DataClassification = CustomerContent;
        }
        field(4; "Time Type"; Code[10])
        {
            Caption = 'Time Type';
            DataClassification = CustomerContent;
        }
        field(5; "Active Minutes"; Integer)
        {
            Caption = 'Active Minutes';
            DataClassification = CustomerContent;
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Chat ID"; Text[50])
        {
            Caption = 'Chat ID';
            DataClassification = CustomerContent;
        }
        field(9; "Project No."; Code[20])
        {
            Caption = 'Project No.';
            DataClassification = CustomerContent;
            TableRelation = Job;
        }
        field(10; "Project Task No."; Code[20])
        {
            Caption = 'Project Task No.';
            DataClassification = CustomerContent;
            TableRelation = "Job Task" where("Job No." = field("Project No."));
        }
        field(11; "Work Type"; Code[20])
        {
            Caption = 'Work Type';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
        }
        field(12; Status; Enum "LAAI Time Entry Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            InitValue = Open;
        }
        field(13; "Posted Entry No."; Integer)
        {
            Caption = 'Posted Entry No.';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ChatIDKey; "Chat ID")
        {
            Unique = true;
        }
    }
}
