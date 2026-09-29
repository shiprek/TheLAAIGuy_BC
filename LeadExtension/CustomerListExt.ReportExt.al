reportextension 50100 "LAAI Customer List Ext" extends "Customer - List"
{
    dataset
    {
        add(Customer)
        {
            column(LAAI_Days_Since_Last_Order; DaysSinceLastOrder) { }
        }
        modify(Customer)
        {
            trigger OnAfterAfterGetRecord()
            begin
                DaysSinceLastOrder := CalcDaysSinceLastOrder(Rec."No.");
            end;
        }
    }

    var
        DaysSinceLastOrder: Integer;

    local procedure CalcDaysSinceLastOrder(CustomerNo: Code[20]): Integer
    var
        SalesHeader: Record "Sales Header";
        NoOfDays: Integer;
    begin
        SalesHeader.SetCurrentKey("Sell-to Customer No.", "Document Type", "Posting Date");
        SalesHeader.SetFilter("Sell-to Customer No.", CustomerNo);
        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Quote);
        SalesHeader.SetAscending("Posting Date", false);
        if SalesHeader.FindFirst() then
            NoOfDays := Today - SalesHeader."Posting Date"
        else
            NoOfDays := 0;
        exit(NoOfDays);
    end;
}
