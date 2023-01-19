
// add twp parts to Role Cemter before the Favorite Accoutns
pageextension 50100 "SOL Business Manager rc Ext" extends "Business Manager Role Center"
{
    layout
    {
        //before the FAVORITE ACCOUTNS
        addbefore("Favorite Accounts")
        {
            // SHOW WIN QUOTES SITUATION
            part(SalesQuoteWon; "SOL Sales Quote Status List")
            {
                Caption = 'You Won Sales Quotes';
                ApplicationArea = All;
                SubPageView = where("SOL Won/Lost Quote Status" = const("Won"));
            }
            // LOST QUOTES SITUATION
            part(SalesQuoteLost; "SOL Sales Quote Status List")
            {
                Caption = 'You Lost Sales Quotes';
                ApplicationArea = All;
                SubPageView = where("SOL Won/Lost Quote Status" = const("Lost"));
            }
        }
    }

}