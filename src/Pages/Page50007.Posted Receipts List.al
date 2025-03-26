
Page 50007 "Posted Receipts List"
{
    ApplicationArea = Basic;
    CardPageID = "Receipt Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Receipt Header";
    SourceTableView = where(Posted = const(true), "Customer Type" = filter(Member));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(MemberNo; "Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(MemberName; "Member Name")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No"; "External Document No")
                {
                    ApplicationArea = Basic;
                }

                field(PostingDate; "Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Narration)
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
                field(payrollandstaffNo; payrollandstaffNo)
                {
                }

            }
        }
    }

    actions
    {
    }
}

