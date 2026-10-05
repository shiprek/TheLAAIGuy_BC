table 50150 "LAAI Time Entry"
{
    Caption = 'Time Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; Customer; Code[20])
        {
            Caption = 'Customer';
        }
        field(3; Billable; Boolean)
        {
            Caption = 'Billable';
        }
        field(4; "Time Type"; Enum "LAAI Time Type")
        {
            Caption = 'Time Type';
        }
        field(5; "Active Minutes"; Integer)
        {
            Caption = 'Active Minutes';
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Chat ID"; Text[50])
        {
            Caption = 'Chat ID';
        }
        field(9; "Project No."; Code[20])
        {
            Caption = 'Project No.';
            TableRelation = "Job";
        }
        field(10; "Project Task No."; Code[20])
        {
            Caption = 'Project Task No.';
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Project No."));
        }
        field(11; "Work Type"; Code[20])
        {
            Caption = 'Work Type';
            TableRelation = "Work Type";
        }
        field(12; Status; Enum "LAAI Time Entry Status")
        {
            Caption = 'Status';
            DefaultProperty = Open;
        }
        field(13; "Posted Entry No."; Integer)
        {
            Caption = 'Posted Entry No.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ChatID; "Chat ID")
        {
            Unique = true;
        }
    }

    trigger OnModify()
    begin
        if xRec.Status = Status::Posted then
            Error('Cannot modify a posted time entry.');
    end;

    trigger OnDelete()
    begin
        if xRec.Status = Status::Posted then
            Error('Cannot delete a posted time entry.');
    end;
}
