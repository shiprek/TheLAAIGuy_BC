table 50150 "LAAI Time Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Customer; Code[20])
        {
        }
        field(3; Billable; Boolean)
        {
        }
        field(4; "Time Type"; Enum "LAAI Time Type")
        {
        }
        field(5; "Active Minutes"; Integer)
        {
        }
        field(6; Date; Date)
        {
        }
        field(7; Description; Text[100])
        {
        }
        field(8; "Chat ID"; Text[50])
        {
        }
        field(9; "Project No."; Code[20])
        {
            TableRelation = Job;
        }
        field(10; "Project Task No."; Code[20])
        {
            TableRelation = "Job Task".No. where ("Job No." = field("Project No."));
        }
        field(11; "Work Type"; Code[10])
        {
            TableRelation = "Work Type";
        }
        field(12; Status; Enum "LAAI Time Entry Status")
        {
            InitValue = Open;
        }
        field(13; "Posted Entry No."; Integer)
        {
            TableRelation = "LAAI Time Entry"."Entry No.";
        }
    }

    keys
    {
        key(PPK; "Entry No.")
        {
            Clustered = true;
        }
        key(ChatID; "Chat ID")
        {
            Unique = true;
        }
    }

    trigger OnValidate()
    begin
        if Rec."Project No." <> xRec."Project No." then
            Rec.Validate("Project Task No.", '');
    end;

    trigger OnModify()
    var
        TimeEntry: Record "LAAI Time Entry";
    begin
        TimeEntry.Get(Rec."Entry No.");
        if TimeEntry.Status = "LAAI Time Entry Status"::Posted then
            Error('Cannot modify a posted time entry.');
    end;

    trigger OnDelete()
    var
        TimeEntry: Record "LAAI Time Entry";
    begin
        TimeEntry.Get(Rec."Entry No.");
        if TimeEntry.Status = "LAAI Time Entry Status"::Posted then
            Error('Cannot delete a posted time entry.');
    end;
}
