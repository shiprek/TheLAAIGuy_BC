page 50102 "LAAI Time Entry List"
{
    PageType = List;
    SourceTable = "LAAI Time Entry";
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field("Chat ID"; Rec."Chat ID") { }
                field("Customer No."; Rec."Customer No.") { }
                field("Billable"; Rec."Billable") { }
                field("Time Type"; Rec."Time Type") { }
                field("Active Minutes"; Rec."Active Minutes") { }
                field("Date"; Rec."Date") { }
                field("Description"; Rec."Description") { }
                field("Job No."; Rec."Job No.") { }
                field("Job Task No."; Rec."Job Task No.") { }
                field("Resource No."; Rec."Resource No.") { }
            }
        }
    }
}
