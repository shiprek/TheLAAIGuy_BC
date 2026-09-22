// TEMPORARY - validation test for the coder-agent-pool design (AGENT-015).
// Adds one throwaway field to confirm the BC Agent -> BC Agent Coder ->
// GitHub PR -> DEV pipeline works end to end. To be reverted (this file
// deleted) once confirmed - see backlog AGENT-015/AGENT-010 for context.
tableextension 50110 "LAAI TEMP Company Test" extends Company
{
    fields
    {
        field(50100; "Referral Source"; Text[100])
        {
            Caption = 'Referral Source';
            DataClassification = CustomerContent;
        }
    }
}
