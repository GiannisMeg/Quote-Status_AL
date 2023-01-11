page 50120 "SOL Close Quote"
// add all new fields
// allow add data to new created fields
// this we do it by create a new global var and set it to boolean value
// var AllowChangeStatus has to be not a WON (FALSE) {if status is not equal to Won we allow changes}
// So editable = false instead we need to modify it to Editable = AllowChangeStatus
// 
{
    ApplicationArea = All;
    Caption = 'SOL Close Quote';
    PageType = Card;
    SourceTable = "Sales Header";
    // Hide "new" and "delete" Buttons
    DeleteAllowed = false;
    InsertAllowed = false;
    // we dont want to open through search box
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(QuoteQWon; Rec."SOL Won/Lost Quote Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the quote.';
                    Editable = AllowChangeStatus;

                }
                field("SOL Won/Lost Date"; Rec."SOL Won/Lost Date")
                {
                    ToolTip = 'Specified the date this quote was closed.';
                    ApplicationArea = All;

                }
                field("SOL Won/Lost Reason Code"; Rec."SOL Won/Lost Reason Code")
                {
                    ToolTip = 'Specified the reason closing the quote.';
                    ApplicationArea = All;
                    Editable = AllowChangeStatus;
                }
                field("SOL Won/Lost Reason Desc."; Rec."SOL Won/Lost Reason Desc.")
                {
                    ToolTip = 'Specifies the reason closing the quote.';
                    ApplicationArea = All;
                    Editable = AllowChangeStatus;
                }
                field("SOL Won/Lost Remarks"; Rec."SOL Won/Lost Remarks")
                {
                    Caption = 'Remarks';// By adding caption we overwrite de defined table caption 
                    ApplicationArea = All;
                    MultiLine = true;//Creates a textbox with multiple lines.
                    Editable = AllowChangeStatus;
                }
            }
        }
    }
    var
        AllowChangeStatus: Boolean;

    trigger OnOpenPage()
    begin
        AllowChangeStatus := Rec."SOL Won/Lost Quote Status" <> "SOL Won/Lost Status"::Won;
    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        If CloseAction = Action::LookupOK then
            FinishWizard();
    end;
    // The final reqeust if the necessary fields have a value and the status is either WON OR LOST
    // if not we should throw an error
    // To define the content of your error mess create Labels

    local procedure FinishWizard()
    var
        MustSelectWonOrLostErr: Label 'You must select either Won or Lost';
        FieldMustBeFilledInErr: Label 'You must fill in the %1 field', Comment = '%1 = caption of the field.';

    begin
        if not (Rec."SOL Won/Lost Quote Status" in ["SOL Won/Lost Status"::Won, "SOL Won/Lost Status"::Lost]) then
            Error(MustSelectWonOrLostErr);

        if Rec."SOL Won/Lost Reason Code" = '' then
            Error(FieldMustBeFilledInErr, Rec.FieldCaption("SOL Won/Lost Reason Code"));

        Rec.Modify();
    end;
}
