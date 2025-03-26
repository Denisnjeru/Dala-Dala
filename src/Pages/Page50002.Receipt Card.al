/// <summary>
/// Page Receipt Card (ID 52188592).
/// </summary>
Page 50002 "Receipt Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Receipt Header";
    PromotedActionCategories = 'New,Process,Report,Post Receipt,Suggest,Send Notification,Print';


    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }

                field("Date Created"; "Date Created")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PostingDate; "Posting Date")
                {
                    ApplicationArea = Basic;

                }
                field("Customer Type"; "Customer Type")
                {
                    ApplicationArea = Basic;
                }
                field(MemberNo; "Customer No.")
                {
                    ApplicationArea = Basic;
                    LookupPageId = "Customer List";
                }

                field(CustomerName; "Member Name")
                {
                    ApplicationArea = Basic;
                }
                field(Narration; Narration)
                {
                    ApplicationArea = Basic;
                }
                field("Received From"; "Received From")
                {
                    ApplicationArea = Basic;
                }
                
                field("External Document No"; "External Document No")
                {
                    ApplicationArea = Basic;
                }

                field(AmountRecieved; "Amount Recieved")
                {
                    ApplicationArea = Basic;
                }
                field(TotalAmount; "Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(BankCode; "Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field(BankName; "Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field(PayMode; "Pay Mode")
                {
                    ApplicationArea = Basic;
                    trigger OnValidate()
                    begin
                        SlipMandatory := false;
                        if "Pay Mode" <> "Pay Mode"::Cash then SlipMandatory := true
                    end;
                }
                field(ChequeNo; "Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("Deposit Slip No"; "Cheque/Deposit Slip No")
                {
                    ApplicationArea = Basic;
                    Caption = 'EFT/Deposit Slip No.';
                    ShowMandatory = SlipMandatory;
                    //From the table, cheque No is also the deposit/slip no.
                }
                field("ChequeDate"; "Cheque/Deposit Slip Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque Date';
                }

                field(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(CreatedBy; "Created By")
                {
                    ApplicationArea = Basic;
                }
                field(CreatedDateTime; "Created Date Time")
                {
                    ApplicationArea = Basic;
                }
                field(Cashier; Cashier)
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                }
                field(DatePosted; "Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field(TimePosted; "Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field(payrollandstaffNo; payrollandstaffNo)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Caption = 'Payroll/Staff No.';
                }

                field(PostedBy; "Posted By")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control18; "Receipt Line")
            {
                SubPageLink = "Header No." = field("No.");
            }
        }

    }

    actions
    {
        area(processing)
        {
            action("Suggest Receipt Lines")
            {
                ApplicationArea = Basic;
                Image = Suggest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                Visible = false;

               /* trigger OnAction()
                var
                    RecType: Record "Payment & Receipt Types";
                    SavingsType: Record "Payment & Receipt Types";
                    Loans: Record Loans;
                    Savings: Record "Savings Accounts";
                    SaccoActivities: Codeunit "Sacco Activities";
                    ExpAmt: Decimal;
                    AmtPaid: Decimal;
                    DefAmt: Decimal;
                    DaysDef: Integer;
                    ArrearsDate: Date;
                    RLine: Record "Document Line";
                    RunBal: Decimal;
                    ProductSetup: Record "Product Setup";
                    DedAmt: Decimal;
                    Cust: Record Customer;

                begin
                    if Confirm('Are you sure you want to Suggest Receipt Lines?') then begin

                        Rec.TestField("Customer No.");
                        Rec.TestField("Amount Recieved");
                        RunBal := "Amount Recieved";

                        RLine.Reset();
                        RLine.SetRange("Header No.", Rec."No.");
                        if RLine.FindFirst() then begin
                            if Confirm('Any Existing Lines will be cleared. Do you want to proceed?') then begin
                                RLine.DeleteAll();
                            end;
                        end;
                        if "Customer Type" = "Customer Type"::Customer then begin

                            Cust.Reset();
                            Cust.SetRange("No.", "Customer No.");
                            if Cust.FindFirst() then begin
                                TestField(Narration);

                                if RecType.Get(Cust."Customer Posting Group") then begin
                                    RecType."Default Grouping" := Cust."Customer Posting Group";
                                    RecType."Account Type" := RecType."Account Type"::Customer;
                                    RecType.Modify();
                                end;

                                if not RecType.Get(Cust."Customer Posting Group") then begin

                                    RecType.Init();
                                    RecType.Code := Cust."Customer Posting Group";
                                    RecType.Description := Cust."Customer Posting Group";
                                    RecType."Account Type" := RecType."Account Type"::Customer;
                                    RecType."Default Grouping" := Cust."Customer Posting Group";
                                    RecType.Type := RecType.Type::Receipt;
                                    RecType.Insert();

                                end;
                                DedAmt := "Amount Recieved";

                                if RunBal >= DedAmt then begin

                                    RLine.Init();
                                    RLine."Header No." := Rec."No.";
                                    RLine.Validate(Type, Cust."Customer Posting Group");
                                    RLine.Validate("Account No.", Cust."No.");
                                    RLine.Validate(Amount, DedAmt);
                                    RLine.Description := Narration;
                                    RLine.Insert();
                                    RunBal -= DedAmt;
                                end;
                            end;



                        end;


                        Savings.Reset();
                        Savings.SetRange("Member No.", "Customer No.");
                        Savings.SetFilter(Savings."Product Category", '%1', Savings."Product Category"::"Registration Fee");
                        Savings.SetRange("Balance (LCY)", 0);
                        if Savings.FindFirst() then begin
                            repeat
                                if RecType.Get(Savings."Product Type") then begin
                                    RecType."Default Grouping" := Savings."Customer Posting Group";
                                    RecType."Account Type" := RecType."Account Type"::Savings;
                                    RecType.Modify();
                                end;

                                if not RecType.Get(Savings."Product Type") then begin

                                    RecType.Init();
                                    RecType.Code := Savings."Product Type";
                                    RecType.Description := Savings."Product Name";
                                    RecType."Account Type" := RecType."Account Type"::Savings;
                                    RecType."Default Grouping" := Savings."Customer Posting Group";
                                    RecType.Type := RecType.Type::Receipt;
                                    RecType.Insert();

                                end;
                                ProductSetup.Get(Savings."Product Type");
                                DedAmt := ProductSetup."Mandatory Contribution";

                                if RunBal >= DedAmt then begin

                                    RLine.Init();
                                    RLine."Header No." := Rec."No.";
                                    RLine.Validate(Type, Savings."Product Type");
                                    RLine.Validate("Account No.", Savings."No.");
                                    RLine.Validate(Amount, DedAmt);
                                    RLine.Insert();
                                    RunBal -= DedAmt;
                                end;

                            until Savings.Next = 0;
                        end;


                        if RunBal > 0 then begin

                            Savings.Reset();
                            Savings.SetRange("Member No.", "Customer No.");
                            Savings.SetFilter(Savings."Product Category", '%1', Savings."Product Category"::"Share Capital");
                            Savings.SetRange("Balance (LCY)", 0);
                            if Savings.FindFirst() then begin
                                repeat
                                    if RecType.Get(Savings."Product Type") then begin
                                        RecType."Default Grouping" := Savings."Customer Posting Group";
                                        RecType."Account Type" := RecType."Account Type"::Savings;
                                        RecType.Modify();
                                    end;

                                    if not RecType.Get(Savings."Product Type") then begin

                                        RecType.Init();
                                        RecType.Code := Savings."Product Type";
                                        RecType.Description := Savings."Product Name";
                                        RecType."Account Type" := RecType."Account Type"::Savings;
                                        RecType."Default Grouping" := Savings."Customer Posting Group";
                                        RecType.Type := RecType.Type::Receipt;
                                        RecType.Insert();

                                    end;
                                    ProductSetup.Get(Savings."Product Type");
                                    DedAmt := ProductSetup."Mandatory Contribution";
                                    Savings.CalcFields("Balance (LCY)");
                                    DedAmt -= Savings."Balance (LCY)";
                                    if DedAmt < 0 then
                                        DedAmt := 0;


                                    if DedAmt > RunBal then
                                        DedAmt := RunBal;

                                    if DedAmt > 0 then begin

                                        RLine.Init();
                                        RLine."Header No." := Rec."No.";
                                        RLine.Validate(Type, Savings."Product Type");
                                        RLine.Validate("Account No.", Savings."No.");
                                        RLine.Validate(Amount, DedAmt);
                                        RLine.Insert();
                                        RunBal -= DedAmt;
                                    end;

                                until Savings.Next = 0;
                            end;

                        end;


                        if not RecType.Get('LOANS') THEN begin
                            RecType.Init();
                            RecType.Code := 'LOANS';
                            RecType.Description := 'Loan Repayment';
                            RecType."Account Type" := RecType."Account Type"::Credit;
                            RecType.Type := RecType.Type::Receipt;
                            RecType.Insert();

                        end;

                        if RunBal > 0 then begin
                            Loans.Reset();
                            Loans.SetRange("Member No.", "Customer No.");
                            Loans.SetFilter("Total Outstanding Balance", '>0');
                            if Loans.FindFirst() then begin
                                repeat
                                    if RunBal > 0 then begin

                                        Loans.CalcFields("Outstanding Principal");
                                        Loans.CalcFields("Outstanding Penalty");
                                        Loans.CalcFields("Outstanding Interest");

                                        IF Loans."Outstanding Penalty" < 0 then
                                            Loans."Outstanding Penalty" := 0;
                                        IF Loans."Outstanding Interest" < 0 then
                                            Loans."Outstanding Interest" := 0;

                                        ArrearsDate := CalcDate('-1M+CM', Today);
                                        DefAmt := 0;
                                        //saccoActivities.GetDefaultedAmount(Loans."Loan No.", Today, ExpAmt, AmtPaid, DefAmt, DaysDef, ArrearsDate, true);
                                        if DefAmt < 0 then
                                            DefAmt := 0;
                                        DefAmt += SaccoActivities.GetLoanPrincipal(Loans, Today) + Loans."Outstanding Interest" + Loans."Outstanding Penalty";

                                        if DefAmt > (Loans."Outstanding Interest" + Loans."Outstanding Principal") then
                                            DefAmt := (Loans."Outstanding Interest" + Loans."Outstanding Principal");

                                        if DefAmt > RunBal then
                                            DefAmt := RunBal;


                                        IF DefAmt > 0 then begin
                                            RLine.Init();
                                            RLine."Header No." := Rec."No.";
                                            RLine.Validate(Type, 'LOANS');
                                            RLine.Validate("Account No.", Loans."Loan Account");
                                            //RLine."Loan No." := Loans."Loan No.";
                                            RLine.Validate("Loan No.", Loans."Loan No.");
                                            RLine.Validate(Amount, DefAmt);
                                            RLine.Description := 'Loan Repayment';
                                            RLine.Insert();
                                            RunBal -= DefAmt;
                                        END;
                                    end;
                                until Loans.Next = 0;
                            end;
                        End;


                        if RunBal > 0 then begin

                            Savings.Reset();
                            Savings.SetRange("Member No.", "Customer No.");
                            Savings.SetFilter(Savings."Product Category", '%1', Savings."Product Category"::"Deposit Contribution");
                            if Savings.FindFirst() then begin
                                repeat
                                    if RecType.Get(Savings."Product Type") then begin
                                        RecType."Default Grouping" := Savings."Customer Posting Group";
                                        RecType."Account Type" := RecType."Account Type"::Savings;
                                        RecType.Modify();
                                    end;

                                    if not RecType.Get(Savings."Product Type") then begin

                                        RecType.Init();
                                        RecType.Code := Savings."Product Type";
                                        RecType.Description := Savings."Product Name";
                                        RecType."Account Type" := RecType."Account Type"::Savings;
                                        RecType."Default Grouping" := Savings."Customer Posting Group";
                                        RecType.Type := RecType.Type::Receipt;
                                        RecType.Insert();

                                    end;

                                    RLine.Init();
                                    RLine."Header No." := Rec."No.";
                                    RLine.Validate(Type, Savings."Product Type");
                                    RLine.Validate("Account No.", Savings."No.");
                                    RLine.Validate(Amount, RunBal);
                                    RLine.Insert();
                                until Savings.Next = 0;
                            end;
                        end;


                    end;
                end;
            */
            }
            action("Post Receipt")
            {
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    DocLine: Record "Document Line";
                begin
                    if Confirm('Are you sure you want to Post this Receipt?') then begin
                        // "Posting Date" := Today;
                        Rec.Modify();

                        // SaccoActivities.PostReceipt("No.");

                        ReceiptHeader.Reset;
                        ReceiptHeader.SetRange("No.", "No.");
                        if ReceiptHeader.FindFirst then
                           Report.Run(Report::Receipt, true, false, ReceiptHeader);
                    end;
                end;
            }


            action("Receipt")
            {
                ApplicationArea = Basic;
                Image = Receipt;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
       
                begin

                    ReceiptHeader.Reset;
                    ReceiptHeader.SetRange("No.", "No.");
                    if ReceiptHeader.FindFirst then
                        Report.Run(Report::"Bosa Receipting Report", true, false, ReceiptHeader);
                end;
            }
            action(OldPrint)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                Visible = false;
                Enabled = false;

                trigger OnAction()
                begin
                    TestField(Posted, true);

                    ReceiptHeader.Reset;
                    ReceiptHeader.SetRange("No.", "No.");
                    if ReceiptHeader.FindFirst then begin

                        if "Customer Type" = "Customer Type"::Member then
                            Report.Run(52188743, true, false, ReceiptHeader);//52188618
                        if "Customer Type" = "Customer Type"::Customer then
                            Report.Run(52188442, true, false, ReceiptHeader);//52188442

                    end;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TestField(Posted, true);

                    ReceiptHeader.Reset;
                    ReceiptHeader.SetRange("No.", "No.");
                    if ReceiptHeader.FindFirst then begin

                        ReceiptHeader.Reset;
                        ReceiptHeader.SetRange("No.", "No.");
                        if ReceiptHeader.FindFirst then
                            Report.Run(Report::"Bosa Receipting Report", true, false, ReceiptHeader);

                    end;
                end;
            }
            action("Send Notification")
            {
                ApplicationArea = Basic;
                Image = Email;
                Promoted = true;
                PromotedCategory = category6;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to Send Notification to this member?') then begin
                        TestField(Posted, true);
                        // SaccoActivities.SendReceiptNotifications(Rec."No.");
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if ("Received From" = '') And ("No." <> '') then begin
            Rec."Received From" := "Member Name";
            Rec.Modify();
        end;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Customer Type" := "Customer Type"::Member;
    end;

    var
        // SaccoActivities: Codeunit "Sacco Activities";
        ReceiptHeader: Record "Receipt Header";
        SlipMandatory: Boolean;
}

