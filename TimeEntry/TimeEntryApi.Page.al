page 50151 "LAAI Time Entry API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'time';
    APIVersion = 'v1.0';
    EntityName = 'timeEntry';
    EntitySetName = 'timeEntries';
    EntityCaption = 'Time Entry';
    EntitySetCaption = 'Time Entries';
    SourceTable = "LAAI Time Entry";
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
                field(entryNo; Rec."Entry No.") { }
                field(customer; Rec.Customer) { }
                field(billable; Rec.Billable) { }
                field(timeType; Rec."Time Type") { }
                field(activeMinutes; Rec."Active Minutes") { }
                field(date; Rec.Date) { }
                field(description; Rec.Description) { }
                field(chatId; Rec."Chat ID") { }
            }
        }
    }
}
