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

            trigger OnValidate()
            begin
                if Rec."Project No." <> xRec."Project No." then
                    Rec.Validate("Project Task No.", '');
            end;
        }
        field(10; "Project Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Project No."));
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

    trigger OnInsert()
    begin
        if Rec.Status = Rec.Status::Posted then
            Error('You cannot add a row that is already Posted.');
    end;

    trigger OnModify()
    begin
        if xRec.Status = xRec.Status::Posted then
            Error('You cannot change a row that is Posted.');
    end;

    trigger OnDelete()
    begin
        if xRec.Status = xRec.Status::Posted then
            Error('You cannot delete a row that is Posted.');
    end;
}
