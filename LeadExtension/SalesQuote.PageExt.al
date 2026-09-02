pageextension 50105 "LAAI Sales Quote Ext" extends "Sales Quote"
{
    layout
    {
        addafter("External Document No.")
        {
            field("LAAI Website Origin"; Rec."LAAI Website Origin")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies that this quote originated from a website intake.';
            }
            field("LAAI Intake Entry No."; Rec."LAAI Intake Entry No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the related website intake entry.';
            }
            field("LAAI Submission Id"; Rec."LAAI Submission Id")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the website submission identifier used by integrations.';
            }
        }
    }
}
