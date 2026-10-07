codeunit 50151 "LAAI Time Sheet Entries"
{
    TableNo = "LAAI Time Entry";

    trigger OnRun()
    begin
    end;

    procedure PutOnTimeSheet(var TimeEntry: Record "LAAI Time Entry")
    var
        IsHandled: Boolean;
        TimeSheetMgt: Codeunit "Time Sheet Management";
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetDetail: Record "Time Sheet Detail";
        Resource: Record Resource;
        Job: Record Job;
        JobTask: Record "Job Task";
        WorkType: Record "Work Type";
        EntryNo: Integer;
    begin
        OnBeforePutOnTimeSheet(TimeEntry, IsHandled);
        if IsHandled then
            exit;

        // Validate that the time entry has a resource
        if TimeEntry."Resource No." = '' then
            Error('The time entry must have a Resource No. to be put on a time sheet.');

        // Get the resource details
        Resource.Get(TimeEntry."Resource No.");

        // Create or get the time sheet header for this resource
        if not TimeSheetHeader.Get(Resource."Time Sheet No.") then begin
            TimeSheetHeader.Init();
            TimeSheetHeader."No." := Resource."Time Sheet No.";
            TimeSheetHeader."Resource No." := TimeEntry."Resource No.";
            TimeSheetHeader.Insert();
        end;

        // Create a time sheet line for this entry
        TimeSheetLine.Init();
        TimeSheetLine."Time Sheet No." := TimeEntry."Time Sheet No.";
        TimeSheetLine."Line No." := 0; // Will be assigned by the system
        TimeSheetLine.Type := TimeSheetLine.Type::Job;
        TimeSheetLine."No." := TimeEntry."Project No.";
        TimeSheetLine."Work Type Code" := TimeEntry."Work Type";
        TimeSheetLine.Quantity := Round(TimeEntry."Active Minutes" / 60, 0.00001);
        TimeSheetLine.Insert();

        // Update the time entry with time sheet information
        TimeEntry."Time Sheet No." := TimeEntry."Time Sheet No.";
        TimeEntry."Time Sheet Line No." := TimeSheetLine."Line No.";
        TimeEntry.Modify();

        OnAfterPutOnTimeSheet(TimeEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePutOnTimeSheet(var TimeEntry: Record "LAAI Time Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPutOnTimeSheet(var TimeEntry: Record "LAAI Time Entry")
    begin
    end;
}
