
Page 50001 "Receipts List"
{
    ApplicationArea = Basic;
    CardPageID = "Receipt Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Receipt Header";
    SourceTableView = where(Posted = const(false), "Customer Type" = filter(Member));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; "Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Cashier; Cashier)
                {
                    ApplicationArea = Basic;
                }
                field(DatePosted; "Date Posted")
                {
                    ApplicationArea = Basic;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = Basic;
                }
                field(AmountRecieved; "Amount Recieved")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cheque/Deposit Slip No"; "Cheque/Deposit Slip No")
                {
                    ApplicationArea = Basic;
                }

            }
        }
    }

    actions
    {
    }
    trigger OnOPenPage()
    var
        myInt: Integer;
    begin
        SetRange(Cashier, UserId);
    end;
}

