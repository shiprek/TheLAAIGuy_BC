codeunit 50150 "LAAI Post Time Entries"
{
    TableNo = "LAAI Time Entry";

    trigger OnRun()
    begin
    end;

    procedure PostTimeEntry(var Rec: Record "LAAI Time Entry")
    var
        JobJnlLine: Record "Job Journal Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        IsHandled: Boolean;
    begin
        OnBeforePostTimeEntry(Rec, IsHandled);
        if IsHandled then
            exit;

        Rec.TestField(Status, Rec.Status::Open);

        JobJnlLine.Init();
        JobJnlLine.Validate("Posting Date", Rec.Date);
        JobJnlLine.Validate("Job No.", Rec."Project No.");
        JobJnlLine.Validate("Job Task No.", Rec."Project Task No.");
        JobJnlLine.Validate(Type, JobJnlLine.Type::Resource);
        JobJnlLine.Validate("No.", Rec."Resource No.");
        JobJnlLine.Validate("Work Type Code", Rec."Work Type");
        JobJnlLine.Validate(Quantity, Round(Rec."Active Minutes" / 60, 0.01));
        if Rec.Billable then
            JobJnlLine.Validate("Line Type", JobJnlLine."Line Type"::Billable);
        JobJnlLine."Document No." := Format(Rec."Entry No.");
        JobJnlLine.Description := Rec.Description;

        if JobJnlPostLine.RunWithCheck(JobJnlLine) then begin
            JobLedgerEntry.SetRange("Job No.", Rec."Project No.");
            JobLedgerEntry.SetFilter("Job Task No.", Rec."Project Task No.");
            JobLedgerEntry.SetFilter("Posting Date", Format(Rec.Date));
            JobLedgerEntry.SetFilter("Document No.", Format(Rec."Entry No."));
            if JobLedgerEntry.FindLast() then begin
                Rec.Status := Rec.Status::Posted;
                Rec."Posted Entry No." := JobLedgerEntry."Entry No.";
                Rec.Modify(true);
            end;
        end;

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
