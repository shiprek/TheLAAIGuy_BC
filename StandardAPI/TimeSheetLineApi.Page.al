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
                field(lineNo; Rec."Line No.") { Editable = false; }
                field(timeSheetStartingDate; Rec."Time Sheet Starting Date") { Editable = false; }
                field(type; Rec.Type) { Editable = false; }
                field(jobNo; Rec."Job No.") { Editable = false; }
                field(jobTaskNo; Rec."Job Task No.") { Editable = false; }
                field(description; Rec.Description) { Editable = false; }
                field(workTypeCode; Rec."Work Type Code") { Editable = false; }
                field(status; Rec.Status) { Editable = false; }
                field(posted; Rec.Posted) { Editable = false; }
                field(totalQuantity; Rec."Total Quantity") { Editable = false; }
                field(resourceNo; ResourceNo) { Editable = false; }
                field(timeSheetNo; Rec."Time Sheet No.") { Editable = false; }
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
