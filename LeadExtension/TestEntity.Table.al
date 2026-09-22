// TEMPORARY - second validation test for the coder-agent-pool design
// (AGENT-015), this time a brand-new custom table rather than an extension
// of a system table (see the reverted Company tableextension test). To be
// reverted (this file deleted) once confirmed - see backlog AGENT-015/
// AGENT-010 for context.
table 50110 "LAAI Test Entity"
{
    Caption = 'Test Entity';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item Name"; Text[50])
        {
            Caption = 'Item Name';
        }
        field(2; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(3; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(4; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(5; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
        }
    }

    keys
    {
        key(PK; "Item Name")
        {
            Clustered = true;
        }
    }
}
