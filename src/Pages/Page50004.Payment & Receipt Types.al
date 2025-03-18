
Page 50004 "Payment & Receipt Types"
{
    PageType = List;
    SourceTable = "Payment & Receipt Types";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(AccountType; "Account Type")
                {
                    ApplicationArea = Basic;
                }
                field(AccountNo; "Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic;
                }
                field(VAT; "VAT %")
                {
                    ApplicationArea = Basic;
                }
                field(WithholdingVAT; "Withholding VAT %")
                {
                    ApplicationArea = Basic;
                }
                field(Tax; "Tax %")
                {
                    ApplicationArea = Basic;
                }
                field(WithholdingTax; "Withholding Tax %")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultGrouping; "Default Grouping")
                {
                    ApplicationArea = Basic;
                }
                field(TaxGLAccount; "Tax GL Account")
                {
                    ApplicationArea = Basic;
                }
                field(VATGLAccount; "VAT GL Account")
                {
                    ApplicationArea = Basic;
                }
                field(DailyTaxExemptAmount; "Daily Tax Exempt. Amount")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

