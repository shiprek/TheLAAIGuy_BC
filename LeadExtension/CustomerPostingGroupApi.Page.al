page 50107 "LAAI Customer Posting Grp API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'config';
    APIVersion = 'v1.0';
    EntityName = 'customerPostingGroup';
    EntitySetName = 'customerPostingGroups';
    EntityCaption = 'Customer Posting Group';
    EntitySetCaption = 'Customer Posting Groups';
    SourceTable = "Customer Posting Group";
    ODataKeyFields = Code;
    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(code; Rec.Code) { Caption = 'Code'; }
                field(description; Rec.Description) { Caption = 'Description'; }
                field(receivablesAccount; Rec."Receivables Account") { Caption = 'Receivables Account'; }
                field(serviceChargeAcc; Rec."Service Charge Acc.") { Caption = 'Service Charge Acc.'; }
                field(paymentDiscDebitAcc; Rec."Payment Disc. Debit Acc.") { Caption = 'Payment Disc. Debit Acc.'; }
                field(paymentDiscCreditAcc; Rec."Payment Disc. Credit Acc.") { Caption = 'Payment Disc. Credit Acc.'; }
                field(interestAccount; Rec."Interest Account") { Caption = 'Interest Account'; }
                field(additionalFeeAccount; Rec."Additional Fee Account") { Caption = 'Additional Fee Account'; }
                field(addFeePerLineAccount; Rec."Add. Fee per Line Account") { Caption = 'Add. Fee per Line Account'; }
                field(invoiceRoundingAccount; Rec."Invoice Rounding Account") { Caption = 'Invoice Rounding Account'; }
                field(debitRoundingAccount; Rec."Debit Rounding Account") { Caption = 'Debit Rounding Account'; }
                field(creditRoundingAccount; Rec."Credit Rounding Account") { Caption = 'Credit Rounding Account'; }
                field(debitApplnRndgAcc; Rec."Debit Curr. Appln. Rndg. Acc.") { Caption = 'Debit Curr. Appln. Rndg. Acc.'; }
                field(creditApplnRndgAcc; Rec."Credit Curr. Appln. Rndg. Acc.") { Caption = 'Credit Curr. Appln. Rndg. Acc.'; }
                field(paymentToleranceDebitAcc; Rec."Payment Tolerance Debit Acc.") { Caption = 'Payment Tolerance Debit Acc.'; }
                field(paymentToleranceCreditAcc; Rec."Payment Tolerance Credit Acc.") { Caption = 'Payment Tolerance Credit Acc.'; }
            }
        }
    }
}
