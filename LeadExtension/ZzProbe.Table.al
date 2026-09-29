table 50149 "LAAI Probe"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20]) { }
        field(2; "Discount Percent"; Decimal) { ExtendedDatatype = Percentage; }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
    }
}
