page 50105 "LAAI Website Intake API"
{
    PageType = API;
    APIPublisher = 'laai';
    APIGroup = 'intake';
    APIVersion = 'v1.0';
    EntityName = 'websiteIntake';
    EntitySetName = 'websiteIntakes';
    EntityCaption = 'Website Intake';
    EntitySetCaption = 'Website Intakes';
    SourceTable = "LAAI Website Intake";
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
                field(entryNumber; Rec."Entry No.") { Caption = 'Entry Number'; Editable = false; }
                field(submissionId; Rec."Submission Id") { Caption = 'Submission Id'; }
                field(schemaVersion; Rec."Schema Version") { Caption = 'Schema Version'; }
                field(sourceCode; Rec."Source Code") { Caption = 'Source Code'; }
                field(intakeType; Rec."Intake Type") { Caption = 'Intake Type'; }
                field(receivedAt; Rec."Received At") { Caption = 'Received At'; }
                field(firstName; Rec."First Name") { Caption = 'First Name'; }
                field(lastName; Rec."Last Name") { Caption = 'Last Name'; }
                field(email; Rec.Email) { Caption = 'Email'; }
                field(phoneNumber; Rec."Phone No.") { Caption = 'Phone Number'; }
                field(companyName; Rec."Company Name") { Caption = 'Company Name'; }
                field(companyRole; Rec."Company Role") { Caption = 'Company Role'; }
                field(companySize; Rec."Company Size") { Caption = 'Company Size'; }
                field(existingClient; Rec."Existing Client") { Caption = 'Existing Client'; }
                field(aiMaturity; Rec."AI Maturity") { Caption = 'AI Maturity'; }
                field(serviceCategories; Rec."Service Categories") { Caption = 'Service Categories'; }
                field(currentPlatforms; Rec."Current Platforms") { Caption = 'Current Platforms'; }
                field(desiredOutcome; Rec."Desired Outcome") { Caption = 'Desired Outcome'; }
                field(targetTiming; Rec."Target Timing") { Caption = 'Target Timing'; }
                field(nextStep; Rec."Next Step") { Caption = 'Next Step'; }
                field(meetingPreference; Rec."Meeting Preference") { Caption = 'Meeting Preference'; }
                field(requestedWindow; Rec."Requested Window") { Caption = 'Requested Window'; }
                field(preferredContactTime; Rec."Preferred Contact Time") { Caption = 'Preferred Contact Time'; }
                field(additionalContext; Rec."Additional Context") { Caption = 'Additional Context'; }
                field(status; Rec.Status) { Caption = 'Status'; }
                field(rawSubmission; Rec."Raw Submission") { Caption = 'Raw Submission'; }
                field(leadNumber; Rec."Lead No.") { Caption = 'Lead Number'; }
                field(integrationError; Rec."Integration Error") { Caption = 'Integration Error'; }
                field(processedAt; Rec."Processed At") { Caption = 'Processed At'; }
                field(sowRequired; Rec."SOW Required") { Caption = 'SOW Required'; }
                field(flatFeeAvailable; Rec."Flat Fee Available") { Caption = 'Flat Fee Available'; }
                field(customerNumber; Rec."Customer No.") { Caption = 'Customer Number'; Editable = false; }
                field(salesQuoteNumber; Rec."Sales Quote No.") { Caption = 'Sales Quote Number'; Editable = false; }
                field(salesOrderNumber; Rec."Sales Order No.") { Caption = 'Sales Order Number'; Editable = false; }
                field(lastConversionAt; Rec."Last Conversion At") { Caption = 'Last Conversion At'; Editable = false; }
                field(lastModifiedAt; Rec.SystemModifiedAt) { Caption = 'Last Modified At'; Editable = false; }
            }
        }
    }
}
