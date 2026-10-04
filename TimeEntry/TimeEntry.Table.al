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
}
