// Adds a "Leads" tile to the Business Manager Role Center so it shows up
// on the main navigation bar the same way Customers/Vendors do.
// If your users work from a different Role Center (Sales, CRM, etc.),
// change "Business Manager Role Center" to that page's name and adjust
// addafter(...) to an action that actually exists there.
pageextension 50102 "LAAI Lead RC Ext" extends "Business Manager Role Center"
{
    actions
    {
        addafter(Customers)
        {
            action(Leads)
            {
                ApplicationArea = All;
                Caption = 'Leads';
                Image = Contact;
                RunObject = page "LAAI Lead List";
                ToolTip = 'View and manage sales leads.';
            }
        }
    }
}
