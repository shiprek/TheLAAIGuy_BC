reportextension 50100 "LAAI Customer List Ext" extends "Customer - List"
{
    dataset
    {
        add(Customer)
        {
            column(DaysSinceLastOrder; DaysSinceLastOrder) { }
        }
        modify(Customer)
        {
            trigger OnAfterAfterGetRecord()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                DaysSinceLastOrder := 0;
                CustLedgerEntry.SetCurrentKey("Customer No.", "Posting Date");
                CustLedgerEntry.SetRange("Customer No.", Customer."No.");
                CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
                if CustLedgerEntry.FindLast() then
                    DaysSinceLastOrder := Today - CustLedgerEntry."Posting Date";
            end;
        }
    }

    var
        DaysSinceLastOrder: Integer;
}
