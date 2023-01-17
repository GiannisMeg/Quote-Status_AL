// create a procedure that is public and reusable for every obj globaly
// add a new local procedure (Custom function)
//global procedure in this case holds the same parameter like our local procedure thats by reference
// a procedure exept calculation can return an exit statement result aswell


// Create a custom function TO CLOSE AND ARCHIVE QUOTE
// archive a Sales Quoten ONLY if the user condirms the archiving
// codeunit performs the archiving
// When a User created a new order based on the quote will also ask the user to archive the Sales Quote

codeunit 50130 "SOL Quote Status Mgmt"
{
    procedure CloseQuote(var SalesHeader: Record "Sales Header")//parameter is passed by reference
    begin
        //archive quote -- function is made on another codeunit we only have to call it
        ArchiveSalesQuote(SalesHeader);
    end;

    // custom function by following structure of already made function 
    local procedure ArchiveSalesQuote(var SalesHeader: Record "Sales Header") // paramater by ref not by value

    var
        SalesSetup: Record "Sales & Receivables Setup"; // global param
        ArchiveManagement: Codeunit ArchiveManagement; // use global param

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


