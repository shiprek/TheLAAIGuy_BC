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
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DataAccessIntent = ReadOnly;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId) { Editable = false; }
                field(postingDate; Rec."Posting Date") { Editable = false; }
                field(entryType; Rec."Entry Type") { Editable = false; }
                field(jobNo; Rec."Job No.") { Editable = false; }
                field(jobTaskNo; Rec."Job Task No.") { Editable = false; }
                field(type; Rec.Type) { Editable = false; }
                field(no; Rec."No.") { Editable = false; }
                field(quantity; Rec.Quantity) { Editable = false; }
                field(totalCost; Rec."Total Cost") { Editable = false; }
                field(totalPrice; Rec."Total Price") { Editable = false; }
            }
        }
    }
}
