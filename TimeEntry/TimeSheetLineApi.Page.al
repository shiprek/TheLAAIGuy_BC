page 50153 "LAAI Time Sheet Line API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'timeentry';
    APIVersion = 'v1.0';
    EntityName = 'timeSheetLine';
    EntitySetName = 'timeSheetLines';
    EntityCaption = 'Time Sheet Line';
    EntitySetCaption = 'Time Sheet Lines';
    SourceTable = "Time Sheet Line";
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
                field(resourceNo; Rec."Resource No.") { }
                field(lineStatus; Rec."Line Status") { }
            }
        }
    }
}
