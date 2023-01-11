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

