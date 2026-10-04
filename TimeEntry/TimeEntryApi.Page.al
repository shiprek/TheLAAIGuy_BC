page 50102 "LAAI Time Entry API"
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
        area(content)
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
                field(projectNo; Rec."Project No.") { }
                field(projectTaskNo; Rec."Project Task No.") { }
                field(workType; Rec."Work Type") { }
                field(status; Rec.Status) { }
                field(postedEntryNo; Rec."Posted Entry No.") { }
            }
        }
    }
}
