codeunit 50150 "LAAI Post Time Entries"
{
    [IntegrationEvent(false, false)]
    local procedure OnBeforePostTimeEntry(var TimeEntry: Record "LAAI Time Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostTimeEntry(var TimeEntry: Record "LAAI Time Entry")
    begin
    end;

    procedure PostTimeEntry(var TimeEntry: Record "LAAI Time Entry")
    var
        JobJnlLine: Record "Job Journal Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        IsHandled: Boolean;
    begin
        // Raise OnBefore event
        OnBeforePostTimeEntry(TimeEntry, IsHandled);
        if IsHandled then
            exit;

        // Validate that the time entry is not already posted
        if TimeEntry.Status = TimeEntry.Status::Posted then
            Error('This time entry is already posted.');

        // Initialize job journal line
        JobJnlLine.Init();
        JobJnlLine."Job No." := TimeEntry."Project No.";
        JobJnlLine."Job Task No." := TimeEntry."Project Task No.";
        JobJnlLine.Type := JobJnlLine.Type::Resource;
        JobJnlLine."No." := TimeEntry."Resource No.";
        JobJnlLine."Work Type Code" := TimeEntry."Work Type";
        JobJnlLine.Quantity := Round(TimeEntry."Active Minutes" / 60, 0.01);
        JobJnlLine."Posting Date" := TimeEntry.Date;
        JobJnlLine."Document No." := Format(TimeEntry."Entry No.");
        JobJnlLine.Description := TimeEntry.Description;

        // Set line type based on billable status
        if TimeEntry.Billable then
            JobJnlLine."Line Type" := JobJnlLine."Line Type"::Billable
        else
            JobJnlLine."Line Type" := JobJnlLine."Line Type"::Usage;

        // Post the job journal line
        JobJnlPostLine.RunWithCheck(JobJnlLine);

        // Update time entry status to Posted and set posted entry number
        TimeEntry.Status := TimeEntry.Status::Posted;
        TimeEntry."Posted Entry No." := JobJnlLine."Job Ledger Entry No.";
        TimeEntry.Modify(true);

        // Raise OnAfter event
        OnAfterPostTimeEntry(TimeEntry);
    end;
}
