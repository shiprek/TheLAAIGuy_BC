page 50151 "LAAI Time Entry API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'timeentry';
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
                field(status; Rec.Status) { Editable = false; }
                field(postedEntryNo; Rec."Posted Entry No.") { Editable = false; }
                field(resourceNo; Rec."Resource No.") { }
            }
        }
    }
    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Post(var ActionContext: WebServiceActionContext)
    var
        LAAIPostTimeEntries: Codeunit "LAAI Post Time Entries";
    begin
        LAAIPostTimeEntries.PostTimeEntry(Rec);

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"LAAI Time Entry API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}
