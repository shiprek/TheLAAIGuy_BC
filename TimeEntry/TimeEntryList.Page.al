page 50150 "LAAI Time Entry List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LAAI Time Entry";
    Caption = 'Time Entries';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number of the time entry.';
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer associated with the time entry.';
                }
                field(Billable; Rec.Billable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the time entry is billable.';
                }
                field("Time Type"; Rec."Time Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of time entry (Agent/Human).';
                }
                field("Active Minutes"; Rec."Active Minutes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of active minutes for the time entry.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the time entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the time entry.';
                }
                field("Chat ID"; Rec."Chat ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the chat identifier for the time entry.';
                }
            }
        }
    }
}
