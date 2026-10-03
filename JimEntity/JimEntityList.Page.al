page 50200 "LAAI JimEntity List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LAAI JimEntity";
    Caption = 'Jim Entities';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("SystemId"; Rec."SystemId")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
