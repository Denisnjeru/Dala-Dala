
Page 50005 "PV List"
{
    ApplicationArea = Basic;
    CardPageID = "PV Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Payment Header";
    SourceTableView = where(Posted = const(false), "Payment Type" = const(Normal));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentType; "Payment Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Date; Date)
                {
                    ApplicationArea = Basic;
                }
                field(Payee; Payee)
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; "Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayingBankAccount; "Paying Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field(BankName; "Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field(TotalVATAmount; "Total VAT Amount")
                {
                    ApplicationArea = Basic;
                }
                field(TotalWitholdingTaxAmount; "Total Witholding Tax Amount")
                {
                    ApplicationArea = Basic;
                }
                field(TotalNetAmount; "Total Net Amount")
                {
                    ApplicationArea = Basic;
                }
                field(ChequeNo; "Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
                field(Cashier; Cashier)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Payment Type" := "payment type"::Normal;
    end;

    trigger OnOpenPage()
    var
        pay: record "Payment Header";
    begin
        if pay.Get('') then begin
            pay.Delete();
            Commit();
        end;

        SetRange(Cashier, UserId);

    end;
}

