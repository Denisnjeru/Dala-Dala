
Report 50000 Receipt
{
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    //RDLCLayout = './Layouts/Receipt.rdlc';

    dataset
    {
        dataitem("Receipt Header"; "Receipt Header")
        {
            RequestFilterFields = "No.";
            column(payrollandstaffNo; payrollandstaffNo)
            {
            }
            column(No_ReceiptHeader; "Receipt Header"."No.")
            {
            }
            column(Date_ReceiptHeader; "Receipt Header"."Posting Date")
            {
            }
            column(Cashier_ReceiptHeader; "Receipt Header".Cashier)
            {
            }
            column(DatePosted_ReceiptHeader; "Receipt Header"."Date Posted")
            {
            }
            column(TimePosted_ReceiptHeader; "Receipt Header"."Time Posted")
            {
            }
            column(Narration_ReceiptHeader; "Receipt Header".Narration)
            {
            }
            column(OnBehalfOf_ReceiptHeader; "Receipt Header"."On Behalf Of")
            {
            }
            column(AmountRecieved_ReceiptHeader; "Receipt Header"."Amount Recieved")
            {
            }
            column(GlobalDimension1Code_ReceiptHeader; "Receipt Header"."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ReceiptHeader; "Receipt Header"."Global Dimension 2 Code")
            {
            }
            column(TotalAmount_ReceiptHeader; "Receipt Header"."Total Amount")
            {
            }
            column(PostedBy_ReceiptHeader; "Receipt Header"."Posted By")
            {
            }
            column(MemberNo_ReceiptHeader; "Receipt Header"."Customer No.")
            {
            }
            column(MemberName_ReceiptHeader; "Receipt Header"."Member Name")
            {
            }
            column(Dep_EFT; "Receipt Header"."Cheque/Deposit Slip No")
            {
            }
            column(PayMode; "Pay Mode")
            {
            }
            column(Cheque_No_; "Cheque No.")
            {
            }
            column(ChequeDepositSlipNo_ReceiptHeader; "Receipt Header"."Cheque/Deposit Slip No")
            {
            }
            column(ChequeDepositSlipDate_ReceiptHeader; "Receipt Header"."Cheque/Deposit Slip Date")
            {
            }
            column(ChequeDepositSlipType_ReceiptHeader; "Receipt Header"."Cheque/Deposit Slip Type")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(Address_1; CompanyInfo.Address)
            {
            }
            column(Address_2; CompanyInfo."Address 2")
            {
            }
            column(City; CompanyInfo.City)
            {
            }
            column(Email; CompanyInfo."E-Mail")
            {
            }
            column(Phone_No; CompanyInfo."Phone No.")
            {
            }
            column(Phone_No2; CompanyInfo."Phone No. 2")
            {
            }

            dataitem("Document Line"; "Document Line")
            {
                DataItemLink = "Header No." = field("No.");
                column(PrincipleAmt; PrincipleAmt)
                {
                }
                column(InterestAmt; InterestAmt)
                {
                }
                column(ReportForNavId_7160; 7160)
                {
                }
                column(NumberText; NumberText[1])
                {
                }
                column(AccountType_DocumentLine; "Document Line"."Account Type")
                {
                }
                column(AccountNo_DocumentLine; "Document Line"."Account No.")
                {
                }
                column(Description_DocumentLine; "Document Line".Description)
                {
                }
                column(Amount_DocumentLine; "Document Line".Amount)
                {
                }
                column(ShortcutDimension1Code_DocumentLine; "Document Line"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_DocumentLine; "Document Line"."Shortcut Dimension 2 Code")
                {
                }
               
                column(Type_DocumentLine; "Document Line".Type)
                {
                }
                trigger onAfterGetRecord()
                var
                    myInt: Integer;
                begin

                    PrincipleAmt := 0;
                    InterestAmt := 0;

                end;

            }

            trigger OnAfterGetRecord()
            begin
                /*
                objLogos.RESET;
                 objLogos.SETRANGE(objLogos.Code,"Receipt Header"."Global Dimension 1 Code");
                IF objLogos.FIND('-') THEN BEGIN
                    objLogos.CALCFIELDS(objLogos.Picture);
                END ELSE BEGIN
                    objLogos.SETRANGE(objLogos.Default,TRUE);
                    objLogos.CALCFIELDS(objLogos.Picture);
                END;
                */
                GenLedgerSetup.Get;

                "Receipt Header".CalcFields("Total Amount");

                CheckReport.InitTextVariable;
                CheckReport.FormatNoText(NumberText, "Receipt Header"."Total Amount", '');

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PrincipleAmt: Decimal;
        InterestAmt: Decimal;
        Chq__Slip_No_CaptionLbl: label 'Chq./Slip No.';
        DescriptionCaptionLbl: label 'Description';
        No_CaptionLbl: label 'No.';
        Received_fromCaptionLbl: label 'Received from';
        Currency_CaptionLbl: label 'Currency:';
        VATCaptionLbl: label 'VAT';
        DateCaptionLbl: label 'Date';
        DepartmentCaptionLbl: label 'Department';
        TotalCaptionLbl: label 'Total';
        Signature___________________Lbl: label '..................................';
        Amount_Incl__VATCaptionLbl: label 'Amount Incl. VAT';
        You_were_served_by_CaptionLbl: label 'You were served by:';
        TimeCaptionLbl: label 'Time';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        VAT_Amount_CaptionLbl: label 'VAT Amount:';
        Amount_Excl_VATCaptionLbl: label 'Amount Excl VAT';
        Signature_CaptionLbl: label 'Signature:';
        CompanyInfo: Record "Company Information";
        CheckReport: Report Check;
        NumberText: array[2] of Text;
        TAmount: Decimal;
        GenLedgerSetup: Record "General Ledger Setup";
}

