
Page 50008 "PV Line"
{
    PageType = ListPart;
    SourceTable = "Document Line";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    ApplicationArea = Basic;
                    TableRelation = "Payment & Receipt Types" where(Type = filter(Payment));
                }
                field(AccountType; "Account Type")
                {
                    ApplicationArea = Basic;
                }
                
                field(AccountNo; "Account No.")
                {
                    ApplicationArea = Basic;


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Customer: Record Customer;
                        Vendor: Record Vendor;
                        GLAcc: Record "G/L Account";
                        Bank: Record "Bank Account";
                    begin
                        if "Account Type" = "Account Type"::"G/L Account" then begin
                            "Account No." := '';
                            GLAcc.Reset();
                            if Page.RunModal(Page::"Chart of Accounts", GLAcc) = Action::LookupOK then
                                "Account No." := GLAcc."No.";
                        end
                        else
                            if "Account Type" = "Account Type"::Customer then begin
                                "Account No." := '';
                                Customer.Reset();
                                if Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK then
                                    "Account No." := Customer."No.";
                            end
                            else
                                if "Account Type" = "Account Type"::Vendor then begin
                                    "Account No." := '';
                                    Vendor.Reset();
                                    if Page.RunModal(Page::"Vendor List", Vendor) = Action::LookupOK then
                                        "Account No." := Vendor."No.";
                                    
                                end
                                else
                                    if "Account Type" = "Account Type"::"Bank Account" then begin
                                        "Account No." := '';
                                        Bank.Reset();
                                        //if Page.RunModal(Page::"Bank Account List", Vendor) = Action::LookupOK then
                                        if Page.RunModal(Page::"Bank Account List", Bank) = Action::LookupOK then
                                            "Account No." := Bank."No.";
                                    end;

                                  
                                     
                        Validate("Account No.");
                    end;

                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field("KRA PIN No."; "KRA PIN No.")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                }
                field(TaxableAmount; "Taxable Amount")
                {
                    ApplicationArea = Basic;
                }
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
                }
                field(AppliestoDocType; "Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocNo; "Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoID; "Applies-to ID")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Purchase Invoice No"; "Purchase Invoice No")
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

