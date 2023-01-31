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
    // ## Request quote status on order creation or archiving


    // We use OnBeforeActionEvent cause we need the subevent to run before the OnAction() trigger int he Sales Quote page
    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'Archive Document', true, true)]
    local procedure OnBeforeActionArchiveDocumentQuote(var Rec: Record "Sales Header")

    var
        ArchiveCanNotBeCompletedErr: Label 'Document archive can not be completed.';

    begin
        CheckingQuoteStatusWonLos(Rec, ArchiveCanNotBeCompletedErr);
    end;


    // create a subevent for Makorder action on the Sales Quote
    [EventSubscriber(ObjectType::Page, Page::"Sales Quote", 'OnBeforeActionEvent', 'MakeOrder', true, true)]
    local procedure OnBeforeMakeOrderQuote(var Rec: Record "Sales Header")

    var
        OrderCreationCanNotBeCompletedErr: Label 'Order creation can not be completed.';

    begin
        CheckingQuoteStatusWonLos(Rec, OrderCreationCanNotBeCompletedErr);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quotes", 'OnBeforeActionEvent', 'MakeOrder', true, true)]
    local procedure OnBeforeActionMakeOrderQuote(var Rec: Record "Sales Header")

    var
        OrderCreationCanNotBeCompletedErr: Label 'Order creation can not be completed.';

    begin
        // call the custom funtion and pass the label parameter
        CheckingQuoteStatusWonLos(Rec, OrderCreationCanNotBeCompletedErr)
    end;


    // create a seperate function check if the quote is set to WON or LOST ; If not open the Sales Quote
    local procedure CheckingQuoteStatusWonLos(var Salesheader: Record "Sales Header"; NotCompleteErr: Text)
    begin
        // checking if is not in progress so its either won or lost
        if Salesheader."SOL Won/Lost Quote Status" <> "SOL Won/Lost Status"::"In Progress" then
            exit;
        // if the status is in progress and only in this case we showing the Close Quote
        // for the won/lost showing Sales Quote (reverse logic)
        if Page.RunModal(Page::"SOL Close Quote", Salesheader) <> Action::LookupOK then
            Error(NotCompleteErr);

    end;

    // ## Copy quote status from sale quote to sales quote archive


    // use the OnBeforeSalesHeaderArchiveInsert where only need to copy the values from the table to the other
    // we dont need to specify a Modify or Insert statement because it get handled in the standard ArchiveManagement codeunit.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ArchiveManagement", 'OnBeforeSalesHeaderArchiveInsert', '', true, true)]
    // params are passed by ref so from the moment we assign new values here gonna be changed in the table aswel
    local procedure OnBeforeSalesHeaderArchiveInsert(var SalesHeaderArchive: Record "Sales Header Archive"; SalesHeader: Record "Sales Header") // from SalesHeader to Archive

    begin

        // checking existance 
        if (SalesHeader."Document Type" <> SalesHeader."Document Type"::Quote) then
            exit;
        // if not copy from the header to Archive
        // is the same if we write it other way around?
        SalesHeaderArchive."SOL Quote Status" := SalesHeader."SOL Won/Lost Quote Status";
        SalesHeaderArchive."SOL Won/Lost Date" := SalesHeader."SOL Won/Lost Date";
        SalesHeaderArchive."SOL Won/Lost Reason Code" := SalesHeader."SOL Won/Lost Reason Code";
        SalesHeaderArchive."SOL Won/Lost Reason Desc." := SalesHeader."SOL Won/Lost Reason Desc.";
        SalesHeaderArchive."SOL Won/Lost Remarks" := SalesHeader."SOL Won/Lost Remarks";
    end;

    //Create a function who retrieves the salesperson for the currently logged in user
    procedure GetSalespersonForLoggedInUser(): Code[20]
    var
        // store local variables the recored we want to retrieve from the table 
        Salesperson: Record "Salesperson/Purchaser";
        User: Record User;
    begin
        User.Reset();
        if not User.Get(UserSecurityId()) then
            exit('');

        if User."Contact Email".Trim() = '' then
            exit('');

        Salesperson.Reset();
        Salesperson.SetRange("E-Mail", User."Contact Email");
        //chech salesperson exist then finddirst() and get the salespersonCode
        if Salesperson.FindFirst() then
            exit(Salesperson.Code);
    end;

    // when a logged in person from sales opensRoleCenter page show won/lost quotes for the last 5 days if they are no quotes found dont show notifications
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Conf./Personalization Mgt.", 'OnRoleCenterOpen', '', true, true)]
    // trigger event onRoleCenterOpen
    local procedure OnRoleCenterOpen()
    var
        SalespersonCode: Code[20];

    begin
        SalespersonCode := GetSalespersonForLoggedInUser();

        // check if the salespersonCode is logged in if not exit
        if SalespersonCode = '' then
            exit;
        // show won status
        GetQuoteRecords("SOL Won/Lost Status"::Won, SalespersonCode);
        // show lost status
        GetQuoteRecords("SOL Won/Lost Status"::Lost, SalespersonCode);
    end;

    Local procedure GetQuoteRecords(WonLostStatus: Enum "SOL Won/Lost Status"; SalespersonCode: Code[20])
    var
        SalesHeader: Record "Sales Header";
        NoOfRecords: Integer;
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Quote);
        SalesHeader.SetRange("SOL Won/Lost Quote Status", WonLostStatus);
        // SalesHeader.SetRange("SOL Won/Lost Date", AddDateToTime(CurrentDateTime(),-5),CurrentDateTime());
        SalesHeader.SetRange("SOL Won/Lost Date", CurrentDateTime());
        NoOfRecords := SalesHeader.Count();

        If NoOfRecords <> 0 then
            SendNoOfQuoteNotification(NoOfRecords, WonLostStatus, SalespersonCode);

    end;

    local procedure SendNoOfQuoteNotification(NoOfQuotes: Integer; WonLostStatus: Enum "SOL Won/Lost Status"; SalespersonCode: Code[20])
    var
        QuoteNotification: Notification;
        YouWonLostQuoteMsg: Label 'You %1 Quotes''%2''quotes during the last 5 days.', Comment = '%1 = Won/Lost ; %2 = No of quotes';
        ShowQutoesLbl: Label 'Show %1 Quotes', Comment = '%1 = Qon/Lost';
    begin
        QuoteNotification.Message := StrSubstNo(YouWonLostQuoteMsg, WonLostStatus, NoOfQuotes);
        QuoteNotification.SetData('SalespersonCode', SalespersonCode);
        QuoteNotification.SetData('WonLostStatus', Format(WonLostStatus.AsInteger()));
        QuoteNotification.AddAction(StrSubstNo(ShowQutoesLbl, WonLostStatus), Codeunit::"SOL Quote Status Mgmt", 'OpenQuotes');
        QuoteNotification.Send();
    end;
}



