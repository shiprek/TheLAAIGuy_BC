page 50100 "LAAI Lead Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "LAAI Lead";
    Caption = 'Lead Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead number. Leave blank to auto-assign.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the lead contact.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company the lead represents.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the lead.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the phone number of the lead.';
                }
            }
            group(SalesDetails)
            {
                Caption = 'Sales Details';

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the lead.';
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies where the lead originated from.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salesperson responsible for this lead.';
                }
                field("Estimated Value"; Rec."Estimated Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the estimated deal value of the lead.';
                }
                field("Expected Close Date"; Rec."Expected Close Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected date the deal will close.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the lead was created.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer this lead was converted to, if any.';
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact created for this lead, if any.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ConvertToCustomer)
            {
                ApplicationArea = All;
                Caption = 'Convert to Customer';
                Image = ConvertCustomer;
                Enabled = Rec."Customer No." = '';
                ToolTip = 'Create a new customer from this lead''s details.';

                trigger OnAction()
                var
                    LeadToCustomerMgt: Codeunit "LAAI Lead-to-Customer Mgt";
                begin
                    LeadToCustomerMgt.ConvertToCustomer(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ViewCustomer)
            {
                ApplicationArea = All;
                Caption = 'View Customer';
                Image = Customer;
                Enabled = Rec."Customer No." <> '';
                ToolTip = 'Open the customer this lead was converted to.';

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."Customer No.") then
                        Page.Run(Page::"Customer Card", Customer);
                end;
            }
            action(ViewContact)
            {
                ApplicationArea = All;
                Caption = 'View Contact';
                Image = ContactPerson;
                Enabled = Rec."Contact No." <> '';
                ToolTip = 'Open the contact created for this lead.';

                trigger OnAction()
                var
                    Contact: Record Contact;
                begin
                    if Contact.Get(Rec."Contact No.") then
                        Page.Run(Page::"Contact Card", Contact);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ConvertToCustomer_Promoted; ConvertToCustomer)
                {
                }
                actionref(ViewCustomer_Promoted; ViewCustomer)
                {
                }
                actionref(ViewContact_Promoted; ViewContact)
                {
                }
            }
        }
    }
}
