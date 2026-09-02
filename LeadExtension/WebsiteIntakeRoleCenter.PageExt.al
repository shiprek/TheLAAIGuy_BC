pageextension 50104 "LAAI Intake RC Ext" extends "Business Manager Role Center"
{
    actions
    {
        addafter(Customers)
        {
            action("Website Intakes")
            {
                ApplicationArea = All;
                Caption = 'Website Intakes';
                RunObject = page "LAAI Website Intake List";
                ToolTip = 'Review website submissions before promoting them into the lead pipeline.';
            }
        }
    }
}
