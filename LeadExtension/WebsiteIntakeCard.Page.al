page 50103 "LAAI Website Intake Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "LAAI Website Intake";
    Caption = 'Website Intake';

    layout
    {
        area(content)
        {
            group(Submission)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; Editable = false; }
                field("Submission Id"; Rec."Submission Id") { ApplicationArea = All; Editable = false; }
                field("Received At"; Rec."Received At") { ApplicationArea = All; Editable = false; }
                field("Schema Version"; Rec."Schema Version") { ApplicationArea = All; Editable = false; }
                field("Source Code"; Rec."Source Code") { ApplicationArea = All; Editable = false; }
                field("Intake Type"; Rec."Intake Type") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
            }
            group(Contact)
            {
                field("First Name"; Rec."First Name") { ApplicationArea = All; }
                field("Last Name"; Rec."Last Name") { ApplicationArea = All; }
                field(Email; Rec.Email) { ApplicationArea = All; }
                field("Phone No."; Rec."Phone No.") { ApplicationArea = All; }
                field("Company Name"; Rec."Company Name") { ApplicationArea = All; }
                field("Company Role"; Rec."Company Role") { ApplicationArea = All; }
                field("Company Size"; Rec."Company Size") { ApplicationArea = All; }
                field("Existing Client"; Rec."Existing Client") { ApplicationArea = All; }
            }
            group(Needs)
            {
                field("AI Maturity"; Rec."AI Maturity") { ApplicationArea = All; }
                field("Service Categories"; Rec."Service Categories") { ApplicationArea = All; }
                field("Current Platforms"; Rec."Current Platforms") { ApplicationArea = All; MultiLine = true; }
                field("Desired Outcome"; Rec."Desired Outcome") { ApplicationArea = All; MultiLine = true; }
                field("Target Timing"; Rec."Target Timing") { ApplicationArea = All; }
            }
            group(NextAction)
            {
                Caption = 'Next Action';
                field("Next Step"; Rec."Next Step") { ApplicationArea = All; }
                field("Meeting Preference"; Rec."Meeting Preference") { ApplicationArea = All; }
                field("Requested Window"; Rec."Requested Window") { ApplicationArea = All; }
                field("Preferred Contact Time"; Rec."Preferred Contact Time") { ApplicationArea = All; }
                field("SOW Required"; Rec."SOW Required") { ApplicationArea = All; }
                field("Flat Fee Available"; Rec."Flat Fee Available") { ApplicationArea = All; }
                field("Lead No."; Rec."Lead No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; Editable = false; }
                field("Sales Quote No."; Rec."Sales Quote No.") { ApplicationArea = All; Editable = false; }
                field("Sales Order No."; Rec."Sales Order No.") { ApplicationArea = All; Editable = false; }
                field("Last Conversion At"; Rec."Last Conversion At") { ApplicationArea = All; Editable = false; }
            }
            group(Details)
            {
                field("Additional Context"; Rec."Additional Context") { ApplicationArea = All; MultiLine = true; }
                field("Raw Submission"; Rec."Raw Submission") { ApplicationArea = All; MultiLine = true; Editable = false; }
                field("Integration Error"; Rec."Integration Error") { ApplicationArea = All; MultiLine = true; Editable = false; }
                field("Processed At"; Rec."Processed At") { ApplicationArea = All; Editable = false; }
            }
            part(ConversionEvents; "LAAI Intake Event ListPart")
            {
                ApplicationArea = All;
                Caption = 'Conversion Events';
                SubPageLink = "Intake Entry No." = field("Entry No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateLead)
            {
                ApplicationArea = All;
                Caption = 'Create Lead';
                Enabled = (not Rec."Existing Client") and (Rec."Lead No." = '');
                Image = NewCustomer;
                ToolTip = 'Create a lead from this reviewed website intake.';

                trigger OnAction()
                var
                    IntakeMgt: Codeunit "LAAI Website Intake Mgt";
                begin
                    IntakeMgt.CreateLead(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(ConvertLeadToCustomer)
            {
                ApplicationArea = All;
                Caption = 'Convert Lead to Customer';
                Enabled = (not Rec."Existing Client") and (Rec."Lead No." <> '') and (Rec."Customer No." = '');
                Image = Customer;
                ToolTip = 'Use the existing lead conversion function and link the resulting customer to this intake.';

                trigger OnAction()
                var
                    IntakeMgt: Codeunit "LAAI Website Intake Mgt";
                begin
                    IntakeMgt.ConvertLeadToCustomer(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(LinkExistingCustomer)
            {
                ApplicationArea = All;
                Caption = 'Link Existing Customer';
                Enabled = Rec."Existing Client" and (Rec."Customer No." = '');
                Image = LinkAccount;
                ToolTip = 'Select and link the existing Business Central customer without creating a lead.';

                trigger OnAction()
                var
                    IntakeMgt: Codeunit "LAAI Website Intake Mgt";
                begin
                    IntakeMgt.LinkExistingCustomer(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CreateOpenQuote)
            {
                ApplicationArea = All;
                Caption = 'Create Open Sales Quote';
                Enabled = (Rec."Customer No." <> '') and (Rec."Sales Quote No." = '');
                Image = Quote;
                ToolTip = 'Create an open sales quote for review and approval in Business Central.';

                trigger OnAction()
                var
                    IntakeMgt: Codeunit "LAAI Website Intake Mgt";
                begin
                    IntakeMgt.CreateOpenSalesQuote(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CreateOpenOrder)
            {
                ApplicationArea = All;
                Caption = 'Create Open Sales Order';
                Enabled = (Rec."Sales Quote No." <> '') and (Rec."Sales Order No." = '');
                Image = MakeOrder;
                ToolTip = 'Convert the reviewed and released quote into an open sales order.';

                trigger OnAction()
                var
                    IntakeMgt: Codeunit "LAAI Website Intake Mgt";
                begin
                    IntakeMgt.CreateOpenSalesOrder(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
