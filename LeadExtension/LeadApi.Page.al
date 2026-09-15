page 50108 "LAAI Lead API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'leads';
    APIVersion = 'v1.0';
    EntityName = 'lead';
    EntitySetName = 'leads';
    EntityCaption = 'Lead';
    EntitySetCaption = 'Leads';
    SourceTable = "LAAI Lead";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId) { Caption = 'Id'; Editable = false; }
                field(no; Rec."No.") { Caption = 'No.'; Editable = false; }
                field(name; Rec.Name) { Caption = 'Name'; }
                field(companyName; Rec."Company Name") { Caption = 'Company Name'; }
                field(email; Rec.Email) { Caption = 'Email'; }
                field(phoneNo; Rec."Phone No.") { Caption = 'Phone No.'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(source; Rec.Source) { Caption = 'Source'; }
                field(salespersonCode; Rec."Salesperson Code") { Caption = 'Salesperson Code'; }
                field(estimatedValue; Rec."Estimated Value") { Caption = 'Estimated Value'; }
                field(expectedCloseDate; Rec."Expected Close Date") { Caption = 'Expected Close Date'; }
                field(notes; Rec.Notes) { Caption = 'Notes'; }
                field(contactedDate; Rec."Contacted Date") { Caption = 'Contacted Date'; }
                field(createdDate; Rec."Created Date") { Caption = 'Created Date'; Editable = false; }
                field(customerNo; Rec."Customer No.") { Caption = 'Customer No.'; Editable = false; }
                field(contactNo; Rec."Contact No.") { Caption = 'Contact No.'; Editable = false; }
            }
        }
    }
}
