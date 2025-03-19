Table 50003 "Payment Header"
{
    DrillDownPageID = "PV List";
    LookupPageID = "PV List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the payment voucher in the database';
            NotBlank = false;
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the date when the payment voucher was inserted into the system';

            trigger OnValidate()
            begin

                UpdateCurrencyFactor;

                //Update Payment Lines
                UpdateLines();
            end;
        }
        field(3; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(4; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                //if PayLinesExist then
                //  Error('You first need to delete the existing Payment lines before changing the Currency Code');


                UpdateCurrencyFactor;
                //Update Payment Lines
                UpdateLines();
            end;
        }
        field(9; Payee; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the person who received the money';
        }
        field(10; "On Behalf Of"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the person on whose behalf the payment voucher was taken';
        }
        field(11; Cashier; Code[80])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the identifier of the cashier in the database';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(16; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Stores whether the payment voucher is posted or not';
            Editable = false;
        }
        field(17; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the date when the payment voucher was posted';
            Editable = false;
        }
        field(18; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the time when the payment voucher was posted';
            Editable = false;
        }
        field(19; "Posted By"; Code[80])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the person who posted the payment voucher';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(20; "Total Payment Amount"; Decimal)
        {
            CalcFormula = sum("Document Line".Amount where("Header No." = field("No.")));
            Description = 'Stores the amount of the payment voucher';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Paying Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the paying bank account in the database';
            Editable = true;
            TableRelation = if ("Payment Type" = filter(<> "Petty Cash"),
                                "Paying Account Type" = const("Bank Account")) "Bank Account"."No." where("Currency Code" = field("Currency Code"))
            else
            if ("Payment Type" = const("Petty Cash"),
                                         "Paying Account Type" = const("Bank Account")) "Bank Account"."No." where("Currency Code" = field("Currency Code"));


            trigger OnValidate()
            begin

                BankAcc.Reset;
                "Bank Name" := '';

                if "Paying Bank Account" <> '' then
                    if "Paying Account Type" = "paying account type"::"Bank Account" then begin
                        BankAcc.Get("Paying Bank Account");
                        /*
                          IF "Pay Mode"="Pay Mode"::Cash THEN BEGIN
                              IF (BankAcc."Bank Type"<>BankAcc."Bank Type"::Cash) THEN
                                  IF (BankAcc."Bank Type"<>BankAcc."Bank Type"::"Petty Cash") THEN
                                      IF (BankAcc."Bank Type"<>BankAcc."Bank Type"::Cashier) THEN
                                          ERROR('This Payment can only be made against Banks Handling Cash');
                          END;
                          */
                        BankAcc.CalcFields(BankAcc."Balance (LCY)", BankAcc.Balance);

                        "Account Balance" := BankAcc."Balance (LCY)";
                        "Bank Name" := BankAcc.Name;
                        "Currency Code" := BankAcc."Currency Code";
                        Validate("Currency Code");
                    end;

                //For GL Accounts

                if "Paying Bank Account" <> '' then
                    if "Paying Account Type" = "paying account type"::"G/L Account" then begin
                        GLAcc.Get("Paying Bank Account");

                        GLAcc.CalcFields(GLAcc.Balance);

                        "Account Balance" := GLAcc.Balance;
                        "Bank Name" := GLAcc.Name;
                    end;



                PLine.Reset;
                PLine.SetRange(PLine."Header No.", "No.");
                PLine.SetRange(PLine."Account Type", PLine."account type"::"Bank Account");
                PLine.SetRange(PLine."Account No.", "Paying Bank Account");
                //if PLine.FindFirst then
                //Error(Text002);

            end;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 1);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    "Function Name" := DimVal.Name;
                UpdateLines;

                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }

        field(31; "Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(35; Status; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the status of the record in the database';
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(38; "Payment Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Normal,Petty Cash,Express,Cash Purchase,Benevolent Claim,Board,Staff,Member';
            OptionMembers = Normal,"Petty Cash",Express,"Cash Purchase","Benevolent Claim",Board,Staff,Member;

            trigger OnValidate()
            begin


                UserSetup.Get(UserId);
                UserSetup.TestField("Global Dimension 1 Code");
                UserSetup.TestField("Global Dimension 2 Code");
                "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";

                if ("Payment Type" = "payment type"::"Petty Cash") or ("Payment Type" = "payment type"::Member) then begin
                    "Paying Account Type" := "paying account type"::"Bank Account";
                    "Paying Bank Account" := UserSetup."Default Petty Cash Bank";
                end else begin
                    "Paying Account Type" := "paying account type"::"Bank Account";
                    "Paying Bank Account" := UserSetup."Default Payment Bank";
                    "Cheque Type" := "cheque type"::"Manual Check";
                end;

                if "Payment Type" = "payment type"::Board then begin
                    "Paying Account Type" := "paying account type"::"G/L Account";
                    "Paying Bank Account" := UserSetup."Default Petty Cash Bank";
                end else
                    if "Payment Type" = "payment type"::Staff then begin
                        "Paying Account Type" := "paying account type"::"G/L Account";
                        "Paying Bank Account" := UserSetup."Default Petty Cash Bank";
                    end;
            end;
        }
        field(56; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal."Global Dimension No.", 2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 2 Code");
                if DimVal.Find('-') then
                    "Budget Center Name" := DimVal.Name;
                UpdateLines;
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(57; "Function Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the function in the database';
        }
        field(58; "Budget Center Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the budget center in the database';
        }
        field(59; "Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the description of the paying bank account in the database';
        }
        field(60; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the number series in the database';
        }
        field(61; Select; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Enables the user to select a particular record';
        }
        field(62; "Total VAT Amount"; Decimal)
        {
            CalcFormula = sum("Document Line"."VAT Amount" where("Header No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Total Witholding Tax Amount"; Decimal)
        {
            CalcFormula = sum("Document Line"."Withholding Tax" where("Header No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Total Net Amount"; Decimal)
        {
            CalcFormula = sum("Document Line"."Net Amount" where("Header No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Current Status"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the current status of the payment voucher in the database';
        }
        field(66; "Cheque No."; Code[6])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Ordinary Cheque Register"."Ordinary Cheque No." where(Issued = const(false));

            trigger OnValidate()
            begin
                if "Pay Mode" = "pay mode"::Cash then
                    Error('You CANNOT insert cheque No. If the Pay Mode is Cash');
            end;
        }
        field(67; "Pay Mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash,Cheque,EFT,Letter of Credit,Mpesa,Custom 4,Custom 5';
            OptionMembers = " ",Cash,Cheque,EFT,"Letter of Credit",Mpesa,"Fosa Account";

            trigger OnValidate()
            begin

                case "Pay Mode" of
                    "pay mode"::"Fosa Account":
                        "Account Type" := "account type"::Savings;

                    "pay mode"::Cheque:
                        "Account Type" := "account type"::"Bank Account";
                end;
            end;
        }
        field(68; "Payment Release Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //Changed to ensure Release date is not less than the Date entered
                if "Payment Release Date" < Date then
                    Error('The Payment Release Date cannot be lesser than the Document Date');
                if "Payment Release Date" > today then
                    Error('The Payment Release Date cannot be a future Date');
            end;
        }
        field(69; "No. Printed"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "VAT Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(71; "Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(72; "Currency Reciprical"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(73; "Current Source A/C Bal."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(74; "Cancellation Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(75; "Register Number"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(76; "From Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(77; "To Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(78; "Invoice Currency Code"; Code[10])
        {
            Caption = 'Invoice Currency Code';
            DataClassification = ToBeClassified;
            Editable = true;
            TableRelation = Currency;
        }
        field(80; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Payment Voucher","Petty Cash","Cash Purchase";
        }
        field(81; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(3, "Shortcut Dimension 3 Code");
                Validate("Shortcut Dimension 3 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name;
            end;
        }
        field(82; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';

            trigger OnLookup()
            begin
                LookupShortcutDimCode(4, "Shortcut Dimension 4 Code");
                Validate("Shortcut Dimension 4 Code");
            end;

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(83; Dim3; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(84; Dim4; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(86; "Cheque Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Computer Check","Manual Check";
        }
        field(88; "Payment Narration"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Invoice No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Holds The Purchase invoice number if it is related to purch invoice, does not post';
        }
        field(105; "Creation Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(106; "Creation Doc Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Advance,Claim,Payment Request,Investment';
            OptionMembers = Advance,Claim,"Payment Request",Investment;
        }

        field(150; "Account Type"; Option)
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(151; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false),
                                                                                          "Direct Posting" = const(true))
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin

                case "Pay Mode" of
                    "pay mode"::"Fosa Account":
                        begin

                            if Savings.Get("Account No.") then begin
                                "Bank Name" := Savings.Name;
                            end;
                        end;
                    "pay mode"::Cheque:
                        begin
                            if AccountB.Get("Account No.") then begin
                                "Bank Name" := AccountB.Name;
                            end;
                        end;
                end;

                if "Payment Type" = "payment type"::"Benevolent Claim" then begin
                    if Savings.Get("Account No.") then begin
                        "Bank Name" := Savings.Name;
                    end;
                    if AccountB.Get("Account No.") then begin
                        "Bank Name" := AccountB.Name;
                    end;
                end;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions
            end;
        }
        field(481; "External Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50000; "VAT Wthheld six %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Member No."; Code[80])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                if AccountM.Get("Member No.") then begin
                    Name := AccountM.Name;
                end;
            end;
        }
        field(50002; Name; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50004; "Total VAT Withholding Amount"; Decimal)
        {
            CalcFormula = sum("Document Line"."Withholding VAT" where("Header No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Paying Account Type"; Enum "Gen. Journal Account Type")
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Account Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Cheque Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Type of Cheque"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Ordinary,Bankers';
            OptionMembers = " ",Ordinary,Bankers;
        }

        field(50010; "Member Exit Deposits"; Decimal)
        {
            DataClassification = ToBeClassified;
        }

        field(50011; "Invoice Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Created By Doc No Closure"; Code[20])
        {
            DataClassification = ToBeClassified;
        }

        field(50013; "Document Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Document Attached" then
                    "Document Attached By" := UserId;
            end;
        }
        field(50014; "Document Attached By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }

        field(50015; "Total Tax Amount"; Decimal)
        {
            CalcFormula = sum("Document Line"."Tax Amount" where("Header No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; "Send SMS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    trigger OnModify()
    var
        pay: record "Payment Header";
    begin
        if Status <> Status::Pending then
            TestField(Posted, false);
    End;

    trigger OnInsert()
    var
        pay: record "Payment Header";
    begin
        if pay.Get('') then begin
            pay.Delete();
            Commit();
        end;

        //if "Payment Type" <> "Payment Type"::"Petty Cash" then
        //  "Payment Type" := "payment type"::Normal;


        "Paying Account Type" := "Paying Account Type"::"Bank Account";

        //MESSAGE('%1',"Payment Type");

        if "No." = '' then begin
            NoSetup.Get;
            if "Payment Type" = "payment type"::Normal then begin
                NoSetup.TestField(NoSetup."Payment Voucher Nos");
                "No. Series" := NoSetup."Payment Voucher Nos";
                if NoSeriesMgt.AreRelated(NoSetup."Payment Voucher Nos", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "No." := NoSeriesMgt.GetNextNo("No. Series");
            end
            else
                if "Payment Type" = "payment type"::Board then begin
                    NoSetup.TestField(NoSetup."Board PVs Nos.");
                    "No. Series" := NoSetup."Board PVs Nos.";
                    if NoSeriesMgt.AreRelated(NoSetup."Board PVs Nos.", xRec."No. Series") then
                        "No. Series" := xRec."No. Series";
                    "No." := NoSeriesMgt.GetNextNo("No. Series");
                end
                else
                    if "Payment Type" = "payment type"::Member then begin
                        NoSetup.TestField(NoSetup."Member PV Nos");
                        "No. Series" := NoSetup."Member PV Nos";
                        if NoSeriesMgt.AreRelated(NoSetup."Member PV Nos", xRec."No. Series") then
                            "No. Series" := xRec."No. Series";
                        "No." := NoSeriesMgt.GetNextNo("No. Series");
                    end
                    else
                        if "Payment Type" = "payment type"::"Petty Cash" then begin
                            NoSetup.TestField(NoSetup."Petty Cash Nos");
                            "No. Series" := NoSetup."Petty Cash Nos";
                            if NoSeriesMgt.AreRelated(NoSetup."Petty Cash Nos", xRec."No. Series") then
                                "No. Series" := xRec."No. Series";
                            "No." := NoSeriesMgt.GetNextNo("No. Series");
                        end
                        else
                            if "Payment Type" = "payment type"::"Benevolent Claim" then begin
                                NoSetup.TestField("Benevolent Claim Nos");
                                "No. Series" := NoSetup."Benevolent Claim Nos";
                                if NoSeriesMgt.AreRelated(NoSetup."Benevolent Claim Nos", xRec."No. Series") then
                                    "No. Series" := xRec."No. Series";
                                "No." := NoSeriesMgt.GetNextNo("No. Series");
                            end
                            else
                                if "Payment Type" = "payment type"::Staff then begin
                                    NoSetup.TestField("Staff PV Nos.");
                                    "No. Series" := NoSetup."Staff PV Nos.";
                                    if NoSeriesMgt.AreRelated(NoSetup."Staff PV Nos.", xRec."No. Series") then
                                        "No. Series" := xRec."No. Series";
                                    "No." := NoSeriesMgt.GetNextNo("No. Series");
                                end;
        end;




        UserSetup.Get(UserId);
        UserSetup.TestField("Global Dimension 1 Code");
        UserSetup.TestField("Global Dimension 2 Code");
        "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";

        if "Payment Type" = "payment type"::"Petty Cash" then begin
            "Paying Account Type" := "paying account type"::"Bank Account";
            "Paying Bank Account" := UserSetup."Default Petty Cash Bank";
        end else begin
            "Paying Account Type" := "paying account type"::"Bank Account";
            "Paying Bank Account" := UserSetup."Default Payment Bank";
            "Cheque Type" := "cheque type"::"Manual Check";
        end;


        if "Paying Bank Account" <> '' then
            Validate("Paying Bank Account");



        Date := Today;
        Validate(Date);
        Cashier := UserId;
        Validate(Cashier);
        "Payment Release Date" := Date;


    end;

    var
        CStatus: Code[20];
        UserSetup: Record "User Setup";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        FA: Record "Fixed Asset";
        BankAcc: Record "Bank Account";
        NoSeriesMgt: Codeunit "No. Series";
        NoSetup: Record "Sales & Receivables Setup";
        RecPayTypes: Record "Payment & Receipt Types";
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        SingleMonth: Boolean;
        DateFrom: Date;
        DateTo: Date;
        Budget: Decimal;
        CurrMonth: Code[10];
        CurrYR: Code[10];
        BudgDate: Text[30];
        BudgetDate: Date;
        YrBudget: Decimal;
        BudgetDateTo: Date;
        BudgetAvailable: Decimal;
        GenLedSetup: Record "General Ledger Setup";
        "Total Budget": Decimal;
        CommittedAmount: Decimal;
        MonthBudget: Decimal;
        Expenses: Decimal;
        Header: Text[250];
        "Date From": Text[30];
        "Date To": Text[30];
        LastDay: Date;
        TotAmt: Decimal;
        DimVal: Record "Dimension Value";
        PLine: Record "Document Line";
        CurrExchRate: Record "Currency Exchange Rate";
        PayLine: Record "Document Line";
        DimMgt: Codeunit DimensionManagement;
        Savings: Record Vendor;
        AccountB: Record "Bank Account";
        AccountM: Record Customer;
        Text001: label 'Your identification is set up to process from %1 %2 only.';
        Text002: label 'There is an Account number on the  payment lines the same as Paying Bank Account you are trying to select.';

    local procedure UpdateCurrencyFactor()
    var
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            CurrencyDate := Date;
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;


    procedure UpdateLines()
    begin
        PLine.Reset;
        PLine.SetRange("Header No.", "No.");
        if PLine.FindFirst then begin
            repeat
                PLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                PLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                PLine."Dimension Set ID" := "Dimension Set ID";
                PLine."Currency Factor" := "Currency Factor";
                PLine.Validate("Currency Factor");
                PLine.Modify;
            until PLine.Next = 0;
        end;
    end;


    procedure PayLinesExist(): Boolean
    begin
        PayLine.Reset;
        PayLine.SetRange("Header No.", "No.");
        exit(PayLine.FindFirst);
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', 'Payments', "No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure ImportPVLinesFromExcel()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileName: Text;
        ServerFileName: Text;
        SheetName: Text;
        FileMgt: Codeunit "File Management";
        OpenObjectFile: label 'Open Object Text File';
        SaveObjectFile: label 'Save Object Text File';
        OpenExcelFile: label 'Open Excel File';
        TextFileFilter: label 'Text Files (*.txt)|*.txt|All Files (*.*)|*.*';
        ExcelFileFilter: label 'Excel Files (*.xls*)|*.xls*|All Files (*.*)|*.*';
        MenuSuiteProcess: label 'Updating MenuSuite';
        ReplacingProcess: label 'Replacing';
        ReadingFile: label 'Reading File';
        WritingFile: label 'Writing File';
        ReadingLines: label 'Reading Lines';
        TypeNotFoundError: label 'Type %1 not found';
        RenumberLines: label 'Renumbering Lines';
        NoOfLines: label 'No. of Lines';
        CurrentLine: label 'Current Line No.';
        OpeningExcel: label 'Opening Excel';
        AvailableObject: label 'Available Object';
        FindAvailableObjects: label 'Finding Available Objects';
        CreatingSuggestion: label 'Creating Suggestion';
        UploadingFile: label 'Uploading File to the Server temporary storage';
        UseInMemoryObjects: label 'Object are in memory, use them ?';
        Window: Dialog;
        WindowLastUpdated: DateTime;
        Counter: Integer;
        Total: Integer;
        FromFolder: Text;
        Buffer: Record "Document Line";
        PmtType: Record "Payment & Receipt Types";
        Fosa: Record Vendor;
    begin
        //FileName := FileMgt.OpenFileDialog(OpenExcelFile,FileName,ExcelFileFilter);

        File.Upload(OpenExcelFile, FromFolder, ExcelFileFilter, FileName, ServerFileName);

        if not File.Exists(ServerFileName) then exit;

        //ServerFileName := FileMgt.UploadFileSilent(FileName);

        Buffer.Reset();
        Buffer.SetRange("Header No.", "No.");
        if Buffer.FindFirst() then
            Buffer.DeleteAll();

        SheetName := TempExcelBuffer.SelectSheetsName(ServerFileName);
        TempExcelBuffer.OpenBook(ServerFileName, SheetName);
        TempExcelBuffer.ReadSheet;
        TempExcelBuffer.SetFilter("Row No.", '>%1', 1);
        Total := TempExcelBuffer.Count;
        Counter := 0;
        Window.Open(
          ReadingFile + ' @1@@@@@@@@@@@@@@@@@@@@@@@@\' +
          CurrentLine + ' #2#######\' +
          NoOfLines + '#3#######');
        Window.Update(3, Total);
        WindowLastUpdated := CurrentDatetime;

        if TempExcelBuffer.Find('-') then
            repeat
                Counter += 1;

                case TempExcelBuffer."Column No." of
                    1:
                        begin

                            Buffer.Init;
                            Buffer."Line No." := Counter;
                            Buffer."Header No." := "No.";
                            Fosa.get(TempExcelBuffer."Cell Value as Text");
                            PmtType.Reset();
                            PmtType.SetRange("Default Grouping", Fosa."Vendor Posting Group");
                            PmtType.SetRange(Type, PmtType.Type::Payment);
                            if PmtType.FindFirst() then begin
                                //Message(PmtType.Code);
                                Buffer.Validate(Type, PmtType.Code);
                                Buffer.validate("Account No.", TempExcelBuffer."Cell Value as Text");
                            end
                            else
                                Error('No Payment Type Set Up for this Account Type');
                        end;

                    2:
                        Begin

                            Evaluate(Buffer.Amount, TempExcelBuffer."Cell Value as Text");
                            Buffer.Validate(Amount);
                            Buffer.Insert(true);
                        end;
                end;

                if CurrentDatetime - WindowLastUpdated > 100 then begin
                    Window.Update(1, ROUND(Counter / Total * 10000, 1));
                    Window.Update(2, Counter);
                    WindowLastUpdated := CurrentDatetime;
                end;
            until TempExcelBuffer.Next = 0;
        Window.Close;
    end;
}

