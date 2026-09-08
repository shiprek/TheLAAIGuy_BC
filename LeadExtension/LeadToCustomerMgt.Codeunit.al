codeunit 50103 "LAAI Lead-to-Customer Mgt"
{
    // Creates a new Customer from a Lead, along with:
    //   - a Company Contact (from the lead's Company Name, or the lead's own
    //     Name if no company was given)
    //   - a Person Contact (from the lead's Name) linked under that company,
    //     only when the lead actually has a separate company name
    // The company contact is linked to the customer via the standard
    // Contact Business Relation table, and the customer's Primary Contact No.
    // is set to the most specific contact (person if one was created,
    // otherwise the company). Marks the Lead as converted so it can't be
    // converted twice.
    //
    // No. Series: Customer and Contact both auto-assign their own "No."
    // on Insert(true) using the series configured in Sales & Receivables
    // Setup / Marketing Setup respectively - no manual No. Series call needed.
    // Creates a standalone Person contact directly from a lead's intake
    // fields (Name, Company Name as free text, Email, Phone), for tracking
    // a lead in the CRM before any sale happens. If the lead is later
    // converted to a customer, ConvertToCustomer reuses this contact
    // instead of creating a duplicate.
    procedure CreateContact(var LeadRec: Record "LAAI Lead")
    var
        PersonContact: Record Contact;
    begin
        if LeadRec."Contact No." <> '' then
            Error(ContactAlreadyExistsErr, LeadRec."No.", LeadRec."Contact No.");

        PersonContact.Init();
        PersonContact.Validate(Type, PersonContact.Type::Person);
        PersonContact.Validate(Name, LeadRec.Name);
        if LeadRec."Company Name" <> '' then
            PersonContact.Validate("Company Name", LeadRec."Company Name");
        PersonContact.Validate("E-Mail", LeadRec.Email);
        PersonContact.Validate("Phone No.", LeadRec."Phone No.");
        PersonContact.Insert(true);

        LeadRec."Contact No." := PersonContact."No.";
        LeadRec.Modify(true);

        Message(ContactCreatedMsg, LeadRec."No.", PersonContact."No.");
    end;

    procedure ConvertToCustomer(var LeadRec: Record "LAAI Lead")
    var
        Customer: Record Customer;
        CompanyContact: Record Contact;
        PersonContact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        MarketingSetup: Record "Marketing Setup";
        CustomerName: Text[100];
        PrimaryContactNo: Code[20];
        CreatePersonContact: Boolean;
    begin
        if LeadRec."Customer No." <> '' then
            Error(AlreadyConvertedErr, LeadRec."No.", LeadRec."Customer No.");

        if not Confirm(ConfirmConvertQst, true, LeadRec."No.") then
            exit;

        if LeadRec."Company Name" <> '' then
            CustomerName := LeadRec."Company Name"
        else
            CustomerName := LeadRec.Name;
        CreatePersonContact := LeadRec."Company Name" <> '';

        if LeadRec."Contact No." <> '' then begin
            // A contact was already created from intake - reuse it instead
            // of creating a duplicate.
            PersonContact.Get(LeadRec."Contact No.");
            if CreatePersonContact then begin
                CompanyContact.Init();
                CompanyContact.Validate(Type, CompanyContact.Type::Company);
                CompanyContact.Validate(Name, CustomerName);
                CompanyContact.Validate("E-Mail", LeadRec.Email);
                CompanyContact.Validate("Phone No.", LeadRec."Phone No.");
                CompanyContact.Insert(true);
                PersonContact.Validate("Company No.", CompanyContact."No.");
                PersonContact.Modify(true);
                PrimaryContactNo := PersonContact."No.";
            end else begin
                CompanyContact := PersonContact;
                PrimaryContactNo := PersonContact."No.";
            end;
        end else begin
            // 1) Company contact (always created - represents the customer's org)
            CompanyContact.Init();
            CompanyContact.Validate(Type, CompanyContact.Type::Company);
            CompanyContact.Validate(Name, CustomerName);
            CompanyContact.Validate("E-Mail", LeadRec.Email);
            CompanyContact.Validate("Phone No.", LeadRec."Phone No.");
            CompanyContact.Insert(true);
            PrimaryContactNo := CompanyContact."No.";

            // 2) Person contact (only when the lead names an individual at a company)
            if CreatePersonContact then begin
                PersonContact.Init();
                PersonContact.Validate(Type, PersonContact.Type::Person);
                PersonContact.Validate(Name, LeadRec.Name);
                PersonContact.Validate("Company No.", CompanyContact."No.");
                PersonContact.Validate("E-Mail", LeadRec.Email);
                PersonContact.Validate("Phone No.", LeadRec."Phone No.");
                PersonContact.Insert(true);
                PrimaryContactNo := PersonContact."No.";
            end;
        end;

        // 3) Customer
        Customer.Init();
        Customer.Validate(Name, CustomerName);
        Customer.Validate("E-Mail", LeadRec.Email);
        Customer.Validate("Phone No.", LeadRec."Phone No.");
        Customer.Validate("Salesperson Code", LeadRec."Salesperson Code");
        Customer.Insert(true);

        // 4) Link the company contact to the customer (standard CRM relation)
        MarketingSetup.Get();
        MarketingSetup.TestField("Bus. Rel. Code for Customers");

        ContactBusinessRelation.Init();
        ContactBusinessRelation."Contact No." := CompanyContact."No.";
        ContactBusinessRelation."Business Relation Code" := MarketingSetup."Bus. Rel. Code for Customers";
        ContactBusinessRelation."Link to Table" := ContactBusinessRelation."Link to Table"::Customer;
        ContactBusinessRelation."No." := Customer."No.";
        ContactBusinessRelation.Insert(true);

        Customer.Validate("Primary Contact No.", PrimaryContactNo);
        Customer.Modify(true);

        // 5) Update the lead
        LeadRec."Customer No." := Customer."No.";
        LeadRec."Contact No." := PrimaryContactNo;
        LeadRec.Status := LeadRec.Status::Won;
        LeadRec.Modify(true);

        Message(ConversionDoneMsg, LeadRec."No.", Customer."No.", PrimaryContactNo);
    end;

    var
        ConfirmConvertQst: Label 'Do you want to convert lead %1 into a new customer and contact?', Comment = '%1 = Lead No.';
        ConversionDoneMsg: Label 'Lead %1 has been converted to customer %2 (contact %3).', Comment = '%1 = Lead No., %2 = Customer No., %3 = Contact No.';
        AlreadyConvertedErr: Label 'Lead %1 has already been converted to customer %2.', Comment = '%1 = Lead No., %2 = Customer No.';
        ContactCreatedMsg: Label 'A contact has been created for lead %1 (contact %2).', Comment = '%1 = Lead No., %2 = Contact No.';
        ContactAlreadyExistsErr: Label 'Lead %1 already has a contact (%2).', Comment = '%1 = Lead No., %2 = Contact No.';
}
