%start coffee

%% /* language grammar */

coffee
    : S EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

S
	: Block S
		{		}
	| Eps
		{		}
	;

Block
	: IfBlock
		{		}
	| ForBlock
		{		}
	| ExprBlock
		{		}
	;

ExprBlock
	: var '=' ExprBlock
		{		}
	| ObjBlock
		{		}
	| ArrayBlock
		{		}
	| Const
		{		}
	| var
		{		}
	| ExprBlock '+' ExprBlock
		{		}
	| ExprBlock '-' ExprBlock
		{		}
	| ExprBlock '**' ExprBlock
		{		}
	| ExprBlock '\/\/' ExprBlock
		{		}
	| ExprBlock 'and' ExprBlock
		{		}
	| ExprBlock 'or' ExprBlock
		{		}
	| ExprBlock '==' ExprBlock
		{		}
	| ExprBlock '>=' ExprBlock
		{		}
	;

Const
	: num
		{		}
	| string
		{		}
	| bool
		{		}
	| undefined
		{		}
	| null
		{		}
	;

bool
	: true
		{		}
	| yes
		{		}
	| on
		{		}
	| false
		{		}
	| no
		{		}
	| off
		{		}
	;

IfBlock
	: IfCondition \n(\tBlock\n)+
		{		}
	;

IfCondition
	: 'if'(\s)*(ExprBlock)
		{		}
	| 'if'(\s)* ExprBlock
		{		}
	;


ForBlock
	: ForCondition \n(\tB\n)+
		{		}
	;

ForCondition
	: 'for' var, var 'of' ExprBlock
		{		}
	| 'for' var 'of' ExprBlock
		{		}
	| 'for' var 'in' ExprBlock
		{		}
	;

ObjBlock
	: '{' ObjExpr '}'
		{		}
	| ObjExpr
		{		}
	;

ObjExpr
	: SinLine
		{		}
	| MulLine
		{		}
	| Eps
		{		}
	;

SinLine
	: (name: value,)*(name: value)
		{		}
	;

MulLine
	: \n(\t name: value \n)+
		{		}
	;

value
	: ExprBlock
		{		}
	;

ArrayBlock
	: '[' ArrExpr ']'
		{		}
	;

ArrExpr
	: (element(\n)*,(\n)*)*element(\n)*
		{		}
	| Eps
		{		}
	;

