tableextension 50150 "LAAI Time Entry Ext" extends "LAAI Time Entry"
{
    fields
    {
        field(50150; "Project No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Project;
        }
        field(50151; "Project Task No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Project Task";
        }
        field(50152; "Work Type"; Enum "LAAI Time Entry Status")
        {
            DataClassification = CustomerContent;
        }
        field(50153; Status; Enum "LAAI Time Entry Status")
        {
            DataClassification = CustomerContent;
            InitValue = Open;
        }
        field(50154; "Posted Entry No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }
}
