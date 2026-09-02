page 50104 "LAAI Website Intake List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "LAAI Website Intake";
    CardPageId = "LAAI Website Intake Card";
    Caption = 'Website Intakes';
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Received At"; Rec."Received At") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Intake Type"; Rec."Intake Type") { ApplicationArea = All; }
                field("First Name"; Rec."First Name") { ApplicationArea = All; }
                field("Last Name"; Rec."Last Name") { ApplicationArea = All; }
                field("Company Name"; Rec."Company Name") { ApplicationArea = All; }
                field(Email; Rec.Email) { ApplicationArea = All; }
                field("Next Step"; Rec."Next Step") { ApplicationArea = All; }
                field("Lead No."; Rec."Lead No.") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportCsv)
            {
                ApplicationArea = All;
                Caption = 'Import Website Intakes';
                Image = Import;
                ToolTip = 'Import new website intake submissions from the Squarespace Google Drive CSV file.';

                trigger OnAction()
                var
                    FileName: Text;
                    IntakeStream: InStream;
                begin
                    if not UploadIntoStream(ImportTitleLbl, '', CsvFilterLbl, FileName, IntakeStream) then
                        exit;
                    Xmlport.Import(Xmlport::"LAAI Website Intake CSV", IntakeStream);
                    CurrPage.Update(false);
                    Message(ImportCompleteMsg);
                end;
            }
        }
    }

    var
        ImportTitleLbl: Label 'Select Website Intake CSV';
        CsvFilterLbl: Label 'CSV files (*.csv)|*.csv';
        ImportCompleteMsg: Label 'The website intake CSV was imported. Review the new entries before creating leads, linking customers, or creating sales documents.';
}
