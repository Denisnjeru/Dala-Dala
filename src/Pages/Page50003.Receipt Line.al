
Page 50003 "Receipt Line"
{
    PageType = ListPart;
    SourceTable = "Document Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    ApplicationArea = Basic;
                    TableRelation = "Payment & Receipt Types" where(Type = const(Receipt));
                }
                field(AccountType; "Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = Basic;
                }
                field(AccountNo; "Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;

                   
                }
                field("Principal Due"; "Principal Due")
                {
                    ApplicationArea = Basic;
                }
                field("Interest Due"; "Interest Due")
                {
                    ApplicationArea = Basic;
                }
                
                /*
                field(TaxableAmount; "Taxable Amount")
                {
                    ApplicationArea = Basic;
                }*/
                /*
                field(TaxAmount; "Tax Amount")
                {
                    ApplicationArea = Basic;
                }
                field(WithholdingTax; "Withholding Tax")
                {
                    ApplicationArea = Basic;
                }
                field(VATAmount; "VAT Amount")
                {
                    ApplicationArea = Basic;
                }
                field(WithholdingVAT; "Withholding VAT")
                {
                    ApplicationArea = Basic;
                }
            
                field(NetAmount; "Net Amount")
                {
                    ApplicationArea = Basic;
                }*/
                /*
                field(AppliestoDocType;"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocNo;"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoID;"Applies-to ID")
                {
                    ApplicationArea = Basic;
                }
                */
                field(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                /*field("Sales Invoice No"; "Sales Invoice No")
                {
                    ApplicationArea = Basic;
                }*/
            }
        }
    }

    actions
    {
    }

    var
      
        ReceiptHeader: Record "Receipt Header";
}

