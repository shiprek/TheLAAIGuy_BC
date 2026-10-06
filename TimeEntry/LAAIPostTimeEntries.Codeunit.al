codeunit 50150 "LAAI Post Time Entries"
{
    trigger OnRun()
    begin
    end;

    procedure Post(var TimeEntry: Record "LAAI Time Entry")
    var
        JobJnlLine: Record "Job Journal Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        IsHandled: Boolean;
    begin
        OnBeforePost(TimeEntry, IsHandled);
        if IsHandled then
            exit;
        TimeEntry.LockTable();
        TimeEntry.Get(TimeEntry."Entry No.");
        TimeEntry.TestField(Status, TimeEntry.Status::Open);
        TimeEntry.TestField("Project No.");
        TimeEntry.TestField("Project Task No.");
        TimeEntry.TestField("Resource No.");
        JobJnlLine.Init();
        JobJnlLine.Validate("Posting Date", TimeEntry.Date);
        JobJnlLine.Validate("Job No.", TimeEntry."Project No.");
        JobJnlLine.Validate("Job Task No.", TimeEntry."Project Task No.");
        JobJnlLine.Validate(Type, JobJnlLine.Type::Resource);
        JobJnlLine.Validate("No.", TimeEntry."Resource No.");
        JobJnlLine.Validate("Work Type Code", TimeEntry."Work Type");
        JobJnlLine.Validate(Quantity, Round(TimeEntry."Active Minutes" / 60, 0.00001));
        if TimeEntry.Billable then
            JobJnlLine.Validate("Line Type", JobJnlLine."Line Type"::Billable);
        JobJnlLine."Document No." := Format(TimeEntry."Entry No.");
        JobJnlLine.Description := TimeEntry.Description;
        TimeEntry."Posted Entry No." := JobJnlPostLine.RunWithCheck(JobJnlLine);
        TimeEntry.Status := TimeEntry.Status::Posted;
        TimeEntry.Modify(true);
        OnAfterPost(TimeEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePost(var TimeEntry: Record "LAAI Time Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPost(var TimeEntry: Record "LAAI Time Entry")
    begin
    end;
}
