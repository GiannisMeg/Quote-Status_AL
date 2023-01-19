page 50101 "SOL Sales Quote Status List"
{
    ApplicationArea = All;
    Caption = 'WonLostQuotePart';
    PageType = ListPart;
    SourceTable = "Sales Header";
    //dipslay omly quotes
    SourceTableView = where("Document Type" = const(Quote));
    // filter the document only show quotes and not be able to add edir or delete recoreds.
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(content)
        {
            repeater(Rep)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the estimate.';

                    trigger OnDrillDown()
                    begin
                        Page.Run(Page::"Sales Quote", Rec);
                    end;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ToolTip = 'Specifies the customer''s name.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the total amount on the sales invoice excluding VAT.';
                }
                field("SOL Won/Lost Date"; Rec."SOL Won/Lost Date")
                {
                    ToolTip = 'Specified the date this quote was closed.';
                }
                field("SOL Won/Lost Reason Desc."; Rec."SOL Won/Lost Reason Desc.")
                {
                    ToolTip = 'Specifies the reason closing the quote.';
                }
            }
        }

    }

}
