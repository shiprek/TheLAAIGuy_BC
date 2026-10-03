page 50200 "LAAI Jim's Entity List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LAAI Jim's Entity";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(jim1; Rec."jim1") { ApplicationArea = All; }
                field(jim2; Rec."jim2") { ApplicationArea = All; }
                field(jim3; Rec."jim3") { ApplicationArea = All; }
            }
        }
    }
}
