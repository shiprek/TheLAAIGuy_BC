page 50152 "LAAI Project Ledger Entry API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'timeentry';
    APIVersion = 'v1.0';
    EntityName = 'projectLedgerEntry';
    EntitySetName = 'projectLedgerEntries';
    EntityCaption = 'Project Ledger Entry';
    EntitySetCaption = 'Project Ledger Entries';
    SourceTable = "Job Ledger Entry";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Extensible = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId) { Editable = false; }
                field(postingDate; Rec."Posting Date") { }
                field(entryType; Rec."Entry Type") { }
                field(projectNo; Rec."Project No.") { }
                field(projectTaskNo; Rec."Project Task No.") { }
                field(type; Rec.Type) { }
                field(no; Rec."No.") { }
                field(quantity; Rec.Quantity) { }
                field(totalCost; Rec."Total Cost") { }
                field(totalPrice; Rec."Total Price") { }
            }
        }
    }
}
