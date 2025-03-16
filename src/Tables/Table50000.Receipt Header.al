
Table 50000 "Receipt Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(SalesSetup."Receipts Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Posting Date" > Today then Error('You can not post with a future date');
            end;
        }
        field(3; Cashier; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Date Posted"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Time Posted"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Bank Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No." where("Currency Code" = field("Currency Code"));

            trigger OnValidate()
            begin
                if bank.Get("Bank Code") then
                    "Bank Name" := bank.Name;
            end;
        }
        field(9; Narration; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "On Behalf Of"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Amount Recieved"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");

                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 1 Code");
                if DimVal.Find('-') then
                    Dim1 := DimVal.Name
            end;
        }
        field(27; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = const(Standard));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");

                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    Dim2 := DimVal.Name
            end;
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(38; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Document Line".Amount where("Header No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Posted By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(40; "Print No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(41; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = Open,Pending,Approved,Rejected;
        }
        field(42; "Cheque No."; Code[6])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RH: Record "Receipt Header";
            begin
                RH.Reset();
                RH.SetRange(posted, true);
                RH.SetRange("Cheque No.", Rec."Cheque No.");
                If RH.FindFirst() then Error('Cheque No. has been used for Receipt No. %1', RH."No.");

                "Cheque/Deposit Slip No" := "Cheque No.";
            end;



        }
        field(43; "No. Printed"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(44; "Created By"; Code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(45; "Created Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(46; "Register No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(47; "From Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(48; "To Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Document Date" > Today then Error('You can not post with a future date');
            end;
        }
        field(50; "External Document No"; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(81; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin


                TestField(Status, Status::Open);
            end;
        }
        field(83; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(84; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(86; Dim3; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(87; Dim4; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(88; "Bank Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(89; "Receipt Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Bank,Cash';
            OptionMembers = Bank,Cash;
        }
        field(90; "Account Type"; Option)
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Savings,Credit';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Savings,Credit;
        }
        field(91; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                //ShowDimensions
            end;
        }
        field(481; Dim1; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(482; Dim2; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(483; "Customer No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

            //TableRelation = Members

            TableRelation = if ("Customer Type" = const(Customer)) Customer
            else
            if ("Customer Type" = const("G/L Account")) "G/L Account" where("Direct Posting" = const(true));

            trigger OnValidate()
            Var
                GLAcc: Record "G/L Account";
                Cust: Record Customer;
            begin

                "Member Name" := '';
                if Members.Get("Customer No.") then begin
                    "Member Name" := Members.Name;
                    "Received From" := Members.Name;
                    payrollandstaffNo := '';
                end;
                if GLAcc.Get("Customer No.") then begin
                    "Member Name" := GLAcc.Name;
                    "Received From" := GLAcc.Name;
                    payrollandstaffNo := '';
                end;
                if Cust.Get("Customer No.") then begin
                    "Member Name" := Cust.Name;
                    "Received From" := Cust.Name;
                    payrollandstaffNo := '';
                end;

            end;

            trigger OnLookup()
            var
                Cust: Record Customer;
                Customer: Record Customer;
                GLAcc: Record "G/L Account";
            begin
                if "Customer Type" = "Customer Type"::Customer then begin
                    Customer.RESET;
                    if Customer.FindFirst() then begin
                        IF PAGE.RUNMODAL(33, Customer) = ACTION::LookupOK THEN BEGIN
                            "Customer No." := Customer."No.";
                            VALIDATE("Customer No.");
                        END
                    end;
                end;

                if "Customer Type" = "Customer Type"::"G/L Account" then begin

                    GLAcc.RESET;
                    GLAcc.SetRange("Direct Posting", true);
                    if GLAcc.FindFirst() then begin
                        IF PAGE.RUNMODAL(Page::"Chart of Accounts", GLAcc) = ACTION::LookupOK THEN BEGIN
                            "Customer No." := GLAcc."No.";
                            //   "Customer No." := cust."Payroll/Staff No.";
                            VALIDATE("Customer No.");
                            //xxx

                        END
                    end;
                end;

            end;
        }
        field(484; "Member Name"; Text[100])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50050; "Pay Mode"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,"Mobile Money","Bank STO","Direct Debits";

            trigger OnValidate()
            begin
                "Cheque No." := '';
                "Cheque/Deposit Slip No" := '';
            end;
        }
        field(50051; "Cheque/Deposit Slip No"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                RH: Record "Receipt Header";
            begin
                RH.Reset();
                RH.SetRange(posted, true);
                RH.SetRange("Cheque/Deposit Slip No", Rec."Cheque/Deposit Slip No");
                If RH.FindFirst() then Error('Cheque/Deposit Slip No. has been used for Receipt No. %1', RH."No.");
            end;
        }
        field(50052; "Cheque/Deposit Slip Date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            //SaccoSetup: Record "Sacco Setup";
            begin

                if "Cheque/Deposit Slip Date" > Today then
                    Error('Post dating not allowed');


                // SaccoSetup.Get;

                // SaccoSetup.Get;
                // SaccoSetup.TestField("Cheque Reject Period");
                // if "Cheque/Deposit Slip Date" < CalcDate('-' + Format(SaccoSetup."Cheque Reject Period"), Today) then
                //     Error('Date not within the acceptable cheque dates');
            end;
        }
        field(50053; "Cheque/Deposit Slip Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " "," Local","Up Country";
        }
        field(50054; "Customer Type"; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionMembers = Member,Customer,"G/L Account";

            trigger OnValidate()
            begin
                "Customer No." := '';
                "Member Name" := '';
                Narration := '';
            end;
        }
        field(50055; "Received From"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //HERE
        field(50056; payrollandstaffNo; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        //HERE
        field(50057; "Date Created"; Date)
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
        fieldgroup(DropDown; "No.", "Member Name", "Amount Recieved")
        {
        }
    }

    trigger OnInsert()
    begin

        if "No." = '' then begin
            SalesSetup.Get;
            if "Customer Type" = "Customer Type"::Member then begin
                SalesSetup.TestField("Receipts Nos.");
                "No. Series" := SalesSetup."Receipts Nos.";
                if NoSeriesMgt.AreRelated(SalesSetup."Receipts Nos.", xRec."No. Series") then
                    "No. Series" := xRec."No. Series";
                "No." := NoSeriesMgt.GetNextNo("No. Series");
            end
            else begin
                SalesSetup.Get;
                if ("Customer Type" = "Customer Type"::Customer) or ("Customer Type" = "Customer Type"::"G/L Account") then begin
                    SalesSetup.TestField("Cust Receipts Nos.");
                    "No. Series" := SalesSetup."Cust Receipts Nos.";
                    if NoSeriesMgt.AreRelated(SalesSetup."Cust Receipts Nos.", xRec."No. Series") then
                        "No. Series" := xRec."No. Series";
                    "No." := NoSeriesMgt.GetNextNo("No. Series");
                end;
            end
        end;

        UserTemplate.Get(UserId);


        "Created By" := UserId;
        "Created Date Time" := CurrentDatetime;
        Cashier := UserId;
        "Date Created" := Today;

        "Global Dimension 1 Code" := UserTemplate."Global Dimension 1 Code";
        "Global Dimension 2 Code" := UserTemplate."Global Dimension 2 Code";
        "Bank Code" := UserTemplate."Default Receipt Bank";
        Validate("Bank Code");

    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        UserTemplate: Record "User Setup";
        RLine: Record "Document Line";
        RespCenter: Record "Responsibility Center";
        DimVal: Record "Dimension Value";
        bank: Record "Bank Account";
        DimMgt: Codeunit DimensionManagement;
        Members: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;
}

