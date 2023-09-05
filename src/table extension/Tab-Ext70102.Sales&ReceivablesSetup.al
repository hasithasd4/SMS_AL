/// <summary>
/// TableExtension MyTableExtension (ID 70102) extends Record Service Mgt. Setup.
/// </summary>
tableextension 70105 "Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(70101; "No of Days to send Message"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'No of Days to send Message';

        }

    }
}