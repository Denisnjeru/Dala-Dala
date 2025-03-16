
Table 50001 "Payment & Receipt Types"
{
    DrillDownPageID = "Payment & Receipt Types";
    LookupPageID = "Payment & Receipt Types";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckEntries;
            end;
        }
        field(3; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                CheckEntries;
            end;
        }
        field(4; Type; Option)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            OptionMembers = " ",Receipt,Payment,Imprest,Claim,Advance;
        }
        field(5; "VAT %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Withholding VAT %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Tax %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Withholding Tax %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Default Grouping"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Account Type" = const(Customer)) "Customer Posting Group"
            else
            if ("Account Type" = const(Vendor)) "Vendor Posting Group"
            else
            if ("Account Type" = const(Customer)) "Customer Posting Group";
        }
        field(10; "Tax GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                GLAcc.Reset;
                if GLAcc.Get("Tax GL Account") then begin
                    if GLAcc."Direct Posting" = false then
                        Error('Direct Posting must be True');
                end;

                // PayLine.RESET;
                // PayLine.SETRANGE(PayLine.Type,Code);
                // IF PayLine.FIND('-') THEN
                //    ERROR('This Transaction Code Is Already in Use You Cannot Delete');
            end;
        }
        field(11; "VAT GL Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";

            trigger OnValidate()
            begin
                GLAcc.Reset;
                if GLAcc.Get("VAT GL Account") then begin
                    if GLAcc."Direct Posting" = false then
                        Error('Direct Posting must be True');
                end;
            end;
        }
        field(12; "Daily Tax Exempt. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = const(Customer)) Customer
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

        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record "G/L Account";
        PayLine: Record "Document Line";

    local procedure CheckEntries()
    begin
        PayLine.Reset;
        PayLine.SetRange(PayLine.Type, Code);
        //IF PayLine.FIND('-') THEN
        //ERROR('This Transaction Code Is Already in Use You cannot Modify/Delete');
    end;
}

