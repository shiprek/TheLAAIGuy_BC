page 50201 "LAAI Time Sheet Line API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'standard';
    APIVersion = 'v1.0';
    EntityName = 'timeSheetLine';
    EntitySetName = 'timeSheetLines';
    EntityCaption = 'Time Sheet Line';
    EntitySetCaption = 'Time Sheet Lines';
    SourceTable = "Time Sheet Line";
    ODataKeyFields = "Time Sheet No.";
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
                field(timeSheetNo; Rec."Time Sheet No.") { Editable = false; }
                field(lineNo; Rec."Line No.") { }
                field(timeSheetStartingDate; Rec."Time Sheet Starting Date") { }
                field(type; Rec.Type) { }
                field(jobNo; Rec."Job No.") { }
                field(jobTaskNo; Rec."Job Task No.") { }
                field(description; Rec.Description) { }
                field(workTypeCode; Rec."Work Type Code") { }
                field(status; Rec.Status) { }
                field(posted; Rec.Posted) { }
                field(totalQuantity; Rec."Total Quantity") { }
                field(resourceNo; ResourceNo) { Editable = false; }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        TimeSheetHeader: Record "Time Sheet Header";
    begin
        if TimeSheetHeader.Get(Rec."Time Sheet No.") then
            ResourceNo := TimeSheetHeader."Resource No."
        else
            Clear(ResourceNo);
    end;

    var
        ResourceNo: Code[20];
}
