

// create a procedure that is public and reusable for every obj globaly
// add a new local procedure (Custom function)
//global procedure in this case holds the same parameter like our local procedure thats by reference
// a procedure exept calculation can return an exit statement result aswell
// 


// Create a custom function TO CLOSE AND ARCHIVE QUOTE
codeunit 50130 "SOL Quote Status Mgmt"
{
    procedure CloseQuote(var SalesHeader: Record "Sales Header")//parameter is passed by reference
    begin
        ArchiveSalesQuote(SalesHeader);
    end;

    local procedure ArchiveSalesQuote(var SalesHeader: Record "Sales Header")

    var
        SalesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;

    begin
        SalesSetup.Get();
        case SalesSetup."Archive Quotes" of
            SalesSetup."Archive Quotes"::Always:
                ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
            SalesSetup."Archive Quotes"::Question:
                ArchiveManagement.ArchiveSalesDocument(SalesHeader);
        end;
    end;
}

