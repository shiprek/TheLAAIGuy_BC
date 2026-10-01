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
            DataClassification = SystemMetadata;
        }
        field(2; Customer; Code[20])
        {
            Caption = 'Customer';
            TableRelation = Customer;
            DataClassification = CustomerContent;
        }
        field(3; Billable; Boolean)
        {
            Caption = 'Billable';
            DataClassification = CustomerContent;
        }
        field(4; "Time Type"; Enum "LAAI Time Type")
        {
            Caption = 'Time Type';
            DataClassification = CustomerContent;
        }
        field(5; "Active Minutes"; Integer)
        {
            Caption = 'Active Minutes';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Chat ID"; Text[50])
        {
            Caption = 'Chat ID';
            DataClassification = SystemMetadata;
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
