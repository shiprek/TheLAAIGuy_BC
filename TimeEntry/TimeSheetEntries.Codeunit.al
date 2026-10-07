codeunit 50151 "LAAI Time Sheet Entries"
{
    Access = Internal;
    Permissions = tabledata "LAAI Time Entry" = M,
        codeunit "LAAI Post Time Entries" = X;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePutOnTimeSheet(var TimeEntry: Record "LAAI Time Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPutOnTimeSheet(var TimeEntry: Record "LAAI Time Entry")
    begin
    end;

    procedure PutOnTimeSheet(var TimeEntry: Record "LAAI Time Entry")
    var
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        IsHandled: Boolean;
    begin
        OnBeforePutOnTimeSheet(TimeEntry, IsHandled);
        if IsHandled then
            exit;

        // Validate that we have all required information
        if TimeEntry."Project No." = '' then
            Error('Project No. is required to put time entry on time sheet.');
        if TimeEntry."Project Task No." = '' then
            Error('Project Task No. is required to put time entry on time sheet.');
        if TimeEntry."Resource No." = '' then
            Error('Resource No. is required to put time entry on time sheet.');
        if TimeEntry.Date = 0D then
            Error('Date is required to put time entry on time sheet.');

        // Create or get the time sheet header for this resource
        if not TimeSheetHeader.Get(TimeEntry."Resource No.") then begin
            // Create new time sheet header
            TimeSheetHeader.Init();
            TimeSheetHeader."Resource No." := TimeEntry."Resource No.";
            TimeSheetHeader.Insert();
        end;

        // Create time sheet line for this entry
        TimeSheetLine.Init();
        TimeSheetLine."Time Sheet No." := TimeSheetHeader."No.";
        TimeSheetLine.Type := TimeSheetLine.Type::Job;
        TimeSheetLine."No." := TimeEntry."Project No.";
        TimeSheetLine."Job Task No." := TimeEntry."Project Task No.";
        TimeSheetLine.Date := TimeEntry.Date;
        TimeSheetLine."Work Type Code" := TimeEntry."Work Type";
        TimeSheetLine.Quantity := Round(TimeEntry."Active Minutes" / 60, 0.00001);
        TimeSheetLine.Insert();

        // Update the time entry with time sheet information
        TimeEntry."Time Sheet No." := TimeSheetHeader."No.";
        TimeEntry."Time Sheet Line No." := TimeSheetLine."Line No.";
        TimeEntry.Modify();

        OnAfterPutOnTimeSheet(TimeEntry);
    end;
}
