codeunit 50150 "LAAI Post Time Entries"
{
    /// <summary>
    /// Posts a time entry to its project through the job journal.
    /// </summary>
    /// <param name="Rec">The time entry record to post.</param>
    procedure PostTimeEntry(var Rec: Record "LAAI Time Entry")
    var
        JobJnlLine: Record "Job Journal Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        JobLedgerEntryNo: Integer;
        IsHandled: Boolean;
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
        JobJnlLine.Validate(Quantity, Round(Rec."Active Minutes" / 60, 0.01));
        JobJnlLine.Validate("Line Type", 
            if Rec.Billable then JobJnlLine."Line Type"::Billable else JobJnlLine."Line Type"::" ");
        JobJnlLine.Validate("Posting Date", Rec.Date);
        JobJnlLine.Validate("Document No.", Format(Rec."Entry No."));
        JobJnlLine.Validate(Description, Rec.Description);

        // Post the job journal line
        JobLedgerEntryNo := JobJnlPostLine.RunWithCheck(JobJnlLine);

        // Update the time entry with posted status and entry number
        Rec.Status := Rec.Status::Posted;
        Rec."Posted Entry No." := JobLedgerEntryNo;
        Rec.Modify(true);

        // Trigger OnAfter event
        OnAfterPostTimeEntry(Rec);
    end;

    /// <summary>
    /// Integration event triggered before posting a time entry.
    /// </summary>
    /// <param name="Rec">The time entry record being posted.</param>
    /// <param name="IsHandled">Indicates if the event was handled.</param>
    [IntegrationEvent(false, false)]
    local procedure OnBeforePostTimeEntry(var Rec: Record "LAAI Time Entry"; var IsHandled: Boolean)
    begin
    end;

    /// <summary>
    /// Integration event triggered after posting a time entry.
    /// </summary>
    /// <param name="Rec">The time entry record that was posted.</param>
    [IntegrationEvent(false, false)]
    local procedure OnAfterPostTimeEntry(var Rec: Record "LAAI Time Entry")
    begin
    end;
}
