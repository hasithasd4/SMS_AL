/// <summary>
/// Page SMStypeCompany (ID 70153).
/// </summary>
page 70153 SMStypeCompanypage
{
    PageType = List;
    SourceTable = SMStypeCompany;
    Caption = 'Content of the SMS';
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(Service_type; Rec.Service_type)
                {
                    ApplicationArea = All;
                    Caption = 'Service type';
                    ToolTip = 'Service type';
                    TableRelation = "Service Order Type".Code;
                }

                field(SMS_Body; Rec.SMS_Body)
                {
                    ApplicationArea = All;
                    Caption = 'SMS content ';
                    ToolTip = 'SMS content';
                    MultiLine = true;
                }
                // field("Phone Number"; Rec.SMS_Body1)
                // {
                //     ApplicationArea = All;
                //     Caption = 'SMS content line two';
                //     ToolTip = 'Phone Number';
                // }

                field(SMS_link; Rec.SMS_link)
                {
                    ApplicationArea = All;
                    Caption = 'SMS Link';
                    ToolTip = 'SMS Link';
                }

            }
        }
    }
}
