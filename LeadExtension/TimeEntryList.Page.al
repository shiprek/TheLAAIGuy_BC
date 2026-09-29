page 50102 "LAAI Time Entry List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LAAI Time Entry";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Chat ID"; Rec."Chat ID") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Is Billable"; Rec."Is Billable") { ApplicationArea = All; }
                field("Time Type"; Rec."Time Type") { ApplicationArea = All; }
                field("Active Minutes"; Rec."Active Minutes") { ApplicationArea = All; }
                field("Date"; Rec."Date") { ApplicationArea = All; }
                field("Description"; Rec."Description") { ApplicationArea = All; }
            }
        }
    }
}
