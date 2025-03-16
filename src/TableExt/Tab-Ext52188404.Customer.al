
TableExtension 50002 tableextension52188404 extends Customer
{

    fields
    {

        field(50088; "Employer Based Staff Nos"; Boolean)
        {
        }

        field(50007; "Dont Charge Transactions"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Advice Method"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Changes,Everything';
            OptionMembers = " ",Changes,Everything;
        }
        field(50000; "Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ","Travel Advance",Partner,"Staff Advance",Members,"Training Advance",Employer,"Cashier Excess","Cashier Shortage","MPESA",Shop,Tenant,Imprest;

            trigger OnValidate()
            begin
                //Prevent Changing once entries exist
                //TestNoEntriesExist(FIELDCAPTION("Account Type"));
            end;
        }

        field(50096; "Remove Loan Restriction"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: Record "User setup";
            begin
                UserSetup.Reset();
                UserSetup.SetRange("User ID", UserId);
                UserSetup.SetRange("Credit Setups", true);
                if not UserSetup.findfirst then
                    error('You do not have the permission to update this setup');

            end;
        }

   



    }

    fieldgroups
    {

    }
}

