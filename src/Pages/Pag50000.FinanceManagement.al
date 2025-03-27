namespace DalaDala.DalaDala;
using Microsoft.FixedAssets.Reports;
using Microsoft.Finance.GeneralLedger.Account;
using Microsoft.Finance.GeneralLedger.Budget;
using Microsoft.Finance.FinancialReports;
using Microsoft.FixedAssets.Depreciation;
using Microsoft.FixedAssets.Journal;
using Microsoft.FixedAssets.FixedAsset;
using Microsoft.Purchases.Reports;
using Microsoft.Purchases.History;
using Microsoft.Purchases.Document;
using Microsoft.Purchases.Vendor;
using Microsoft.Sales.Reports;
using Microsoft.Sales.History;
using System.Environment;
using System.Visualization;
using Microsoft.Finance.RoleCenters;
using Microsoft.Intercompany;
using Microsoft.Foundation.Task;
using System.Email;
using System.Automation;
using Microsoft.RoleCenters;
using Microsoft.Sales.Analysis;
using System.Threading;
using Microsoft.CashFlow.Forecast;
using Microsoft.EServices.EDocument;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using Microsoft.Bank.Reconciliation;
using Microsoft.Bank.BankAccount;
using Microsoft.Finance.GeneralLedger.Journal;

page 50000 "Finance Management"
{
    ApplicationArea = All;
    Caption = 'Finance Management';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control76; "Headline RC Accountant")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control99; "Finance Performance")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control1902304208; "Accountant Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part("Intercompany Activities"; "Intercompany Activities")
            {
                ApplicationArea = Intercompany;
            }
            part("User Tasks Activities"; "User Tasks Activities")
            {
                ApplicationArea = Suite;
            }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control123; "Team Member Activities")
            {
                ApplicationArea = Suite;
            }
            part(Control1907692008; "My Accounts")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control103; "Trailing Sales Orders Chart")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control106; "My Job Queue")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control9; "Help And Chart Wrapper")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control100; "Cash Flow Forecast Chart")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control108; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = IMD;
                ApplicationArea = Basic, Suite;
            }
            
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(reporting)
        {

        }

        area(sections)
        {

            group(Action157)//FINANCE
            {
                Caption = 'Finance';
                //START
                group(GeneralLedger)
                {
                    Caption = 'General Ledger';

                    action(Action267)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Chart of Accounts';
                        Image = CustomerContact;


                        RunObject = Page "Chart of Accounts";
                    }

                    action(Action166)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'G/L Budgets';


                        RunObject = Page "G/L Budget Names";
                    }
                    action(Action165)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'General Journal';
                        Image = Quote;
                        Visible = false;


                        RunObject = Page "General Journal";
                    }



                    action(Action2367)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Account Schedules';
                        Image = Quote;


                        RunObject = Page "Account Schedule Names";
                    }

                }
                //FINish
                group(CashManagement)
                {
                    Caption = 'Cash Management';

                    action(Action634)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Bank Account List';
                        Image = Bank;


                        RunObject = Page "Bank Account List";
                    }
                    action("Cash Receipt Journal")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Cash Receipt Journal';
                        Image = Reminder;


                        RunObject = Page "Cash Receipt Journal";
                    }
                    action("Payment Journal")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Payment Journal';
                        Image = Reminder;


                        RunObject = Page "Payment Journal";
                    }
                    action("Bank Acc. Reconciliation List")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Bank Acc. Reconciliation';
                        Image = Reminder;


                        RunObject = Page "Bank Acc. Reconciliation List";
                    }



                }
                //START
                group(Receivables)
                {
                    Caption = 'Receivables';

                    action(Action639)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Customers';
                        Image = "Order";


                        RunObject = Page "Customer List";
                    }
                    action("Sales Invoice")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Sales Invoice';
                        Image = Reminder;


                        RunObject = Page "Sales Invoice List";
                    }
                    action("Posted Sales Invoice")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Posted Sales Invoice';
                        Image = Reminder;


                        RunObject = Page "Posted Sales Invoices";

                    }

                    action("Sales Credit Memo")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Sales Credit Memo';
                        Image = Reminder;


                        RunObject = Page "Sales Credit Memos";
                    }

                    action("Posted Sales Credit Memo")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Posted Sales Credit Memo';
                        Image = Reminder;


                        RunObject = Page "Posted Sales Credit Memos";
                    }


                    action("Customer - Summary Aging")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Image = Reminder;


                        RunObject = Report "Customer - Summary Aging";
                    }

                }



                //FINISH
                group(Payables)
                {
                    Caption = 'Payables';

                    action(Action239)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Vendors';
                        Image = "Order";


                        RunObject = Page "Vendor List";
                    }
                    action("Purchase Invoice")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Purchase Invoice';
                        Image = Reminder;


                        RunObject = Page "Purchase Invoices";
                    }
                    action("Posted Purchase Invoice")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Posted Purchase Invoice';
                        Image = Reminder;


                        RunObject = Page "Posted Purchase Invoices";
                    }

                    action("Purchase Credit Memo")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Purchase Credit Memo';
                        Image = Reminder;


                        RunObject = Page "Purchase Credit Memos";
                    }

                    action("Posted Purchase Credit Memo")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Posted Purchase Credit Memo';
                        Image = Reminder;


                        RunObject = Page "Posted Purchase Credit Memos";
                    }
                    action("Vendor - Summary Aging")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Image = Reminder;


                        RunObject = Report "Vendor - Summary Aging";
                    }


                }


                group(FixedAssets)
                {
                    Caption = 'Fixed Assets';

                    action(Action229)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Fixed Assets';
                        Image = "Order";
                        RunObject = Page "Fixed Asset List";
                    }

                    action("Fixed Asset G/L Journal")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'FA G/L Journal';
                        Image = Reminder;


                        RunObject = Page "Fixed Asset G/L Journal";
                    }
                    action("Fixed Asset Journal")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'FA Journal';
                        Image = Reminder;


                        RunObject = Page "Fixed Asset Journal";
                    }

                    action("FA Reclass. Journals")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'FA Reclass. Journals';
                        Image = Reminder;


                        RunObject = Page "FA Reclass. Journal";
                    }
                    action("Calculate Depreciation")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Calculate Depreciation';
                        Image = Reminder;


                        RunObject = Report "Calculate Depreciation";
                    }
                    action("Fixed Asset List")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        RunObject = Report "Fixed Asset Register";
                        Caption = 'Fixed Asset List';
                    }

                }


                group(FixedAssetsReports)
                {
                    Caption = 'Fixed Assets Reports';


                    action(FAR004)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Fixed Assets Register';
                        Image = "Order";
                        RunObject = report "Fixed Asset Register";
                    }
                    action(FAR002)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Fixed Asset - Book Value 01';
                        Image = "Order";
                        RunObject = report "Fixed Asset - Book Value 01";
                    }
                    action(FAR005)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Fixed Asset - Book Value 02';
                        Image = "Order";
                        RunObject = report "Fixed Asset - Book Value 02";
                    }

                }


            }





            group(Action57)//FUNDS MANAGEMENT
            {
                Caption = 'Funds Management';


                group(Receipts)
                {
                    Caption = 'Receipts';

                    action(Receipt)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Receipts List';
                        Image = CustomerContact;


                        RunObject = Page "Receipts List";
                    }
                    action("Posted Receipts")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Posted Receipts';


                        RunObject = Page "Posted Receipts List";
                    }
                    action("Receipts - report")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Receipts Report';
                        Image = Receipt;


                        RunObject = Report Receipt;
                    }
                }
                group(PaymentsVouchers)
                {
                    Caption = 'Payments';

                    action(Payments)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Payment Voucher';
                        Image = CustomerContact;


                        RunObject = Page "PV List";
                    }

                    action(PettyCash)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Petty Cash';
                        Image = CustomerContact;


                        //RunObject = Page "Petty Cash List";
                    }


                    action("PaymentVouchers")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Posted Payment Voucher';


                        RunObject = Page "PV Posted List";
                    }

                    action(PostedPettyCash)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Posted Petty Cash';
                        Image = CustomerContact;


                        //RunObject = Page "Posted Petty Cash List";
                    }

                    action("Payments Report")
                    {
                        ApplicationArea = RelationshipMgmt;
                        RunObject = rEPORT "Payments Report";
                    }
                }

                group(Imprest)
                {
                    Caption = 'Imprest';

                    action("Imprest Requisition List")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Imprest Requisition List';
                        Image = "Order";


                        //RunObject = Page "Imprest Requisition List";
                    }
                    action("Posted Imprest Requisition List")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Posted Imprest Requisition List';
                        Image = "Order";


                        //RunObject = Page "Posted Imprest Requisition";
                    }
                    action("Imprest Surrender List")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Imprest Surrender List';
                        Image = Reminder;


                        // RunObject = Page "Imprest Surrender List";
                    }
                    action("Posted Imprest Surrender List")
                    {
                        ApplicationArea = Suite, RelationshipMgmt;
                        Caption = 'Posted Imprest Surrender List';
                        Image = Reminder;


                        //RunObject = Page "Posted Imprest Surrender List";
                    }

                }
                group(BankTransfers)
                {
                    Caption = 'Bank Transfers';

                    action("IBT")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Inter-Bank Transfers List';
                        Image = "Order";


                        // RunObject = Page "IBT List";
                    }

                    action("PostedIBT")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Posted Inter-Bank Transfers List';
                        Image = "Order";


                        //RunObject = Page "Posted Inter Bank Transfers";
                    }
                }
            }


            group(Action4)
            {
                Caption = 'Management';

            }


        }

        area(processing)
        {







        }


    }


}
