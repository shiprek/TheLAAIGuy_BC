codeunit 50151 "LAAI Time Sheet Entries"
{
    /// <summary>
    /// Puts one LAAI Time Entry on its resource's time sheet as a project line
    /// </summary>
    /// <param name="TimeEntry">The time entry to put on a time sheet</param>
    procedure PutOnTimeSheet(var TimeEntry: Record "LAAI Time Entry")
    var
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetDetail: Record "Time Sheet Detail";
        Hours: Decimal;
        LineNo: Integer;
        IsHandled: Boolean;
        NoTimeSheetErr: Label 'Resource %1 has no time sheet for %2. Run Create Time Sheets for that week first.', Comment = '%1 = resource number, %2 = date';
    begin
        OnBeforePutOnTimeSheet(TimeEntry, IsHandled);
        if IsHandled then
            exit;
        TimeEntry.LockTable();
        TimeEntry.Get(TimeEntry."Entry No.");
        TimeEntry.TestField("Project No.");
        TimeEntry.TestField("Project Task No.");
        TimeEntry.TestField("Resource No.");
        TimeEntry.TestField(Date);
        TimeEntry.TestField(Status, TimeEntry.Status::Open);
        Hours := Round(TimeEntry."Active Minutes" / 60, 0.00001);
        // Already on a time sheet: change that day's hours while the line is Open or
        // Rejected (TestStatus errors otherwise). A line deleted in BC gets a new one.
        if TimeSheetLine.Get(TimeEntry."Time Sheet No.", TimeEntry."Time Sheet Line No.") then begin
            // Verify that the existing time sheet line belongs to the same resource, project and task
            TimeSheetHeader.Get(TimeSheetLine."Time Sheet No.");
            if (TimeSheetHeader."Resource No." <> TimeEntry."Resource No.") or
               (TimeSheetLine."Job No." <> TimeEntry."Project No.") or
               (TimeSheetLine."Job Task No." <> TimeEntry."Project Task No.")
            then
                Error('The existing time sheet line does not belong to the same resource, project and task as this time entry.');
            
            TimeSheetLine.TestStatus();
            TimeSheetDetail.Get(
                TimeSheetLine."Time Sheet No.", TimeSheetLine."Line No.", TimeEntry.Date);
            TimeSheetDetail.Quantity := Hours;
            TimeSheetDetail.Modify(true);
            OnAfterPutOnTimeSheet(TimeEntry);
            exit;
        end;
        TimeSheetHeader.SetRange("Resource No.", TimeEntry."Resource No.");
        TimeSheetHeader.SetRange("Starting Date", 0D, TimeEntry.Date);
        TimeSheetHeader.SetFilter("Ending Date", '>=%1', TimeEntry.Date);
        if not TimeSheetHeader.FindFirst() then
            Error(NoTimeSheetErr, TimeEntry."Resource No.", TimeEntry.Date);
        LineNo := TimeSheetHeader.GetLastLineNo() + 10000;
        TimeSheetLine.Init();
        TimeSheetLine."Time Sheet No." := TimeSheetHeader."No.";
        TimeSheetLine."Line No." := LineNo;
        TimeSheetLine."Time Sheet Starting Date" := TimeSheetHeader."Starting Date";
        TimeSheetLine.Validate(Type, TimeSheetLine.Type::Job);
        TimeSheetLine.Validate("Job No.", TimeEntry."Project No.");
        TimeSheetLine.Validate("Job Task No.", TimeEntry."Project Task No.");
        TimeSheetLine.Insert(true);
        TimeSheetDetail.Init();
        TimeSheetDetail.CopyFromTimeSheetLine(TimeSheetLine);
        TimeSheetDetail.Date := TimeEntry.Date;
        TimeSheetDetail.Quantity := Hours;
        TimeSheetDetail.Insert(true);
        TimeEntry."Time Sheet No." := TimeSheetHeader."No.";
        TimeEntry."Time Sheet Line No." := LineNo;
        TimeEntry.Modify(true);
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
