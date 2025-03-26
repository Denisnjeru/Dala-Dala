

Table 50002 "Document Line"
{

    fields
    {
        field(1; "Line No."; Integer)
        {

            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Header No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin

                Validate("Account No.", '');
                Validate(Description, '');
            end;
        }
        field(50073; PayrollAndStaffNo; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = const(Customer)) Customer where("Customer Posting Group" = field(Grouping))
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Account Type" = const(Employee)) Employee;


            trigger OnValidate()
            begin

                if "Account No." <> '' then
                    case "Account Type" of
                        "account type"::"G/L Account":
                            GetGLAccount;
                        "account type"::Customer:
                            GetCustomerAccount;
                        "account type"::Vendor:
                            GetVendorAccount;
                        "account type"::Employee:
                            GetEmployeeAccount;
                        
                    end;
            end;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(6; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Cust: Record Customer;
                Vend: Record Vendor;
            begin
            end;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(9; Grouping; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group"
            else
            if ("Account Type" = const(Vendor)) "Vendor Posting Group";
        }
        field(11; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                               Blocked = const(false))
            else
            if ("Bal. Account Type" = const(Customer)) Customer
            else
            if ("Bal. Account Type" = const(Vendor)) Vendor
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Bal. Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Bal. Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Bal. Account Type" = const(Employee)) Employee;
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate()
            var
                BankAcc: Record "Bank Account";
            begin
                if "Bal. Account Type" = "bal. account type"::"Bank Account" then begin
                    if BankAcc.Get("Bal. Account No.") and (BankAcc."Currency Code" <> '') then
                        BankAcc.TestField("Currency Code", "Currency Code");
                end;
                if "Account Type" = "account type"::"Bank Account" then begin
                    if BankAcc.Get("Account No.") and (BankAcc."Currency Code" <> '') then
                        BankAcc.TestField("Currency Code", "Currency Code");
                end;


                if "Currency Code" <> '' then begin
                    if ("Bal. Account Type" = "bal. account type"::Employee) or ("Account Type" = "account type"::Employee) then
                        Error(OnlyLocalCurrencyForEmployeeErr);
                    GetCurrency;
                    if ("Currency Code" <> xRec."Currency Code") or
                       ("Posting Date" <> xRec."Posting Date") or
                       (CurrFieldNo = FieldNo("Currency Code")) or
                       ("Currency Factor" = 0)
                    then
                        "Currency Factor" :=
                          CurrExchRate.ExchangeRate("Posting Date", "Currency Code");
                end else
                    "Currency Factor" := 0;
                Validate("Currency Factor");

                /*
                IF NOT CustVendAccountNosModified THEN
                  IF ("Currency Code" <> xRec."Currency Code") AND (Amount <> 0) THEN
                    PaymentToleranceMgt.PmtTolGenJnl(Rec);
                    */

            end;
        }

        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;

            trigger OnValidate()
         
            begin

                if ReceiptHeader.Get("Header No.") then begin
                    "Shortcut Dimension 1 Code" := ReceiptHeader."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := ReceiptHeader."Global Dimension 2 Code";


                end;


                if PaymentHeader.Get("Header No.") then begin
                    "Shortcut Dimension 1 Code" := PaymentHeader."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";

                    if (PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Board) or (PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Member) or (PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Staff) then begin
                        if PaymentHeader."Pay Mode" = PaymentHeader."Pay Mode"::Cash then
                            TestField("Account Type", "Account Type"::"G/L Account");
                     
                    end;
                end;


                "Taxable Amount" := Amount;



               UpdateAmounts;
            end;
        }
        field(18; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Currency Code" = '') and ("Currency Factor" <> 0) then
                    FieldError("Currency Factor", StrSubstNo(Text002, FieldCaption("Currency Code")));
                Validate(Amount);
            end;
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(35; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" then
                    Validate("Applies-to Doc. No.", '');
            end;
        }
        field(36; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
                AccType: Enum "Gen. Journal Account Type";

                AccNo: Code[20];
            begin
                xRec.Amount := Amount;
                //xRec."Currency Code" := "Currency Code";
                xRec."Posting Date" := "Posting Date";

                //GetAccTypeAndNo(Rec,AccType,AccNo);
                AccType := "Account Type";
                AccNo := "Account No.";

                Clear(CustLedgEntry);
                Clear(VendLedgEntry);

                case AccType of
                    Acctype::Customer:
                        LookUpAppliesToDocCust(AccNo);
                    Acctype::Vendor:
                        LookUpAppliesToDocVend(AccNo);
                    Acctype::Employee:
                        LookUpAppliesToDocEmpl(AccNo);
                end;

                //SetJournalLineFieldsFromApplication;

                ////if xRec.Amount <> 0 then
                //if not PaymentToleranceMgt.PmtTolDocumentLine(Rec) then
                //  exit;

                if "Applies-to Doc. Type" = "applies-to doc. type"::Invoice then
                    UpdateAppliesToInvoiceID;
            end;

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
                TempGenJnlLine: Record "Document Line" temporary;
            begin
                if "Applies-to Doc. No." <> xRec."Applies-to Doc. No." then
                    ClearCustVendApplnEntry;

                if ("Applies-to Doc. No." = '') and (xRec."Applies-to Doc. No." <> '') then begin
                    // PaymentToleranceMgt.DocumentLineDelPmtTolApllnDocNo(Rec, xRec."Applies-to Doc. No.");

                    TempGenJnlLine := Rec;

                    case TempGenJnlLine."Account Type" of
                        TempGenJnlLine."account type"::Customer:
                            begin
                                CustLedgEntry.SetCurrentkey("Document No.");
                                CustLedgEntry.SetRange("Document No.", xRec."Applies-to Doc. No.");
                                if not (xRec."Applies-to Doc. Type" = "document type"::" ") then
                                    CustLedgEntry.SetRange("Document Type", xRec."Applies-to Doc. Type");
                                CustLedgEntry.SetRange("Customer No.", TempGenJnlLine."Account No.");
                                CustLedgEntry.SetRange(Open, true);
                                if CustLedgEntry.FindFirst then begin
                                    if CustLedgEntry."Amount to Apply" <> 0 then begin
                                        CustLedgEntry."Amount to Apply" := 0;
                                        Codeunit.Run(Codeunit::"Cust. Entry-Edit", CustLedgEntry);
                                    end;
                                    //"Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                                    //"Applies-to Ext. Doc. No." := '';
                                end;
                            end;
                        TempGenJnlLine."account type"::Vendor:
                            begin
                                VendLedgEntry.SetCurrentkey("Document No.");
                                VendLedgEntry.SetRange("Document No.", xRec."Applies-to Doc. No.");
                                if not (xRec."Applies-to Doc. Type" = "document type"::" ") then
                                    VendLedgEntry.SetRange("Document Type", xRec."Applies-to Doc. Type");
                                VendLedgEntry.SetRange("Vendor No.", TempGenJnlLine."Account No.");
                                VendLedgEntry.SetRange(Open, true);
                                if VendLedgEntry.FindFirst then begin
                                    if VendLedgEntry."Amount to Apply" <> 0 then begin
                                        VendLedgEntry."Amount to Apply" := 0;
                                        Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
                                    end;
                                    //"Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                                end;
                                //"Applies-to Ext. Doc. No." := '';
                            end;
                        TempGenJnlLine."account type"::Employee:
                            begin
                                EmplLedgEntry.SetCurrentkey("Document No.");
                                EmplLedgEntry.SetRange("Document No.", xRec."Applies-to Doc. No.");
                                if not (xRec."Applies-to Doc. Type" = "document type"::" ") then
                                    EmplLedgEntry.SetRange("Document Type", xRec."Applies-to Doc. Type");
                                EmplLedgEntry.SetRange("Employee No.", TempGenJnlLine."Account No.");
                                EmplLedgEntry.SetRange(Open, true);
                                if EmplLedgEntry.FindFirst then begin
                                    if EmplLedgEntry."Amount to Apply" <> 0 then begin
                                        EmplLedgEntry."Amount to Apply" := 0;
                                        Codeunit.Run(Codeunit::"Empl. Entry-Edit", EmplLedgEntry);
                                    end;
                                    //"Exported to Payment File" := EmplLedgEntry."Exported to Payment File";
                                end;
                            end;
                    end;
                end;

                if ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") and (Amount <> 0) then begin
                    //if xRec."Applies-to Doc. No." <> '' then
                    // PaymentToleranceMgt.DocumentLineDelPmtTolApllnDocNo(Rec, xRec."Applies-to Doc. No.");
                    SetApplyToAmount;
                    //PaymentToleranceMgt.PmtTolGenJnl(Rec);
                    xRec.ClearAppliedGenJnlLine;
                end;

                case "Account Type" of
                    "account type"::Customer:
                        GetCustLedgerEntry;
                    "account type"::Vendor:
                        GetVendLedgerEntry;
                    "account type"::Employee:
                        GetEmplLedgerEntry;
                end;

                ValidateApplyRequirements(Rec);
                //SetJournalLineFieldsFromApplication;

                if "Applies-to Doc. Type" = "applies-to doc. type"::Invoice then
                    UpdateAppliesToInvoiceID;
            end;
        }
        field(48; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("Applies-to ID" <> xRec."Applies-to ID") and (xRec."Applies-to ID" <> '') then
                    ClearCustVendApplnEntry;
                //SetJournalLineFieldsFromApplication;
            end;
        }
        field(63; "Bal. Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Bal. Account Type';
            DataClassification = ToBeClassified;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(8003; "Applies-to Invoice Id"; Guid)
        {
            Caption = 'Applies-to Invoice Id';
            DataClassification = ToBeClassified;
            //TableRelation = "Sales Invoice Header".Id;

            trigger OnValidate()
            begin
                UpdateAppliesToInvoiceNo;
            end;
        }
      field(50052; "Member No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = customer;

            
        }
        field(50053; "Group Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50054; "Taxable Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(50055; "Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50056; "Withholding Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50057; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50058; "Withholding VAT"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50059; Document; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Receipt,"Payment Voucher","Petty Cash";
        }
        field(50060; Type; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin


                PmtType.Reset;
                PmtType.SetRange(PmtType.Code, Type);
                if PmtType.Find('-') then begin
                    "Account Type" := PmtType."Account Type";
                    Description := PmtType.Description;
                    Grouping := PmtType."Default Grouping";
                    "VAT GL Account" := PmtType."VAT GL Account";
                    "WTax GL Account" := PmtType."Tax GL Account";
                    "Tax GL Account" := PmtType."Tax GL Account";
                    "Account No." := PmtType."Account No.";
                    if ReceiptHeader.Get("Header No.") then
                        "Posting Date" := ReceiptHeader."Posting Date";
                    "Member No." := ReceiptHeader."Customer No.";

                    if PmtType.Type = PmtType.Type::Receipt then begin

                        
                        if PmtType."Account Type" = PmtType."Account Type"::Customer then begin
                            Validate("Account No.", ReceiptHeader."Customer No.");
                        end;
                    end;
                end;

            end;
        }
        field(50061; "Net Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50062; "VAT GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50063; "WTax GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation =
             "G/L Account";
        }

         field(50065; "Sales Invoice No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header" where("Sell-to Customer No." = field("Account No."), "Remaining Amount" = filter(> 0));
        }
        field(50066; "Purchase Invoice No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purch. Inv. Header" where("Buy-from Vendor No." = field("Account No."), "Remaining Amount" = filter(> 0));

            trigger OnValidate()
            var
                PInv: Record "Purch. Inv. Header";

            begin
                PInv.Reset();
                PInv.SetRange("No.", "Purchase Invoice No");
                if PInv.FindFirst() then "Vendor Invoice No." := PInv."Vendor Invoice No.";

            end;

        }
        field(50067; Name; Text[200])
        {
            DataClassification = ToBeClassified;
        }


        field(50070; "Principal Due"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50071; "Interest Due"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

        field(50072; "KRA PIN No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }


        field(50075; "Tax GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation =
             "G/L Account";
        }

        field(50076; "Vendor Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(50077; "Withholding Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(50078; Committed; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(50079; "G/L Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation =
             "G/L Account";
        }

    }

    keys
    {
        key(Key1; "Header No.", "Account Type", "Account No.",Type, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Applies-to Doc. Type" := "applies-to doc. type"::Invoice;
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        EmplEntrySetApplID: Codeunit "Empl. Entry-SetAppl.ID";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        EmplLedgEntry: Record "Employee Ledger Entry";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        Text000: label '%1 or %2 must be a G/L Account or Bank Account.', Comment = '%1=Account Type,%2=Balance Account Type';
        Text001: label 'You must not specify %1 when %2 is %3.';
        Text002: label 'cannot be specified without %1';
        ChangeCurrencyQst: label 'The Currency Code in the Gen. Journal Line will be changed from %1 to %2.\\Do you want to continue?', Comment = '%1=FromCurrencyCode, %2=ToCurrencyCode';
        UpdateInterruptedErr: label 'The update has been interrupted to respect the warning.';
        Text006: label 'The %1 option can only be used internally in the system.';
        Text007: label '%1 or %2 must be a bank account.', Comment = '%1=Account Type,%2=Balance Account Type';
        Text008: label ' must be 0 when %1 is %2.';
        Text009: label 'LCY';
        Text010: label '%1 must be %2 or %3.';
        Text011: label '%1 must be negative.';
        Text012: label '%1 must be positive.';
        Text013: label 'The %1 must not be more than %2.';
        Text014: label 'The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?', Comment = '%1=Caption of Table Customer, %2=Customer No, %3=Caption of field Bill-to Customer No, %4=Value of Bill-to customer no.';
        Text015: label 'You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.';
        Text016: label '%1 must be G/L Account or Bank Account.';
        Text018: label '%1 can only be set when %2 is set.';
        Text019: label '%1 cannot be changed when %2 is set.';
        ExportAgainQst: label 'One or more of the selected lines have already been exported. Do you want to export them again?';
        NothingToExportErr: label 'There is nothing to export.';
        NotExistErr: label 'Document number %1 does not exist or is already closed.', Comment = '%1=Document number';
        DocNoFilterErr: label 'The document numbers cannot be renumbered while there is an active filter on the Document No. field.';
        DueDateMsg: label 'This posting date will cause an overdue payment.';
        CalcPostDateMsg: label 'Processing payment journal lines #1##########';
        NoEntriesToVoidErr: label 'There are no entries to void.';
        OnlyLocalCurrencyForEmployeeErr: label 'The value of the Currency Code field must be empty. General journal lines in foreign currency are not supported for employee account type.';
        GenJnlLine: Record "Document Line";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[10];
        PmtType: Record "Payment & Receipt Types";
        ReceiptHeader: Record "Receipt Header";
        PaymentHeader: Record "Payment Header";

    local procedure GetGLAccount()
    var
        GLAcc: Record "G/L Account";
    begin
        GLAcc.Get("Account No.");
        if ReceiptHeader.Get("Header No.") then begin
            if Description = '' then
                Description := StrSubstNo(GLAcc.Name + '-' + Format(ReceiptHeader."Pay Mode"));
        end;
    end;

    local procedure GetCustomerAccount()
    var
        Cust: Record Customer;
    begin
        Cust.Get("Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, "Document Type", false);
        Description := Cust.Name;

        "Member No." := Cust."No.";


        if ReceiptHeader.Get("Header No.") then
            if ReceiptHeader."Customer Type" = ReceiptHeader."Customer Type"::Customer then
                Description := ReceiptHeader.Narration;

        Description := StrSubstNo(Description + '-' + Format(ReceiptHeader."Pay Mode"));

    end;

    local procedure GetVendorAccount()
    var
        Vend: Record Vendor;
    begin
        Vend.Get("Account No.");
        Vend.CheckBlockedVendOnJnls(Vend, "Document Type", false);
       
        if ReceiptHeader.Get("Header No.") then begin
            if Description = '' then
                Description := StrSubstNo(Vend.Name + '-' + Format(ReceiptHeader."Pay Mode"));
        end;
     
    end;

    local procedure GetEmployeeAccount()
    var
        Employee: Record Employee;
    begin
        Employee.Get("Account No.");
        Description := StrSubstNo(Employee."First Name" + '-' + Format(ReceiptHeader."Pay Mode"));
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ClearCustVendApplnEntry()
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        TempEmplLedgEntry: Record "Employee Ledger Entry" temporary;
        AccType: Enum "Gen. Journal Account Type";
        AccNo: Code[20];
    begin
        AccType := "Account Type";
        AccNo := "Account No.";

        case AccType of
            Acctype::Customer:
                if xRec."Applies-to ID" <> '' then begin
                    if FindFirstCustLedgEntryWithAppliesToID(AccNo, xRec."Applies-to ID") then begin
                        ClearCustApplnEntryFields;
                        TempCustLedgEntry.DeleteAll;
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                    end
                end else
                    if xRec."Applies-to Doc. No." <> '' then
                        if FindFirstCustLedgEntryWithAppliesToDocNo(AccNo, xRec."Applies-to Doc. No.") then begin
                            ClearCustApplnEntryFields;
                            Codeunit.Run(Codeunit::"Cust. Entry-Edit", CustLedgEntry);
                        end;
            Acctype::Vendor:
                if xRec."Applies-to ID" <> '' then begin
                    if FindFirstVendLedgEntryWithAppliesToID(AccNo, xRec."Applies-to ID") then begin
                        ClearVendApplnEntryFields;
                        TempVendLedgEntry.DeleteAll;
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                    end
                end else
                    if xRec."Applies-to Doc. No." <> '' then
                        if FindFirstVendLedgEntryWithAppliesToDocNo(AccNo, xRec."Applies-to Doc. No.") then begin
                            ClearVendApplnEntryFields;
                            Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
                        end;
            Acctype::Employee:
                if xRec."Applies-to ID" <> '' then begin
                    if FindFirstEmplLedgEntryWithAppliesToID(AccNo, xRec."Applies-to ID") then begin
                        ClearEmplApplnEntryFields;
                        TempEmplLedgEntry.DeleteAll;
                        EmplEntrySetApplID.SetApplId(EmplLedgEntry, TempEmplLedgEntry, '');
                    end
                end else
                    if xRec."Applies-to Doc. No." <> '' then
                        if FindFirstEmplLedgEntryWithAppliesToDocNo(AccNo, xRec."Applies-to Doc. No.") then begin
                            ClearEmplApplnEntryFields;
                            Codeunit.Run(Codeunit::"Empl. Entry-Edit", EmplLedgEntry);
                        end;
        end;
    end;

    local procedure ClearCustApplnEntryFields()
    begin
        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        CustLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearVendApplnEntryFields()
    begin
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearEmplApplnEntryFields()
    begin
        EmplLedgEntry."Amount to Apply" := 0;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Customer No.", "Applies-to ID", Open);
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange("Applies-to ID", AppliesToID);
        CustLedgEntry.SetRange(Open, true);
        exit(CustLedgEntry.FindFirst)
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToDocNo(AccNo: Code[20]; AppliestoDocNo: Code[20]): Boolean
    begin
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Document No.");
        CustLedgEntry.SetRange("Document No.", AppliestoDocNo);
        CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        exit(CustLedgEntry.FindFirst)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Vendor No.", "Applies-to ID", Open);
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange("Applies-to ID", AppliesToID);
        VendLedgEntry.SetRange(Open, true);
        exit(VendLedgEntry.FindFirst)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToDocNo(AccNo: Code[20]; AppliestoDocNo: Code[20]): Boolean
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Document No.");
        VendLedgEntry.SetRange("Document No.", AppliestoDocNo);
        VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        exit(VendLedgEntry.FindFirst)
    end;

    local procedure FindFirstEmplLedgEntryWithAppliesToID(AccNo: Code[20]; AppliesToID: Code[50]): Boolean
    begin
        EmplLedgEntry.Reset;
        EmplLedgEntry.SetCurrentkey("Employee No.", "Applies-to ID", Open);
        EmplLedgEntry.SetRange("Employee No.", AccNo);
        EmplLedgEntry.SetRange("Applies-to ID", AppliesToID);
        EmplLedgEntry.SetRange(Open, true);
        exit(EmplLedgEntry.FindFirst)
    end;

    local procedure FindFirstEmplLedgEntryWithAppliesToDocNo(AccNo: Code[20]; AppliestoDocNo: Code[20]): Boolean
    begin
        EmplLedgEntry.Reset;
        EmplLedgEntry.SetCurrentkey("Document No.");
        EmplLedgEntry.SetRange("Document No.", AppliestoDocNo);
        EmplLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        EmplLedgEntry.SetRange("Employee No.", AccNo);
        EmplLedgEntry.SetRange(Open, true);
        exit(EmplLedgEntry.FindFirst)
    end;

    procedure SetApplyToAmount()
    begin
        case "Account Type" of
            "account type"::Customer:
                begin
                    CustLedgEntry.SetCurrentkey("Document No.");
                    CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                    CustLedgEntry.SetRange("Customer No.", "Account No.");
                    CustLedgEntry.SetRange(Open, true);
                    if CustLedgEntry.Find('-') then
                        if CustLedgEntry."Amount to Apply" = 0 then begin
                            CustLedgEntry.CalcFields("Remaining Amount");
                            CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
                            Codeunit.Run(Codeunit::"Cust. Entry-Edit", CustLedgEntry);
                        end;
                end;
            "account type"::Vendor:
                begin
                    VendLedgEntry.SetCurrentkey("Document No.");
                    VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                    VendLedgEntry.SetRange("Vendor No.", "Account No.");
                    VendLedgEntry.SetRange(Open, true);
                    if VendLedgEntry.Find('-') then
                        if VendLedgEntry."Amount to Apply" = 0 then begin
                            VendLedgEntry.CalcFields("Remaining Amount");
                            VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                            Codeunit.Run(Codeunit::"Vend. Entry-Edit", VendLedgEntry);
                        end;
                end;
            "account type"::Employee:
                begin
                    EmplLedgEntry.SetCurrentkey("Document No.");
                    EmplLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
                    EmplLedgEntry.SetRange("Employee No.", "Account No.");
                    EmplLedgEntry.SetRange(Open, true);
                    if EmplLedgEntry.Find('-') then
                        if EmplLedgEntry."Amount to Apply" = 0 then begin
                            EmplLedgEntry.CalcFields("Remaining Amount");
                            EmplLedgEntry."Amount to Apply" := EmplLedgEntry."Remaining Amount";
                            Codeunit.Run(Codeunit::"Empl. Entry-Edit", EmplLedgEntry);
                        end;
                end;
        end;
    end;

    procedure ClearAppliedGenJnlLine()
    var
        GenJournalLine: Record "Document Line";
    begin
        if "Applies-to Doc. No." = '' then
            exit;
        GenJournalLine.SetRange("Header No.", "Header No.");
        GenJournalLine.SetFilter("Line No.", '<>%1', "Line No.");
        GenJournalLine.SetRange("Document Type", "Applies-to Doc. Type");
        GenJournalLine.SetRange("Applies-to Doc. No.", "Applies-to Doc. No.");
        GenJournalLine.ModifyAll("Account No.", '');
    end;

    procedure GetCustLedgerEntry()
    begin
        if ("Account Type" = "account type"::Customer) and ("Account No." = '') and
           ("Applies-to Doc. No." <> '') and (Amount = 0)
        then begin
            CustLedgEntry.Reset;
            CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            CustLedgEntry.SetRange(Open, true);
            if not CustLedgEntry.FindFirst then
                Error(NotExistErr, "Applies-to Doc. No.");

            Validate("Account No.", CustLedgEntry."Customer No.");
            CustLedgEntry.CalcFields("Remaining Amount");

            if "Posting Date" <= CustLedgEntry."Pmt. Discount Date" then
                Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
            else
                Amount := -CustLedgEntry."Remaining Amount";

            //IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
            //UpdateCurrencyCode(CustLedgEntry."Currency Code");

            //SetAppliesToFields(
            //CustLedgEntry."Document Type", CustLedgEntry."Document No.", CustLedgEntry."External Document No.");


            Validate(Amount);
        end;
    end;

    procedure GetVendLedgerEntry()
    begin
        if ("Account Type" = "account type"::Vendor) and ("Account No." = '') and
           ("Applies-to Doc. No." <> '') and (Amount = 0)
        then begin
            VendLedgEntry.Reset;
            VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            VendLedgEntry.SetRange(Open, true);
            if not VendLedgEntry.FindFirst then
                Error(NotExistErr, "Applies-to Doc. No.");

            Validate("Account No.", VendLedgEntry."Vendor No.");
            VendLedgEntry.CalcFields("Remaining Amount");

            if "Posting Date" <= VendLedgEntry."Pmt. Discount Date" then
                Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
            else
                Amount := -VendLedgEntry."Remaining Amount";

            // IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
            // UpdateCurrencyCode(VendLedgEntry."Currency Code");

            //SetAppliesToFields(
            //  VendLedgEntry."Document Type", VendLedgEntry."Document No.", VendLedgEntry."External Document No.");


            Validate(Amount);
        end;
    end;

    procedure GetEmplLedgerEntry()
    begin
        if ("Account Type" = "account type"::Employee) and ("Account No." = '') and
           ("Applies-to Doc. No." <> '') and (Amount = 0)
        then begin
            EmplLedgEntry.Reset;
            EmplLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            EmplLedgEntry.SetRange(Open, true);
            if not EmplLedgEntry.FindFirst then
                Error(NotExistErr, "Applies-to Doc. No.");

            Validate("Account No.", EmplLedgEntry."Employee No.");
            EmplLedgEntry.CalcFields("Remaining Amount");

            Amount := -EmplLedgEntry."Remaining Amount";

            //  SetAppliesToFields(EmplLedgEntry."Document Type", EmplLedgEntry."Document No.", '');

            Validate(Amount);
        end;
    end;

    local procedure SetAppliesToFields(DocType: Option; DocNo: Code[20]; ExtDocNo: Code[35])
    begin
        "Document Type" := "document type"::Payment;
        //"Applies-to Doc. Type" := DocType;
        "Applies-to Doc. No." := DocNo;
        "Applies-to ID" := '';

        /*
        IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice) AND
           ("Document Type" = "Document Type"::Payment)
        THEN
          "External Document No." := ExtDocNo;
        "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
        */

    end;

    procedure ValidateApplyRequirements(TempGenJnlLine: Record "Document Line" temporary)
    begin


        case TempGenJnlLine."Account Type" of
            TempGenJnlLine."account type"::Customer:
                if TempGenJnlLine."Applies-to ID" <> '' then begin
                    CustLedgEntry.SetCurrentkey("Customer No.", "Applies-to ID", Open);
                    CustLedgEntry.SetRange("Customer No.", TempGenJnlLine."Account No.");
                    CustLedgEntry.SetRange("Applies-to ID", TempGenJnlLine."Applies-to ID");
                    CustLedgEntry.SetRange(Open, true);
                    if CustLedgEntry.Find('-') then
                        repeat
                            if TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" then
                                Error(
                                  Text015, TempGenJnlLine."Document Type", TempGenJnlLine."Header No.",
                                  CustLedgEntry."Document Type", CustLedgEntry."Document No.");
                        until CustLedgEntry.Next = 0;
                end else
                    if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                        CustLedgEntry.SetCurrentkey("Document No.");
                        CustLedgEntry.SetRange("Document No.", TempGenJnlLine."Applies-to Doc. No.");
                        if TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."applies-to doc. type"::" " then
                            CustLedgEntry.SetRange("Document Type", TempGenJnlLine."Applies-to Doc. Type");
                        CustLedgEntry.SetRange("Customer No.", TempGenJnlLine."Account No.");
                        CustLedgEntry.SetRange(Open, true);
                        if CustLedgEntry.Find('-') then
                            if TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" then
                                Error(
                                  Text015, TempGenJnlLine."Document Type", TempGenJnlLine."Header No.",
                                  CustLedgEntry."Document Type", CustLedgEntry."Document No.");
                    end;
            TempGenJnlLine."account type"::Vendor:
                if TempGenJnlLine."Applies-to ID" <> '' then begin
                    VendLedgEntry.SetCurrentkey("Vendor No.", "Applies-to ID", Open);
                    VendLedgEntry.SetRange("Vendor No.", TempGenJnlLine."Account No.");
                    VendLedgEntry.SetRange("Applies-to ID", TempGenJnlLine."Applies-to ID");
                    VendLedgEntry.SetRange(Open, true);
                    repeat
                        if TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" then
                            Error(
                              Text015, TempGenJnlLine."Document Type", TempGenJnlLine."Header No.",
                              VendLedgEntry."Document Type", VendLedgEntry."Document No.");
                    until VendLedgEntry.Next = 0;
                    if VendLedgEntry.Find('-') then
                        ;
                end else
                    if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                        VendLedgEntry.SetCurrentkey("Document No.");
                        VendLedgEntry.SetRange("Document No.", TempGenJnlLine."Applies-to Doc. No.");
                        if TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."applies-to doc. type"::" " then
                            VendLedgEntry.SetRange("Document Type", TempGenJnlLine."Applies-to Doc. Type");
                        VendLedgEntry.SetRange("Vendor No.", TempGenJnlLine."Account No.");
                        VendLedgEntry.SetRange(Open, true);
                        if VendLedgEntry.Find('-') then
                            if TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" then
                                Error(
                                  Text015, TempGenJnlLine."Document Type", TempGenJnlLine."Header No.",
                                  VendLedgEntry."Document Type", VendLedgEntry."Document No.");
                    end;
            TempGenJnlLine."account type"::Employee:
                if TempGenJnlLine."Applies-to ID" <> '' then begin
                    EmplLedgEntry.SetCurrentkey("Employee No.", "Applies-to ID", Open);
                    EmplLedgEntry.SetRange("Employee No.", TempGenJnlLine."Account No.");
                    EmplLedgEntry.SetRange("Applies-to ID", TempGenJnlLine."Applies-to ID");
                    EmplLedgEntry.SetRange(Open, true);
                    repeat
                        if TempGenJnlLine."Posting Date" < EmplLedgEntry."Posting Date" then
                            Error(
                              Text015, TempGenJnlLine."Document Type", TempGenJnlLine."Header No.",
                              EmplLedgEntry."Document Type", EmplLedgEntry."Document No.");
                    until EmplLedgEntry.Next = 0;
                    if EmplLedgEntry.Find('-') then
                        ;
                end else
                    if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                        EmplLedgEntry.SetCurrentkey("Document No.");
                        EmplLedgEntry.SetRange("Document No.", TempGenJnlLine."Applies-to Doc. No.");
                        if TempGenJnlLine."Applies-to Doc. Type" <> EmplLedgEntry."applies-to doc. type"::" " then
                            EmplLedgEntry.SetRange("Document Type", TempGenJnlLine."Applies-to Doc. Type");
                        EmplLedgEntry.SetRange("Employee No.", TempGenJnlLine."Account No.");
                        EmplLedgEntry.SetRange(Open, true);
                        if EmplLedgEntry.Find('-') then
                            if TempGenJnlLine."Posting Date" < EmplLedgEntry."Posting Date" then
                                Error(
                                  Text015, TempGenJnlLine."Document Type", TempGenJnlLine."Header No.",
                                  EmplLedgEntry."Document Type", EmplLedgEntry."Document No.");
                    end;
        end;
    end;


    procedure UpdateAppliesToInvoiceID()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if "Applies-to Doc. Type" <> "applies-to doc. type"::Invoice then
            exit;

        if "Applies-to Doc. No." = '' then begin
            Clear("Applies-to Invoice Id");
            exit;
        end;

        if not SalesInvoiceHeader.Get("Applies-to Doc. No.") then
            exit;

        //"Applies-to Invoice Id" := SalesInvoiceHeader.Id;
    end;

    local procedure UpdateAppliesToInvoiceNo()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        if IsNullGuid("Applies-to Invoice Id") then
            exit;

        // SalesInvoiceHeader.SetRange(Id, "Applies-to Invoice Id");
        if not SalesInvoiceHeader.FindFirst then
            exit;

        "Applies-to Doc. No." := SalesInvoiceHeader."No.";
    end;


    procedure LookUpAppliesToDocCust(AccNo: Code[20])
    var
        ApplyCustEntries: Page "Apply Customer Entries";
    begin
        Clear(CustLedgEntry);
        CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if CustLedgEntry.IsEmpty then begin
                CustLedgEntry.SetRange("Document Type");
                CustLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange("Document Type");
        end;
        if Amount <> 0 then begin
            CustLedgEntry.SetRange(Positive, Amount < 0);
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange(Positive);
        end;
        //ApplyCustEntries.SetDocumentLine(Rec, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyCustEntries.SetTableview(CustLedgEntry);
        ApplyCustEntries.SetRecord(CustLedgEntry);
        ApplyCustEntries.LookupMode(true);
        if ApplyCustEntries.RunModal = Action::LookupOK then begin
            ApplyCustEntries.GetRecord(CustLedgEntry);
            if AccNo = '' then begin
                AccNo := CustLedgEntry."Customer No.";
                Validate("Account No.", AccNo);
            end;
            SetAmountWithCustLedgEntry;
            "Applies-to Doc. Type" := CustLedgEntry."Document Type";
            "Applies-to Doc. No." := CustLedgEntry."Document No.";
            "Applies-to ID" := '';
        end;
    end;


    procedure LookUpAppliesToDocVend(AccNo: Code[20])
    var
        ApplyVendEntries: Page "Apply Vendor Entries - New";
    begin
        Clear(VendLedgEntry);
        VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.IsEmpty then begin
                VendLedgEntry.SetRange("Document Type");
                VendLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Document Type");
        end;
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Document No.");
        end;
        if Amount <> 0 then begin
            VendLedgEntry.SetRange(Positive, Amount < 0);
            if VendLedgEntry.IsEmpty then;
            VendLedgEntry.SetRange(Positive);
        end;
        //ApplyVendEntries.SetDocumentLine(Rec, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyVendEntries.SetTableview(VendLedgEntry);
        ApplyVendEntries.SetRecord(VendLedgEntry);
        ApplyVendEntries.LookupMode(true);
        if ApplyVendEntries.RunModal = Action::LookupOK then begin
            ApplyVendEntries.GetRecord(VendLedgEntry);
            if AccNo = '' then begin
                AccNo := VendLedgEntry."Vendor No.";
                Validate("Account No.", AccNo);
            end;
            SetAmountWithVendLedgEntry;
            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
            "Applies-to Doc. No." := VendLedgEntry."Document No.";
            "Applies-to ID" := '';
        end;
    end;


    procedure LookUpAppliesToDocEmpl(AccNo: Code[20])
    var
        ApplyEmplEntries: Page "Apply Employee Entries";
    begin
        Clear(EmplLedgEntry);
        EmplLedgEntry.SetCurrentkey("Employee No.", Open, Positive);
        if AccNo <> '' then
            EmplLedgEntry.SetRange("Employee No.", AccNo);
        EmplLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            EmplLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            EmplLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if EmplLedgEntry.IsEmpty then begin
                EmplLedgEntry.SetRange("Document Type");
                EmplLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            EmplLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if EmplLedgEntry.IsEmpty then
                EmplLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            EmplLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if EmplLedgEntry.IsEmpty then
                EmplLedgEntry.SetRange("Document Type");
        end;
        if "Applies-to Doc. No." <> '' then begin
            EmplLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if EmplLedgEntry.IsEmpty then
                EmplLedgEntry.SetRange("Document No.");
        end;
        if Amount <> 0 then begin
            EmplLedgEntry.SetRange(Positive, Amount < 0);
            if EmplLedgEntry.IsEmpty then;
            EmplLedgEntry.SetRange(Positive);
        end;
        //ApplyEmplEntries.SetDocumentLine(Rec, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyEmplEntries.SetTableview(EmplLedgEntry);
        ApplyEmplEntries.SetRecord(EmplLedgEntry);
        ApplyEmplEntries.LookupMode(true);
        if ApplyEmplEntries.RunModal = Action::LookupOK then begin
            ApplyEmplEntries.GetRecord(EmplLedgEntry);
            if AccNo = '' then begin
                AccNo := EmplLedgEntry."Employee No.";
                Validate("Account No.", AccNo);
            end;
            SetAmountWithEmplLedgEntry;
            "Applies-to Doc. Type" := EmplLedgEntry."Document Type";
            "Applies-to Doc. No." := EmplLedgEntry."Document No.";
            "Applies-to ID" := '';
        end;
    end;

    local procedure SetAmountWithCustLedgEntry()
    begin
        //IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
        //CheckModifyCurrencyCode(GenJnlLine."Account Type"::Customer,CustLedgEntry."Currency Code");


        if Amount = 0 then begin
            CustLedgEntry.CalcFields("Remaining Amount");
            //SetAmountWithRemaining(
            // PaymentToleranceMgt.CheckCalcPmtDiscDocumentLineCust(Rec, CustLedgEntry, 0, false),
            //CustLedgEntry."Amount to Apply", CustLedgEntry."Remaining Amount", CustLedgEntry."Remaining Pmt. Disc. Possible");
        end;
    end;

    local procedure SetAmountWithVendLedgEntry()
    begin
        //IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
        //CheckModifyCurrencyCode("Account Type"::Vendor,VendLedgEntry."Currency Code");

        if Amount = 0 then begin
            VendLedgEntry.CalcFields("Remaining Amount");
            //SetAmountWithRemaining(
            //PaymentToleranceMgt.CheckCalcPmtDiscDocumentLineVend(Rec, VendLedgEntry, 0, false),
            //VendLedgEntry."Amount to Apply", VendLedgEntry."Remaining Amount", VendLedgEntry."Remaining Pmt. Disc. Possible");
        end;
    end;

    local procedure SetAmountWithEmplLedgEntry()
    begin
        if Amount = 0 then begin
            EmplLedgEntry.CalcFields("Remaining Amount");
            SetAmountWithRemaining(false, EmplLedgEntry."Amount to Apply", EmplLedgEntry."Remaining Amount", 0.0);
        end;
    end;

    local procedure SetAmountWithRemaining(CalcPmtDisc: Boolean; AmountToApply: Decimal; RemainingAmount: Decimal; RemainingPmtDiscPossible: Decimal)
    begin
        if AmountToApply <> 0 then
            if CalcPmtDisc and (Abs(AmountToApply) >= Abs(RemainingAmount - RemainingPmtDiscPossible)) then
                Amount := -(RemainingAmount - RemainingPmtDiscPossible)
            else
                Amount := -AmountToApply
        else
            if CalcPmtDisc then
                Amount := -(RemainingAmount - RemainingPmtDiscPossible)
            else
                Amount := -RemainingAmount;
        //IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor] THEN
        //Amount := -Amount;
        Validate(Amount);
    end;

    procedure ShowDimensions()
    begin
        //"Dimension Set ID" :=
        //DimMgt.EditDimensionSet2(
        //"Dimension Set ID", StrSubstNo('%1 %2 %3', "Header No.", "Line No.", "Account No."),
        //"Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    local procedure SetCurrencyCode(AccType2: Option "G/L Account",Customer,Vendor,"Bank Account"; AccNo2: Code[20]): Boolean
    var
        BankAcc: Record "Bank Account";
    begin
        "Currency Code" := '';
        if AccNo2 <> '' then
            if AccType2 = Acctype2::"Bank Account" then
                if BankAcc.Get(AccNo2) then
                    "Currency Code" := BankAcc."Currency Code";
        exit("Currency Code" <> '');
    end;

    procedure SetCurrencyFactor(CurrencyCode: Code[10]; CurrencyFactor: Decimal)
    begin
        "Currency Code" := CurrencyCode;
        if "Currency Code" = '' then
            "Currency Factor" := 1
        else
            "Currency Factor" := CurrencyFactor;
    end;

    local procedure GetCurrency()
    begin
        /*
        IF "Additional-Currency Posting" =
           "Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
          IF GLSetup."Additional Reporting Currency" = '' THEN
            ReadGLSetup;
          CurrencyCode := GLSetup."Additional Reporting Currency";
        END ELSE
        */
        CurrencyCode := "Currency Code";

        if CurrencyCode = '' then begin
            Clear(Currency);
            Currency.InitRoundingPrecision
        end else
            if CurrencyCode <> Currency.Code then begin
                Currency.Get(CurrencyCode);
                Currency.TestField("Amount Rounding Precision");
            end;

    end;

    local procedure UpdateAmounts()
    begin
        "Withholding Tax" := 0;
        "Withholding VAT" := 0;
        "Tax Amount" := 0;
        "VAT Amount" := 0;
        "Net Amount" := 0;

        if "Taxable Amount" > 0 then begin

            PmtType.Get(Type);
            "VAT Amount" := ROUND(PmtType."VAT %" / 100 * "Taxable Amount", 1, '>');
            "Withholding VAT" := ROUND(PmtType."Withholding VAT %" / 100 * "Taxable Amount", 1, '>');
            "Tax Amount" := ROUND(PmtType."Tax %" / 100 * "Taxable Amount", 1, '>');
            "Withholding Tax" := ROUND(PmtType."Withholding Tax %" / 100 * "Taxable Amount", 1, '>');
            "Net Amount" := Amount - "Withholding Tax" - "Withholding VAT" - "Tax Amount";

        end;
    end;


    procedure GetNewLineNo(): Integer
    var
        DocumentLine: Record "Document Line";
    begin
        /*
        DocumentLine.VALIDATE("Journal Template Name",TemplateName);
        DocumentLine.VALIDATE("Journal Batch Name",BatchName);
        DocumentLine.SETRANGE("Journal Template Name",TemplateName);
        DocumentLine.SETRANGE("Journal Batch Name",BatchName);
        IF DocumentLine.FINDLAST THEN
          EXIT(DocumentLine."Line No." + 10000);
        EXIT(10000);
        */

    end;


    trigger OnModify()
    var
        myInt: Integer;
    begin

        if ReceiptHeader.Get("Header No.") then begin
            ReceiptHeader.TestField(Status, ReceiptHeader.Status::Open);
        end;
    end;

    trigger OnDelete()
    var
        myInt: Integer;
    begin

        if ReceiptHeader.Get("Header No.") then begin
            ReceiptHeader.TestField(Status, ReceiptHeader.Status::Open);
        end;
    end;
}
