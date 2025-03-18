report 50002 "Payments Report"
{
    ApplicationArea = All;
    Caption = 'Payments Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payments Report.rdlc';
    dataset
    {
        dataitem(PaymentHeader; "Payment Header")
        {
            DataItemTableView = where(Posted = const(true));

            dataitem("Document Line"; "Document Line")
            {
                DataItemLink = "header no." = field("no.");
                column(No; PaymentHeader."No.")
                {
                }

                column(PaymentType; PaymentHeader."Payment Type")
                {
                }
                column(PVDate; PaymentHeader."Payment Release Date")
                {
                }
                column(Payee; PaymentHeader.Payee)
                {
                }
                column(Cashier; PaymentHeader.Cashier)
                {
                }
                column(DatePosted; PaymentHeader."Date Posted")
                {
                }
                column(PostedBy; PaymentHeader."Posted By")
                {
                }
                column(PayingBankAccount; PaymentHeader."Paying Bank Account")
                {
                }

                column(Account_No_; "Account No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Amount; Amount)
                {
                }
                column(Tax_Amount; "Tax Amount")
                {
                }
                column(VAT_Amount; "VAT Amount")
                {
                }
                column(Net_Amount; "Net Amount")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
