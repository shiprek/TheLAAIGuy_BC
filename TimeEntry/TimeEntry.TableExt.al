tableextension 50100 "LAAI Time Entry Ext" extends "LAAI Time Entry"
{
    fields
    {
        field(9; "Project No."; Code[20])
        {
        }
        field(10; "Project Task No."; Code[20])
        {
        }
        field(11; "Work Type"; Enum "LAAI Work Type")
        {
        }
        field(12; Status; Enum "LAAI Time Entry Status")
        {
        }
        field(13; "Posted Entry No."; Integer)
        {
        }
    }
}
