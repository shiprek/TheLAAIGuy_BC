codeunit 50150 "LAAI Post Time Entries"
{
    InherentEntitlements = X;
    InherentPermissions = X;

    trigger OnRun()
    begin
    end;

    procedure PostTimeEntry(var Rec: Record "LAAI Time Entry")
    var
        IsHandled: Boolean;
        JobJnlLine: Record "Job Journal Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        JobLedgerEntryNo: Integer;
    begin
        // Trigger OnBefore event
        OnBeforePostTimeEntry(Rec, IsHandled);
        if IsHandled then
            exit;

        // Validate that the entry is not already posted
        Rec.TestField(Status, Rec.Status::Open);

        // Initialize job journal line
        JobJnlLine.Init();
        JobJnlLine.Validate("Job No.", Rec."Project No.");
        JobJnlLine.Validate("Job Task No.", Rec."Project Task No.");
        JobJnlLine.Validate(Type, JobJnlLine.Type::Resource);
        JobJnlLine.Validate("No.", Rec."Resource No.");
        JobJnlLine.Validate("Work Type Code", Rec."Work Type");

        // Calculate quantity in hours
        JobJnlLine.Quantity := Round(Rec."Active Minutes" / 60, 0.01);
        
        // Set other fields
        JobJnlLine."Posting Date" := Rec.Date;
        JobJnlLine."Document No." := Format(Rec."Entry No.");
        JobJnlLine.Description := Rec.Description;

        // Set line type based on billable flag
        if Rec.Billable then
            JobJnlLine.Validate("Line Type", JobJnlLine."Line Type"::Billable)
        else
            JobJnlLine.Validate("Line Type", JobJnlLine."Line Type"::" ");

        // Post the job journal line
        JobLedgerEntryNo := JobJnlPostLine.RunWithCheck(JobJnlLine);

        // Update the time entry with posted information
        Rec."Posted Entry No." := JobLedgerEntryNo;
        Rec.Status := Rec.Status::Posted;
        Rec.Modify(true);

        // Trigger OnAfter event
        OnAfterPostTimeEntry(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostTimeEntry(var Rec: Record "LAAI Time Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostTimeEntry(var Rec: Record "LAAI Time Entry")
    begin
    end;
}
