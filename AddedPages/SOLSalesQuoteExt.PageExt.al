pageextension 50110 "SOL Sales Quote Ext" extends "Sales Quote"
{
    layout
    {
        addlast(General)
        {
            field("Quote Status"; Rec."SOL Won/Lost Quote Status")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the status of the quote.';
            }
            field("Won/Lost Date"; Rec."SOL Won/Lost Date")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specified the date this quote was closed.';
            }
            field("Won/Lost Reason Code"; Rec."SOL Won/Lost Reason Code")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specified the reason closing the quote.';
            }
            field("Won/Lost Reason Desc."; Rec."SOL Won/Lost Reason Desc.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the reason closing the quote.';
            }
            field("Won/Lost Remarks"; Rec."SOL Won/Lost Remarks")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies an extra remark on the quote status.';
            }

        }

        // Add changes to page layout here
    }

    actions
    {
        area(Process)
        {
            group(Create)
            {
                
             Run."SOL Quote Status Mgmt"  
            }
        }
    }
}