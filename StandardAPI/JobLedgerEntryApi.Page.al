page 50200 "LAAI Job Ledger Entry API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'standard';
    APIVersion = 'v1.0';
    EntityName = 'jobLedgerEntry';
    EntitySetName = 'jobLedgerEntries';
    EntityCaption = 'Job Ledger Entry';
    EntitySetCaption = 'Job Ledger Entries';
    SourceTable = "Job Ledger Entry";
    ODataKeyFields = "Entry No.";
    DelayedInsert = true;
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DataAccessIntent = ReadOnly;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec."Entry No.") { Editable = false; }
                field(postingDate; Rec."Posting Date") { }
                field(entryType; Rec."Entry Type") { }
                field(jobNo; Rec."Job No.") { }
                field(jobTaskNo; Rec."Job Task No.") { }
                field(type; Rec.Type) { }
                field(no; Rec."No.") { }
                field(quantity; Rec.Quantity) { }
                field(totalCost; Rec."Total Cost") { }
                field(totalPrice; Rec."Total Price") { }
            }
        }
    }
}
