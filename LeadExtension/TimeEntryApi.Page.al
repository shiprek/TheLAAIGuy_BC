page 50109 "LAAI Time Entry API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'timesheet';
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
                field(chatId; Rec."Chat ID") { }
                field(customerNo; Rec."Customer No.") { }
                field(billable; Rec."Billable") { }
                field(timeType; Rec."Time Type") { }
                field(activeMinutes; Rec."Active Minutes") { }
                field(date; Rec."Date") { }
                field(description; Rec."Description") { }
                field(jobNo; Rec."Job No.") { }
                field(jobTaskNo; Rec."Job Task No.") { }
                field(resourceNo; Rec."Resource No.") { }
            }
        }
    }
}
