table 50200 "LAAI Jim's Entity"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "SystemId"; Guid) { AutoIncrement = true; }
        field(2; "jim1"; Text[100]) { DataClassification = CustomerContent; }
        field(3; "jim2"; Text[100]) { DataClassification = CustomerContent; }
        field(4; "jim3"; Text[100]) { DataClassification = CustomerContent; }
    }
    keys
    {
        key(PK; "SystemId") { Clustered = true; }
    }
}
