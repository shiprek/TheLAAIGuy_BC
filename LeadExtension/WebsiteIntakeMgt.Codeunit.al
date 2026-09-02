codeunit 50104 "LAAI Website Intake Mgt"
{
    procedure CreateLead(var Intake: Record "LAAI Website Intake")
    var
        Lead: Record "LAAI Lead";
        IsHandled: Boolean;
    begin
        if Intake."Existing Client" then
            Error(ExistingClientLeadErr);
        Intake.TestField("Lead No.", '');
        Intake.TestField("First Name");
        Intake.TestField(Email);

        OnBeforeCreateLead(Intake, Lead, IsHandled);
        if not IsHandled then begin
            Lead.Init();
            Lead.Validate(Name, CopyStr(Intake."First Name" + ' ' + Intake."Last Name", 1, MaxStrLen(Lead.Name)));
            Lead.Validate("Company Name", Intake."Company Name");
            Lead.Validate(Email, Intake.Email);
            Lead.Validate("Phone No.", Intake."Phone No.");
            Lead.Validate(Source, Lead.Source::Web);
            Lead.Validate(Status, Lead.Status::New);
            Lead.Insert(true);
        end;

        Intake."Lead No." := Lead."No.";
        Intake.Status := Intake.Status::Qualified;
        Intake."Last Conversion At" := CurrentDateTime();
        Intake.Modify(true);
        LogEvent(Intake, "LAAI Intake Event Type"::"Lead Created", 'Lead created from reviewed website intake.');
        OnAfterCreateLead(Intake, Lead);
    end;

    procedure ConvertLeadToCustomer(var Intake: Record "LAAI Website Intake")
    var
        Lead: Record "LAAI Lead";
        LeadToCustomerMgt: Codeunit "LAAI Lead-to-Customer Mgt";
        IsHandled: Boolean;
    begin
        if Intake."Existing Client" then
            Error(ExistingClientLeadErr);
        Intake.TestField("Lead No.");
        Intake.TestField("Customer No.", '');
        Lead.Get(Intake."Lead No.");

        OnBeforeConvertLeadToCustomer(Intake, Lead, IsHandled);
        if not IsHandled then
            LeadToCustomerMgt.ConvertToCustomer(Lead);
        if Lead."Customer No." = '' then
            exit;

        Intake."Customer No." := Lead."Customer No.";
        Intake."Last Conversion At" := CurrentDateTime();
        Intake.Modify(true);
        LogEvent(Intake, "LAAI Intake Event Type"::"Customer Created", 'Customer created through the existing lead conversion function.');
        OnAfterConvertLeadToCustomer(Intake, Lead);
    end;

    procedure LinkExistingCustomer(var Intake: Record "LAAI Website Intake")
    var
        Customer: Record Customer;
        IsHandled: Boolean;
    begin
        if not Intake."Existing Client" then
            Error(NotExistingClientErr);
        Intake.TestField("Customer No.", '');

        OnBeforeLinkExistingCustomer(Intake, Customer, IsHandled);
        if not IsHandled then
            if Page.RunModal(Page::"Customer List", Customer) <> Action::LookupOK then
                exit;

        Customer.TestField("No.");
        Intake.Validate("Customer No.", Customer."No.");
        Intake.Status := Intake.Status::Qualified;
        Intake."Last Conversion At" := CurrentDateTime();
        Intake.Modify(true);
        LogEvent(Intake, "LAAI Intake Event Type"::"Existing Customer Linked", 'Existing customer manually linked to the website intake.');
        OnAfterLinkExistingCustomer(Intake, Customer);
    end;

    procedure CreateOpenSalesQuote(var Intake: Record "LAAI Website Intake")
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        IsHandled: Boolean;
    begin
        Intake.TestField("Customer No.");
        Intake.TestField("Sales Quote No.", '');

        OnBeforeCreateOpenSalesQuote(Intake, SalesHeader, IsHandled);
        if not IsHandled then begin
            SalesHeader.Init();
            SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
            SalesHeader.Insert(true);
            SalesHeader.Validate("Sell-to Customer No.", Intake."Customer No.");
            SalesHeader.Validate("Your Reference", CopyStr('Website intake ' + Format(Intake."Entry No."), 1, MaxStrLen(SalesHeader."Your Reference")));
            SalesHeader."LAAI Website Origin" := true;
            SalesHeader."LAAI Intake Entry No." := Intake."Entry No.";
            SalesHeader."LAAI Submission Id" := Intake."Submission Id";
            SalesHeader.Status := SalesHeader.Status::Open;
            SalesHeader.Modify(true);

            SalesLine.Init();
            SalesLine."Document Type" := SalesHeader."Document Type";
            SalesLine."Document No." := SalesHeader."No.";
            SalesLine."Line No." := 10000;
            SalesLine.Type := SalesLine.Type::" ";
            SalesLine.Description := CopyStr('Website intake ' + Format(Intake."Entry No.") + ' - review scope and pricing', 1, MaxStrLen(SalesLine.Description));
            SalesLine.Insert(true);
        end;

        Intake."Sales Quote No." := SalesHeader."No.";
        Intake.Status := Intake.Status::"SOW Draft";
        Intake."Last Conversion At" := CurrentDateTime();
        Intake.Modify(true);
        LogEvent(Intake, "LAAI Intake Event Type"::"Sales Quote Created", 'Open sales quote created for BC review and approval.');
        OnAfterCreateOpenSalesQuote(Intake, SalesHeader);
    end;

    procedure CreateOpenSalesOrder(var Intake: Record "LAAI Website Intake")
    var
        QuoteHeader: Record "Sales Header";
        OrderHeader: Record "Sales Header";
        QuoteToOrder: Codeunit "Sales-Quote to Order";
        IsHandled: Boolean;
    begin
        Intake.TestField("Sales Quote No.");
        Intake.TestField("Sales Order No.", '');
        QuoteHeader.Get(QuoteHeader."Document Type"::Quote, Intake."Sales Quote No.");
        QuoteHeader.TestField(Status, QuoteHeader.Status::Released);

        OnBeforeCreateOpenSalesOrder(Intake, QuoteHeader, IsHandled);
        if not IsHandled then begin
            QuoteToOrder.Run(QuoteHeader);
            QuoteToOrder.GetSalesOrderHeader(OrderHeader);
        end;

        OrderHeader.Status := OrderHeader.Status::Open;
        OrderHeader."LAAI Website Origin" := true;
        OrderHeader."LAAI Intake Entry No." := Intake."Entry No.";
        OrderHeader."LAAI Submission Id" := Intake."Submission Id";
        OrderHeader.Modify(true);
        Intake."Sales Order No." := OrderHeader."No.";
        Intake.Status := Intake.Status::"SOW Approved";
        Intake."Last Conversion At" := CurrentDateTime();
        Intake.Modify(true);
        LogEvent(Intake, "LAAI Intake Event Type"::"Sales Order Created", 'Released quote converted to an open sales order for BC review.');
        OnAfterCreateOpenSalesOrder(Intake, QuoteHeader, OrderHeader);
    end;

    local procedure LogEvent(Intake: Record "LAAI Website Intake"; EventType: Enum "LAAI Intake Event Type"; EventDetails: Text)
    var
        IntakeEvent: Record "LAAI Intake Event";
    begin
        IntakeEvent.Init();
        IntakeEvent."Intake Entry No." := Intake."Entry No.";
        IntakeEvent."Submission Id" := Intake."Submission Id";
        IntakeEvent."Event Type" := EventType;
        IntakeEvent."Occurred At" := CurrentDateTime();
        IntakeEvent."User Id" := CopyStr(UserId(), 1, MaxStrLen(IntakeEvent."User Id"));
        IntakeEvent."Lead No." := Intake."Lead No.";
        IntakeEvent."Customer No." := Intake."Customer No.";
        IntakeEvent."Sales Quote No." := Intake."Sales Quote No.";
        IntakeEvent."Sales Order No." := Intake."Sales Order No.";
        IntakeEvent.Details := CopyStr(EventDetails, 1, MaxStrLen(IntakeEvent.Details));
        IntakeEvent.Insert(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateLead(var Intake: Record "LAAI Website Intake"; var Lead: Record "LAAI Lead"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateLead(var Intake: Record "LAAI Website Intake"; Lead: Record "LAAI Lead")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConvertLeadToCustomer(var Intake: Record "LAAI Website Intake"; var Lead: Record "LAAI Lead"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterConvertLeadToCustomer(var Intake: Record "LAAI Website Intake"; Lead: Record "LAAI Lead")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLinkExistingCustomer(var Intake: Record "LAAI Website Intake"; var Customer: Record Customer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLinkExistingCustomer(var Intake: Record "LAAI Website Intake"; Customer: Record Customer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateOpenSalesQuote(var Intake: Record "LAAI Website Intake"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateOpenSalesQuote(var Intake: Record "LAAI Website Intake"; SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateOpenSalesOrder(var Intake: Record "LAAI Website Intake"; var QuoteHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateOpenSalesOrder(var Intake: Record "LAAI Website Intake"; QuoteHeader: Record "Sales Header"; OrderHeader: Record "Sales Header")
    begin
    end;

    var
        ExistingClientLeadErr: Label 'An existing client must be linked directly to an existing customer; do not create or convert a lead.';
        NotExistingClientErr: Label 'This action is only available when Existing Client is selected.';
}
