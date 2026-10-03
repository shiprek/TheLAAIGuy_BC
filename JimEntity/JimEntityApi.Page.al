page 50201 "LAAI JimEntity API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'jimentity';
    APIVersion = 'v1.0';
    EntityName = 'jimEntity';
    EntitySetName = 'jimEntities';
    EntityCaption = 'Jim Entity';
    EntitySetCaption = 'Jim Entities';
    SourceTable = "LAAI JimEntity";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(systemId; Rec."SystemId")
                {
                }
                field(name; Rec."Name")
                {
                }
                field(status; Rec."Status")
                {
                }
            }
        }
    }
}
