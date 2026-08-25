page 50101 "LAAI Lead List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LAAI Lead";
    CardPageId = "LAAI Lead Card";
    Caption = 'Leads';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(Source; Rec.Source)
                {
                    ApplicationArea = All;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                }
                field("Estimated Value"; Rec."Estimated Value")
                {
                    ApplicationArea = All;
                }
                field("Expected Close Date"; Rec."Expected Close Date")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(OpenLeadCard)
            {
                ApplicationArea = All;
                Caption = 'Lead Details';
                Image = ViewDetails;
                RunObject = page "LAAI Lead Card";
                RunPageLink = "No." = field("No.");
                ToolTip = 'Open the full details for the selected lead.';
            }
        }
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
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ConvertToCustomer_Promoted; ConvertToCustomer)
                {
                }
                actionref(OpenLeadCard_Promoted; OpenLeadCard)
                {
                }
            }
        }
    }
}
