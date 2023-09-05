/// <summary>
/// Codeunit MyCodeunit (ID 70157).
/// </summary>
codeunit 70157 SMSTypeCompany
{
    procedure SendSMStoCustomersTest()
    var
        SMSMgtSetup: Record "SMS Management Setup";
        Client: HttpClient;
        RequestHeaders: HttpHeaders;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        ResponseText: Text[1000];
        contentHeaders: HttpHeaders;
        PostUrl: Text[300];
        RequestContentText: text;
        Token: Text[10000];
        SMSJsonBody: JsonObject;
        SMSMgt: Codeunit "SMS Management";
        Message: Text[1000];
        ServiceInvoiceHeader: Record "Service Invoice Header";
        StartDate, EndDate : date;
        Invoices: Code[100];
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        NoofDays: Integer;
        EntryNo: Integer;
        ServiceManagementRec: Record "Service Mgt. Setup";
        Hotline: Text[20];
        SubPhoneNo: Text[20];
        Link: Text;

        servtype: Text;
        smsbody: Text;
        smsbody1: Text;
        pono: Text;



    begin
        SMSMgtSetup.Get();
        SMSMgtSetup.TestField("SMS URL");
        IF SMSMgtSetup."Token Expire" <= CurrentDateTime then begin
            SMSMgt.GenerateToken();
        end;

        ServiceManagementRec.Get();
        // IF ServiceManagementRec."No of Days to send Message" = 0 then
        //     Error('No of Days to send message cannot be zero.');

        ServiceManagementRec.Reset();
        ServiceManagementRec.Get();
        Hotline := ServiceManagementRec."Hotline Number";
        EntryNo := SMSLogSaleOrder."Entry No";
        // Link := 'https://feedback.brownsgroup.com';

        ServiceInvoiceHeader.Reset();
        ServiceInvoiceHeader.SetRange("Posting Date", CalcDate('-' + FORMAT(ServiceManagementRec."No of Days to send Message") + 'D'));
        if ServiceInvoiceHeader.FindFirst() then begin
            repeat
                if ServiceInvoiceHeader."Sub Customer No." <> '' then begin
                    SubPhoneNo := ServiceInvoiceHeader."Sub Customer Phone No.";
                    // SubPhoneNo := '0712115736';
                    SMSLogSaleOrder.Reset();
                    SMSLogSaleOrder.SetRange("Service Order No.", ServiceInvoiceHeader."Order No.");
                    if SMSLogSaleOrder.FindLast() then
                        LastEntryNo := SMSLogSaleOrder."Entry No";
                    Message(ServiceInvoiceHeader."Order No.");


                    servtype := ServiceInvoiceHeader."Service Order Type";

                    SMStypeCompanyRec.Get(servtype);
                    smsbody := SMStypeCompanyRec.SMS_Body;

                    Link := SMStypeCompanyRec.SMS_link;
                    pono := ServiceInvoiceHeader."No.";
                    //Message(servtype);
                    //Message(Link);
                    //Message(smsbody);

                    Message := 'Greeting for the day!';
                    Message += '\n';
                    Message += '\n';
                    Message += smsbody;
                    Message += '\n';
                    Message += '\nVist the below link to give any feedback.';
                    Message += '\n';
                    Message += Link + '/' + ServiceInvoiceHeader."Customer No." + '/' + ServiceInvoiceHeader."No.";
                    Message += '\n';
                    Message += '\nThank you! ';
                    Message += '\nBrowns Deals Customer Care.';

                    Token := 'Bearer ' + SMSMgtSetup.GetToken();
                    PostUrl := SMSMgtSetup."SMS URL";
                    RequestHeaders.Clear();
                    RequestHeaders := Client.DefaultRequestHeaders();
                    RequestHeaders.Add('Authorization', Token);
                    Clear(SMSJsonBody);
                    SMSJsonBody.Add('recipient', SubPhoneNo);
                    SMSJsonBody.Add('message', Message);
                    SMSJsonBody.Add('company', 100);
                    SMSJsonBody.Add('module', 'erp');
                    SMSJsonBody.Add('mask', 'BrownsGroup');
                    SMSJsonBody.Add('priority', 2);
                    SMSJsonBody.Add('desg', 'E');

                    SMSJsonBody.WriteTo(RequestContentText);
                    RequestContentText := RequestContentText.Replace('\\n', '\n');
                    RequestContent.WriteFrom(RequestContentText);

                    RequestContent.GetHeaders(contentHeaders);
                    contentHeaders.Clear();
                    contentHeaders.Add('Content-Type', 'application/json');

                    Client.Post(PostUrl, RequestContent, ResponseMessage);

                    Message('Sending SMS to Sub customer %1', SubPhoneNo);


                    if ResponseMessage.IsSuccessStatusCode then begin
                        SMSLogSaleOrder.Init();
                        SMSLogSaleOrder."Entry No" := LastEntryNo;
                        SMSLogSaleOrder.SMSEntryNo := EntryNo;
                        SMSLogSaleOrder."Send Phone No" := SubPhoneNo;
                        SMSLogSaleOrder."Send Date Time" := CurrentDateTime;
                        SMSLogSaleOrder."Service Order No." := ServiceInvoiceHeader."No.";
                        SMSLogSaleOrder.Sent := true;
                        SMSLogSaleOrder.Insert();
                    end
                    else begin
                        ResponseMessage.Content().ReadAs(ResponseText);

                        SMSLogSaleOrder.Init();
                        SMSLogSaleOrder."Entry No" := LastEntryNo;
                        SMSLogSaleOrder.SMSEntryNo := EntryNo;
                        SMSLogSaleOrder."Send Phone No" := SubPhoneNo;
                        SMSLogSaleOrder."Service Order No." := ServiceInvoiceHeader."No.";
                        SMSLogSaleOrder."Send Date Time" := CurrentDateTime;
                        SMSLogSaleOrder.Sent := false;
                        SMSLogSaleOrder.Remarks := ResponseText;
                        SMSLogSaleOrder.Insert();
                    end;
                end
                else

                    if ServiceInvoiceHeader."End Customer Contact No." <> '' then begin
                        SubPhoneNo := ServiceInvoiceHeader."End Customer Contact No.";
                        //SubPhoneNo := '0712115736';
                        SMSLogSaleOrder.Reset();
                        SMSLogSaleOrder.SetRange("Service Order No.", ServiceInvoiceHeader."Order No.");
                        if SMSLogSaleOrder.FindLast() then
                            LastEntryNo := SMSLogSaleOrder."Entry No";
                        Message(ServiceInvoiceHeader."Order No.");


                        servtype := ServiceInvoiceHeader."Service Order Type";

                        SMStypeCompanyRec.Get(servtype);
                        smsbody := SMStypeCompanyRec.SMS_Body;

                        Link := SMStypeCompanyRec.SMS_link;
                        pono := ServiceInvoiceHeader."No.";
                        // Message(servtype);
                        //   Message(Link);
                        //Message(smsbody);

                        Message := 'Greeting for the day!';
                        Message += '\n';
                        Message += '\n';
                        Message += smsbody;
                        Message += '\n';
                        Message += '\nVist the below link to give any feedback.';
                        Message += '\n';
                        Message += Link + '/' + ServiceInvoiceHeader."Customer No." + '/' + ServiceInvoiceHeader."No.";
                        Message += '\n';
                        Message += '\nThank you! ';
                        Message += '\nBrowns Deals Customer Care.';

                        Token := 'Bearer ' + SMSMgtSetup.GetToken();
                        PostUrl := SMSMgtSetup."SMS URL";
                        RequestHeaders.Clear();
                        RequestHeaders := Client.DefaultRequestHeaders();
                        RequestHeaders.Add('Authorization', Token);
                        Clear(SMSJsonBody);
                        SMSJsonBody.Add('recipient', SubPhoneNo);
                        SMSJsonBody.Add('message', Message);
                        SMSJsonBody.Add('company', 100);
                        SMSJsonBody.Add('module', 'erp');
                        SMSJsonBody.Add('mask', 'BrownsGroup');
                        SMSJsonBody.Add('priority', 2);
                        SMSJsonBody.Add('desg', 'E');

                        SMSJsonBody.WriteTo(RequestContentText);
                        RequestContentText := RequestContentText.Replace('\\n', '\n');
                        RequestContent.WriteFrom(RequestContentText);

                        RequestContent.GetHeaders(contentHeaders);
                        contentHeaders.Clear();
                        contentHeaders.Add('Content-Type', 'application/json');

                        Client.Post(PostUrl, RequestContent, ResponseMessage);

                        Message('Sending SMS to %1 ', SubPhoneNo);


                        if ResponseMessage.IsSuccessStatusCode then begin
                            SMSLogSaleOrder.Init();
                            SMSLogSaleOrder."Entry No" := LastEntryNo;
                            SMSLogSaleOrder.SMSEntryNo := EntryNo;
                            SMSLogSaleOrder."Send Phone No" := SubPhoneNo;
                            SMSLogSaleOrder."Send Date Time" := CurrentDateTime;
                            SMSLogSaleOrder."Service Order No." := ServiceInvoiceHeader."No.";
                            SMSLogSaleOrder.Sent := true;
                            SMSLogSaleOrder.Insert();
                        end
                        else begin
                            ResponseMessage.Content().ReadAs(ResponseText);

                            SMSLogSaleOrder.Init();
                            SMSLogSaleOrder."Entry No" := LastEntryNo;
                            SMSLogSaleOrder.SMSEntryNo := EntryNo;
                            SMSLogSaleOrder."Send Phone No" := SubPhoneNo;
                            SMSLogSaleOrder."Service Order No." := ServiceInvoiceHeader."No.";
                            SMSLogSaleOrder."Send Date Time" := CurrentDateTime;
                            SMSLogSaleOrder.Sent := false;
                            SMSLogSaleOrder.Remarks := ResponseText;
                            SMSLogSaleOrder.Insert();
                        end;
                        // end;
                        // begin
                        //     Message('SMS does not send. No mobile number.');

                        //     SMSLogSaleOrder.Init();
                        //     SMSLogSaleOrder."Entry No" := LastEntryNo;
                        //     SMSLogSaleOrder.SMSEntryNo := EntryNo;
                        //     SMSLogSaleOrder."Send Phone No" := SubPhoneNo;
                        //     SMSLogSaleOrder."Send Date Time" := CurrentDateTime;
                        //     SMSLogSaleOrder."Service Order No." := ServiceInvoiceHeader."No.";
                        //     SMSLogSaleOrder.Sent := false;
                        //     SMSLogSaleOrder.Remarks := 'No Phone No';
                        //     SMSLogSaleOrder.Insert();
                        // end;
                    end;

            until ServiceInvoiceHeader.Next() = 0;
            Message('%1', ServiceInvoiceHeader."No.");

        end;
    End;





    trigger OnRun()
    var
        myInt: Integer;
    begin
        SendSMStoCustomersTest();
    end;

    var

        SMSLogSaleOrder: Record SMSLogPostedServiceOrder;
        LastEntryNo: Integer;
        CustomerRec: Record Customer;
        SMStypeCompanyRec: Record SMStypeCompany;





}