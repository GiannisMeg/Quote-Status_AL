codeunit 50130 "SOL Quote Status Mgmt"
{
    procedure CloseQuote(var SalesHeader: Record "Sales Header")
    var
        ArchiveManagement: Codeunit ArchiveManagement;
        IsHandled: Boolean;
    begin
        //Checking Before close Quote 
        IsHandled := false;
        OnBeforeCloseQuote(SalesHeader, IsHandled);
        if IsHandled then
            exit;
        //Closing the Quote 
        SalesHeader."Status" := "Status"::Closed;
        SalesHeader.Modify();

        //Archiving the Quote
        IsHandled := false;
        OnBeforeArchiveSalesQuote(SalesHeader, IsHandled);
        if IsHandled then
            exit;

        case SalesSetup."Archive Quotes" of
            SalesSetup."Archive Quotes"::Always:
                ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
            SalesSetup."Archive Quotes"::Question:
                ArchiveManagement.ArchiveSalesDocument(SalesHeader);
        end;
    end;





}

