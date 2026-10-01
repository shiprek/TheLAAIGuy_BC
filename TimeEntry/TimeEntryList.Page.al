page 50150 "LAAI Time Entry List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LAAI Time Entry";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = All;
                }
                field(Billable; Rec.Billable)
                {
                    ApplicationArea = All;
                }
                field("Time Type"; Rec."Time Type")
                {
                    ApplicationArea = All;
                }
                field("Active Minutes"; Rec."Active Minutes")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Chat ID"; Rec."Chat ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
