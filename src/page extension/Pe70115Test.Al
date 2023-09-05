/// <summary>
/// PageExtension AddTransferOrderAJEXReport (ID 70115) extends Record Item Reclass. Journal.
/// </summary>
pageextension 70115 AddTransferOrderAJEXReport extends "Posted Service Invoice"
{
    actions
    {
        AddLast(Reporting)
        {
            action("Test sms")
            {

                Caption = 'test sms';

                ApplicationArea = all;
                trigger OnAction();
                var
                    ServiceInvoiceHeaderRec: Record "Service Invoice Header";
                begin
                    ServiceInvoiceHeaderRec.Reset();
                    ServiceInvoiceHeaderRec.SetRange("No.", Rec."No.");

                    if ServiceInvoiceHeaderRec.FindFirst() then
                        Codeunit.Run(70157, ServiceInvoiceHeaderRec);

                end;
            }

        }

    }
}