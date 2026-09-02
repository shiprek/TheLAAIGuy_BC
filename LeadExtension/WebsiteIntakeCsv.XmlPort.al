xmlport 50100 "LAAI Website Intake CSV"
{
    Caption = 'Website Intake CSV Import';
    Direction = Import;
    Format = VariableText;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(Row; Integer)
            {
                AutoSave = false;
                XmlName = 'WebsiteIntake';

                textelement(ReceivedAtText) { }
                textelement(SchemaVersionText) { }
                textelement(SourceCodeText) { }
                textelement(SubmissionIdText) { }
                textelement(IntakeTypeText) { }
                textelement(FullNameText) { }
                textelement(CompanyNameText) { }
                textelement(EmailText) { }
                textelement(PhoneText) { }
                textelement(CompanyRoleText) { }
                textelement(ExistingClientText) { }
                textelement(AIMaturityText) { }
                textelement(ServiceCategoriesText) { }
                textelement(DesiredOutcomeText) { }
                textelement(NextStepText) { }
                textelement(RequestedWindowText) { }
                textelement(PreferredContactTimeText) { }
                textelement(TargetTimingText) { }
                textelement(AdditionalContextText) { }
                textelement(SowRequiredText) { }
                textelement(FlatFeeAvailableText) { }

                trigger OnBeforeInsertRecord()
                var
                    Intake: Record "LAAI Website Intake";
                    ReceivedAt: DateTime;
                    SchemaVersion: Integer;
                begin
                    RowNumber += 1;
                    if RowNumber = 1 then begin
                        ValidateHeader();
                        currXMLport.Skip();
                    end;

                    if SubmissionAlreadyImported(SubmissionIdText) then
                        currXMLport.Skip();

                    Intake.Init();
                    if Evaluate(ReceivedAt, ReceivedAtText, 9) then
                        Intake."Received At" := ReceivedAt;
                    if Evaluate(SchemaVersion, SchemaVersionText) then
                        Intake."Schema Version" := SchemaVersion;
                    Intake."Source Code" := CopyStr(SourceCodeText, 1, MaxStrLen(Intake."Source Code"));
                    Intake."Submission Id" := CopyStr(SubmissionIdText, 1, MaxStrLen(Intake."Submission Id"));
                    Intake."Intake Type" := ParseIntakeType(IntakeTypeText);
                    SplitFullName(FullNameText, Intake."First Name", Intake."Last Name");
                    Intake."Company Name" := CopyStr(CompanyNameText, 1, MaxStrLen(Intake."Company Name"));
                    Intake.Email := CopyStr(EmailText, 1, MaxStrLen(Intake.Email));
                    Intake."Phone No." := CopyStr(PhoneText, 1, MaxStrLen(Intake."Phone No."));
                    Intake."Company Role" := CopyStr(CompanyRoleText, 1, MaxStrLen(Intake."Company Role"));
                    Intake."Existing Client" := ParseExistingClient(ExistingClientText);
                    Intake."AI Maturity" := ParseAIMaturity(AIMaturityText);
                    Intake."Service Categories" := CopyStr(ServiceCategoriesText, 1, MaxStrLen(Intake."Service Categories"));
                    Intake."Desired Outcome" := CopyStr(DesiredOutcomeText, 1, MaxStrLen(Intake."Desired Outcome"));
                    Intake."Next Step" := ParseNextStep(NextStepText);
                    Intake."Requested Window" := CopyStr(RequestedWindowText, 1, MaxStrLen(Intake."Requested Window"));
                    Intake."Preferred Contact Time" := CopyStr(PreferredContactTimeText, 1, MaxStrLen(Intake."Preferred Contact Time"));
                    Intake."Target Timing" := ParseTiming(TargetTimingText);
                    Intake."Additional Context" := CopyStr(AdditionalContextText, 1, MaxStrLen(Intake."Additional Context"));
                    Intake."SOW Required" := ParseBoolean(SowRequiredText);
                    Intake."Flat Fee Available" := ParseBoolean(FlatFeeAvailableText);
                    Intake."Raw Submission" := CopyStr(BuildRawSubmission(), 1, MaxStrLen(Intake."Raw Submission"));
                    Intake.Insert(true);
                end;
            }
        }
    }

    local procedure ValidateHeader()
    begin
        if (LowerCase(ReceivedAtText) <> 'received_at') or
           (LowerCase(SubmissionIdText) <> 'intake_id') or
           (LowerCase(FullNameText) <> 'full_name') or
           (LowerCase(EmailText) <> 'email') or
           (LowerCase(FlatFeeAvailableText) <> 'flat_fee_available')
        then
            Error(HeaderErr);
    end;

    local procedure SubmissionAlreadyImported(SubmissionId: Text): Boolean
    var
        Intake: Record "LAAI Website Intake";
    begin
        if SubmissionId = '' then
            exit(false);
        Intake.SetRange("Submission Id", CopyStr(SubmissionId, 1, MaxStrLen(Intake."Submission Id")));
        exit(not Intake.IsEmpty());
    end;

    local procedure SplitFullName(FullName: Text; var FirstName: Text[50]; var LastName: Text[50])
    var
        SeparatorPosition: Integer;
        CleanName: Text;
    begin
        CleanName := DelChr(FullName, '<>', ' ');
        SeparatorPosition := StrPos(CleanName, ' ');
        if SeparatorPosition = 0 then begin
            FirstName := CopyStr(CleanName, 1, MaxStrLen(FirstName));
            exit;
        end;
        FirstName := CopyStr(CleanName, 1, SeparatorPosition - 1);
        LastName := CopyStr(DelStr(CleanName, 1, SeparatorPosition), 1, MaxStrLen(LastName));
    end;

    local procedure ParseBoolean(Value: Text): Boolean
    begin
        exit(LowerCase(DelChr(Value, '<>', ' ')) in ['yes', 'true', '1']);
    end;

    local procedure ParseExistingClient(Value: Text): Boolean
    begin
        exit(StrPos(LowerCase(Value), 'existing client') > 0);
    end;

    local procedure ParseIntakeType(Value: Text): Enum "LAAI Intake Type"
    begin
        case LowerCase(Value) of
            'small business ai': exit("LAAI Intake Type"::"Small Business AI");
            'business systems': exit("LAAI Intake Type"::"Business Systems");
        end;
        exit("LAAI Intake Type"::"Not Specified");
    end;

    local procedure ParseAIMaturity(Value: Text): Enum "LAAI Intake AI Maturity"
    var
        NormalizedValue: Text;
    begin
        NormalizedValue := LowerCase(Value);
        if StrPos(NormalizedValue, 'completely new') > 0 then
            exit("LAAI Intake AI Maturity"::"New to AI");
        if StrPos(NormalizedValue, 'experiment') > 0 then
            exit("LAAI Intake AI Maturity"::Experimenting);
        if StrPos(NormalizedValue, 'already use') > 0 then
            exit("LAAI Intake AI Maturity"::"Already Using");
        if StrPos(NormalizedValue, 'team uses') > 0 then
            exit("LAAI Intake AI Maturity"::"Team Needs Improvement");
        exit("LAAI Intake AI Maturity"::"Not Specified");
    end;

    local procedure ParseTiming(Value: Text): Enum "LAAI Intake Timing"
    var
        NormalizedValue: Text;
    begin
        NormalizedValue := LowerCase(Value);
        if StrPos(NormalizedValue, 'soon as possible') > 0 then
            exit("LAAI Intake Timing"::"As Soon As Possible");
        if (StrPos(NormalizedValue, '1-3') > 0) or (StrPos(NormalizedValue, 'one to three') > 0) then
            exit("LAAI Intake Timing"::"One to Three Months");
        if StrPos(NormalizedValue, 'later this year') > 0 then
            exit("LAAI Intake Timing"::"Later This Year");
        if StrPos(NormalizedValue, 'explor') > 0 then
            exit("LAAI Intake Timing"::Exploring);
        exit("LAAI Intake Timing"::"Not Specified");
    end;

    local procedure ParseNextStep(Value: Text): Enum "LAAI Intake Next Step"
    var
        NormalizedValue: Text;
    begin
        NormalizedValue := LowerCase(Value);
        if (StrPos(NormalizedValue, 'consultation') > 0) or (StrPos(NormalizedValue, 'schedule') > 0) then
            exit("LAAI Intake Next Step"::"Discovery Consultation");
        if StrPos(NormalizedValue, 'contact') > 0 then
            exit("LAAI Intake Next Step"::"Contact Me");
        exit("LAAI Intake Next Step"::"Not Specified");
    end;

    local procedure BuildRawSubmission(): Text
    begin
        exit(StrSubstNo('Submission Id: %1 | Intake Type: %2 | Full Name: %3 | Company: %4 | Email: %5 | Services: %6 | Desired Outcome: %7 | Next Step: %8',
            SubmissionIdText, IntakeTypeText, FullNameText, CompanyNameText, EmailText, ServiceCategoriesText, DesiredOutcomeText, NextStepText));
    end;

    var
        RowNumber: Integer;
        HeaderErr: Label 'This is not the expected Website Intakes CSV format. Export the Website Intakes sheet using its current 21-column header row.';
}
