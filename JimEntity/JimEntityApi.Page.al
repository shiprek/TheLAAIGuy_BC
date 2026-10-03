page 50201 "LAAI Jim's Entity API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'jims';
    APIVersion = 'v1.0';
    EntityName = 'jimEntity';
    EntitySetName = 'jimEntities';
    EntityCaption = 'Jim''s Entity';
    EntitySetCaption = 'Jim''s Entities';
    SourceTable = "LAAI Jim's Entity";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId) { Editable = false; }
                field(jim1; Rec."jim1") { }
                field(jim2; Rec."jim2") { }
                field(jim3; Rec."jim3") { }
            }
        }
    }
}
