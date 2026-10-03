table 50200 "LAAI JimEntity"
{
    Caption = 'Jim Entity';
    DataPerCompany = false;
    fields
    {
        field(1; "SystemId"; Guid)
        {
            Caption = 'System Id';
            DataClassification = SystemMetadata;
        }
        field(10; "Name"; Code[20])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(20; "Status"; Enum "LAAI JimEntity Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "SystemId")
        {
            Clustered = true;
        }
    }
}
