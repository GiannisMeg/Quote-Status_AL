/// <summary>
/// TableExtension SOL Sales Header Ext (ID 50110) extends Record Sales Header.
/// </summary>
tableextension 50110 "SOL Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50110; "SOL Won/Lost Quote Status"; Enum "SOL Won/Lost Status")
        {
            Caption = 'Quote Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if "SOL Won/Lost Date" = 0DT then
                    "SOL Won/Lost Date" := CurrentDateTime();
            end;

        }
        field(50111; "SOL Won/Lost Date"; DateTime)
        {
            Caption = 'Won/Lost Date';
            DataClassification = CustomerContent;
            Editable = false;


        }
        field(50112; "SOL Won/Lost Reason Code"; Code[10])
        {
            Caption = 'Won/Lost Reason Code';
            // link to Close Opportunity Code table
            //When Status is Won show values filtered type=Won
            TableRelation = if ("SOL Won/Lost Quote Status" = const(Won)) "Close Opportunity Code" where(type = Const(Won))
            else
            // show values filtered type=Lost
            if ("SOL Won/Lost Quote Status" = const(Lost)) "Close Opportunity Code" where(type = const(Lost));
            // atuomaticalyl get value Won/Lost Reason Code ===> get set in the field underneath but we need to validate in the field before
            trigger OnValidate()
            begin
                CalcFields("SOL Won/Lost Reason Desc.");
            end;
        }
        field(50113; "SOL Won/Lost Reason Desc."; Text[100])
        {
            Caption = 'Won/Lost Reason Description';
            FieldClass = FlowField;
            // check on the input from the validation upper
            CalcFormula = lookup("Close Opportunity Code".Description where(Code = field("SOL Won/Lost Reason Code")));
            Editable = false;

        }
        // the max leng of the text field should be 2048
        field(50114; "SOL Won/Lost Remarks"; Text[2048])
        {
            Caption = 'SOL Won/Lost Remarks';
            DataClassification = CustomerContent;

        }
    }

    var
        myInt: Integer;
}