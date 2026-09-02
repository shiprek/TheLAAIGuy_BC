page 50106 "LAAI Intake Event ListPart"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "LAAI Intake Event";
    Caption = 'Conversion Events';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Occurred At"; Rec."Occurred At") { ApplicationArea = All; }
                field("Event Type"; Rec."Event Type") { ApplicationArea = All; }
                field("Lead No."; Rec."Lead No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Sales Quote No."; Rec."Sales Quote No.") { ApplicationArea = All; }
                field("Sales Order No."; Rec."Sales Order No.") { ApplicationArea = All; }
                field("User Id"; Rec."User Id") { ApplicationArea = All; }
                field(Details; Rec.Details) { ApplicationArea = All; }
            }
        }
    }
}
