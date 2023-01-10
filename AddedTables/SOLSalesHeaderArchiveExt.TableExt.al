/// <summary>
/// TableExtension SOL Sales Header Archive Ext (ID 50111) extends Record Sales Header Archive.
/// </summary>
tableextension 50111 "SOL Sales Header Archive Ext" extends "Sales Header Archive"
{
    fields
    {
        field(50110; "SOL Quote Status"; Enum "SOL Won/Lost Status")
        {
            Caption = 'Quote Status';
            DataClassification = CustomerContent;

        }
        field(50111; "SOL Won/Lost Date"; DateTime)
        {
            Caption = 'Won/Lost Date';
            DataClassification = CustomerContent;
        }
        field(50112; "SOL Won/Lost Reason Code"; Code[10])
        {
            Caption = 'Won/Lost Reason Code';
            DataClassification = CustomerContent;
            TableRelation = if ("SOL Quote Status" = const(Won)) "Close Opportunity Code" where(type = Const(Won))
            else
            if ("SOL Quote Status" = const(Lost)) "Close Opportunity Code" where(type = const(Lost));
            ValidateTableRelation = false;
        }
        field(50113; "SOL Won/Lost Reason Desc."; Text[100])
        {
            Caption = 'Won/Lost Reason Description';
            FieldClass = FlowField;
            CalcFormula = lookup("Close Opportunity Code".Description where(Code = field("SOL Won/Lost Reason Code")));
            Editable = false;

        }
        field(50114; "SOL Won/Lost Remarks"; Text[2048])
        {
            Caption = 'SOL Won/Lost Remarks';
            DataClassification = CustomerContent;

        }
    }
}