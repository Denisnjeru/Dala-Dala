
/// <summary>
/// Page PV Card (ID 52188645).
/// </summary> 
Page 50006 "PV Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Payment Header";
    PromotedActionCategories = 'New,Process,Report,Approval Request,Check Budget';

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Importance = Promoted;
                }
                field(Date; Date)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update
                    end;
                }
                field(PaymentReleaseDate; "Payment Release Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(PaymentType; "Payment Type")
                {
                    ApplicationArea = Basic;
                    ValuesAllowed = Normal, "Petty Cash", Board, Staff;
                    Visible = False;
                }
                field(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayMode; "Pay Mode")
                {
                    ApplicationArea = Basic;
                    trigger OnValidate()
                    var

                    begin
                        TransTypeEditable := false;

                        if "Pay Mode" = "Pay Mode"::EFT then begin
                            TransTypeEditable := true;
                        end;
                    end;
                }
                field(CurrencyCode; "Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Currency CodeEditable";
                    Visible = false;
                }
                field(PayingAccountType; "Paying Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = PayingBank;
                    ValuesAllowed = "Bank Account", "G/L Account";
                }
                field(PayingAccount; "Paying Bank Account")
                {
                    ApplicationArea = Basic;
                    Caption = 'Paying Account';
                }
                field(AccountBalance; "Account Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Account Name"; "Bank Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Payee; Payee)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment to';
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field(OnBehalfOf; "On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentNarration; "Payment Narration")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(ChequeType; "Cheque Type")
                {
                    ApplicationArea = Basic;
                    Editable = StatusEditableapproved;

                    trigger OnValidate()
                    begin
                        if "Cheque Type" = "cheque type"::"Computer Check" then
                            "Cheque No.Editable" := false
                        else
                            "Cheque No.Editable" := true;
                    end;
                }
                field(TypeofCheque; "Type of Cheque")
                {
                    ApplicationArea = Basic;
                }
                field(ChequeEFTNo; "Cheque No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cheque/EFT No.';

                    trigger OnValidate()
                    begin
                        //check if the cheque has been inserted
                        TestField("Paying Bank Account");
                        PVHead.Reset;
                        PVHead.SetRange(PVHead."Paying Bank Account", "Paying Bank Account");
                        PVHead.SetRange(PVHead."Pay Mode", PVHead."pay mode"::Cheque);
                        PVHead.SetFilter(PVHead.Status, '<>%1', PVHead.Status::Approved);
                        if PVHead.FindFirst then begin
                            repeat
                                if PVHead."Cheque No." = "Cheque No." then begin
                                    if PVHead."No." <> "No." then begin
                                        Error('The Cheque Number has already been utilised by %1', PVHead."No.");
                                    end;
                                end;
                            until PVHead.Next = 0;
                        end;
                    end;
                }
                /*
                field(Cashier; Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                }*/

                field(Cashier; Cashier)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }

                field(TotalPaymentAmount; "Total Payment Amount")
                {
                    ApplicationArea = Basic;
                }
                field(TotalVATAmount; "Total VAT Amount")
                {
                    ApplicationArea = Basic;
                }
                field(TotalVATWithholdingAmount; "Total VAT Withholding Amount")
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
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                }
                field("Document Attached"; "Document Attached")
                {
                    ApplicationArea = Basic;
                }
                field("Document Attached By"; "Document Attached By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DatePosted; "Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field(TimePosted; "Time Posted")
                {
                    ApplicationArea = Basic;
                }
                field(PostedBy; "Posted By")
                {
                    ApplicationArea = Basic;
                }
            }
            part(PVLines; "PV Line")
            {
                SubPageLink = "Header No." = field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Import Lines")
            {
                ApplicationArea = Basic;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // if Confirm('Are you sure you want to Import Lines?') then begin
                    //     //  ImportPVLinesFromExcel();
                    // end;
                end;
            }
            action("Post Payment")
            {
                ApplicationArea = Basic;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to Post this PV?') then begin

                        // SaccoActivities.PostPV("No.");

                    end;
                end;

            }
            action(Print)
            {
                ApplicationArea = Basic;
                Image = PrintVoucher;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //TestField(Status, Status::Approved);

                    PVHead.Reset;
                    PVHead.SetRange("No.", "No.");
                    if PVHead.FindFirst then
                        Report.Run(Report::"Payment Voucher", true, false, PVHead);
                    //Report.Run(52188585, true, false, PVHead);

                end;
            }
            group(RequestApproval)
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = category4;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        NextofKinError: label 'You must specify next of Kin for this application.';
                        NextofKIN: Record "Service Item";
                        ProductFactory: Record "Service Item";
                        SavingsAccountRegistration: Record "Service Item";
                        //DocumentType: Enum "Custom Document Type";
                        VarVariant: Variant;
                    // CalwideApprovals: Codeunit "Calwide Approvals";
                    begin


                        // VarVariant := Rec;
                        // CalcFields("Total Payment Amount");
                        // CalwideApprovals.CreateCustomTracker(VarVariant, "No.", 0, Documenttype::PV, "Global Dimension 1 Code", "Shortcut Dimension 2 Code", 0);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = category4;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        // CalwideApprovals: Codeunit "Calwide Approvals";
                        VarVariant: Variant;
                    begin
                        TestField(Status, Status::Pending);

                        VarVariant := Rec;
                        // CalwideApprovals.CancelTracker(VarVariant, "No.");
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ","Member Application","Loan Application","Savings Application",FDR,"Def. Recovery","Loan Changes","Guarantor Sub.","Member Exit","Member Exit Notice","Member Changes",STO,"Cheque Book App","Account Transfer","Teller Transaction","Micro Transaction",PV,"Petty Cash";
                        VarVariant: Variant;
                    // ApprovalTracker: Record "Approval Tracker";
                    begin
                        VarVariant := Rec;
                        RecRef.GetTable(VarVariant);
                        DocumentType := Documenttype::PV;


                        // ApprovalTracker.Reset;
                        // ApprovalTracker.SetRange("Table ID", RecRef.Number);
                        // ApprovalTracker.SetRange("Document No.", "No.");
                        // ApprovalTracker.SetRange("Document Type", DocumentType);
                        // if ApprovalTracker.FindFirst then
                        //     approvalsMgmt.OpenApprovalEntriesPage(ApprovalTracker.RecordId);
                    end;
                }
                action(ApproveBatch)
                {
                    ApplicationArea = Basic;
                    Caption = 'ApproveBatch';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = category4;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"," ","Member Application","Loan Application","Savings Application",FDR,"Def. Recovery","Loan Changes","Guarantor Sub.","Member Exit","Member Exit Notice","Member Changes",STO,"Cheque Book App","Account Transfer","Teller Transaction","Micro Transaction",PV,"Petty Cash";
                        VarVariant: Variant;
                    // ApprovalTracker: Record "Approval Tracker";
                    begin
                        VarVariant := Rec;
                        RecRef.GetTable(VarVariant);
                        DocumentType := Documenttype::PV;

                        If Confirm('Are you sure you want to approve this Batch') then begin
                            Status := Status::Approved;
                            Modify();
                            Message('Approved');

                        end;
                    end;
                }
                action("Reopen Document")
                {
                    ApplicationArea = Basic;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        // CalwideApprovals: Codeunit "Calwide Approvals";
                        VarVariant: Variant;
                    begin

                        if Status = Status::Pending then begin
                            VarVariant := Rec;
                            // CalwideApprovals.CancelTracker(VarVariant, "No.");
                        end
                        else begin

                            if not Confirm('Are you sure you want to re-open this document?') then
                                exit;

                            Status := Status::Open;
                            Modify;
                        end;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateCard;
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateCard;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Payment Type" := "payment type"::Normal
    end;

    trigger OnOpenPage()
    begin
        UpdateCard;
    end;

    var
        PayLine: Record "Document Line";
        UserSetup: Record "User Setup";
        strFilter: Text[250];
        IntC: Integer;
        IntCount: Integer;
        RecPayTypes: Record "Payment & Receipt Types";
        LineNo: Integer;
        JTemplate: Code[10];
        JBatch: Code[10];
        Post: Boolean;
        strText: Text[100];
        PVHead: Record "Payment Header";
        BankAcc: Record "Bank Account";
        Doc_Type: Option LPO,Requisition,Imprest,"Payment Voucher";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None",JV,"Member Closure","Account Opening",Batches,Loan,Checkoff,"FOSA Account Opening",StandingOrder,HRJob,HRLeave,"HRTransport Request",HRTraining,"HREmp Requsition",MicroTrans,"Account Reactivation","Overdraft ",BLA,"Member Editable","MSacco Applications","MSacco PinChange","MSacco PhoneChange","MSacco TransChange",BulkSMS,"Payment Voucher","Petty Cash","Board PV",Imp,Requisition,ImpSurr,Interbank,Receipt,"Staff Claim","Staff Adv",AdvSurr,OT;
        DocPrint: Codeunit "Document-Print";
        CheckLedger: Record "Check Ledger Entry";
        CheckManagement: Codeunit CheckManagement;
        HasLines: Boolean;
        AllKeyFieldsEntered: Boolean;
        AdjustGenJnl: Codeunit "Adjust Gen. Journal Balance";

        "Cheque No.Editable": Boolean;

        "Payment Release DateEditable": Boolean;

        "Cheque TypeEditable": Boolean;

        "Invoice Currency CodeEditable": Boolean;

        "Currency CodeEditable": Boolean;

        GlobalDimension1CodeEditable: Boolean;

        "Payment NarrationEditable": Boolean;

        ShortcutDimension2CodeEditable: Boolean;
        PayeeEditable: Boolean;
        ShortcutDimension3CodeEditable: Boolean;
        ShortcutDimension4CodeEditable: Boolean;
        DateEditable: Boolean;
        PVLinesEditable: Boolean;
        StatusEditablePending: Boolean;
        PaymodeEditable: Boolean;
        BankEditabl: Boolean;
        OnBehalfEditable: Boolean;
        RespEditabl: Boolean;
        Bank: Record "Bank Account";
        DocNoVisible: Boolean;
        "NOT OpenApprovalEntriesExist": Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        VarVariant: Variant;

        StatusEditableApproved: Boolean;
        PayingBank: Boolean;

        TransTypeEditable: Boolean;

    local procedure UpdateCard()
    begin
        /*
        if Status = Status::Open then
            CurrPage.Editable := true
        else
            CurrPage.Editable := false;
            */
    end;
}

