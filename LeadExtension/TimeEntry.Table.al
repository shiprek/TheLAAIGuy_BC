table 50103 "LAAI Time Entry"
{
    fields
    {
        field(1; "Entry No."; Integer) { AutoIncrement = true; }
        field(2; "Chat ID"; Text[50]) { }
        field(3; "Customer No."; Code[20]) { TableRelation = Customer; }
        field(4; "Billable"; Boolean) { }
        field(5; "Time Type"; Enum "LAAI Time Type") { }
        field(6; "Active Minutes"; Decimal) { }
        field(7; "Date"; Date) { }
        field(8; "Description"; Text[250]) { }
        field(9; "Job No."; Code[20]) { TableRelation = Job; }
        field(10; "Job Task No."; Code[20]) { TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No.")); }
        field(11; "Resource No."; Code[20]) { TableRelation = Resource; }
    }
    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(ChatID; "Chat ID") { Unique = true; }
    }
}
