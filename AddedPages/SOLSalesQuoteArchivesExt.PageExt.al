pageextension 50112 "SOL Sales Quote Archives Ext" extends "Sales Quote Archives"
{
    layout
    {
        addafter("Due Date")
        {
            // field("Quote Status"; Rec."SOL Won/Lost Quote Status")
            // {
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the status of the quote.';
            // }
            // field("Quote Status"; Rec."SOL Quote Status")
            // {
            //     ApplicationArea = All;
            //     Editable = false;
            //     ToolTip = 'Specifies the value of the Quote Status field.';
            // }
            field("Won/Lost Quote Status"; Rec."SOL Quote Status")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quote Status field.';
            }
            field("Won/Lost Date"; Rec."SOL Won/Lost Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specified the date this quote was closed.';
            }
            field("Won/Lost Reason Code"; Rec."SOL Won/Lost Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specified the reason closing the quote.';
            }
            field("Won/Lost Reason Desc."; Rec."SOL Won/Lost Reason Desc.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the reason closing the quote.';
            }
            field("Won/Lost Remarks"; Rec."SOL Won/Lost Remarks")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies an extra remark on the quote status.';
            }

        }
        // Add changes to page layout here
    }
}