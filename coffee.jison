%lex
%%

//substitute map
'and'		return '&&'
'&&'		return '&&'
'or'   		return '||'
'||'		return '||'
'is'   		return '==='
'=='		return '==='
'isnt' 		return '!=='
'!='		return '!=='
'not'  		return '!'
'yes'  		return 'true'
'no'   		return 'false'
'on'   		return 'true'
'off'  		return 'false'

//punctuation
'{' 		return 'LEFT_BRACE'
'}' 		return 'RIGHT_BRACE'
'[' 		return '['
']' 		return ']'
'(' 		return '('
')' 		return ')'
','			return ','
':'			return 'COLON'
';'			return 'SEMICOLON'

\n+    	return 'ENTERS' 
\s+ 		

//^[^\n\s]+	/* skip whitespace */

//comment 
^###([^#][\s\S]*?)(?:###[^\n\S]*|(?:###)?$)|^(?:\s*#(?!##[^#]).*)+		return 'COMMENT'

[a-zA-Z][a-zA-Z0-9_]*		return 'VARIABLE' 

//js keywords
'this'		return 'this'
'in'		return 'of'
'return'    return 'return'
'break'     return 'break'
'continue' 	return 'continue'
'if'		return 'if'
'else'		return 'else'
'for'		return 'for'
'while'		return 'while'
'true'		return 'true'
'false'		return 'false'
'null'		return 'null'
'undefined' return 'undefined'


//coffee keywords
'then'		return 'then'
'unless' 	return 'unless'
'until' 	return 'until'


//operator
[0-9]+(\.[0-9]+)?\b   return 'NUMBER'
\".*\"				  return 'STRING'
\'.*\'				  return 'STRING'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return 'MOD'
"PI"                  return 'PI'

/lex

/* operator associations and precedence */
%left '+' '-'
%left '*' '/' '**' '\/\/'
%left '^'
%left '=='
%right '!'
%right '%'
%left UMINUS


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
	| 
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
	: 'VARIABLE' '=' ExprBlock ExprBlock_
		{		}
	| ObjBlock ExprBlock_
		{		}
	| ArrayBlock ExprBlock_
		{		}
	| Const ExprBlock_
		{		}
	| 'VARIABLE' ExprBlock_
		{		}
	;


ExprBlock_
	: '+' ExprBlock ExprBlock_
		{		}
	| '-' ExprBlock ExprBlock_
		{		}
	| '**' ExprBlock ExprBlock_
		{		}
	| '\/\/' ExprBlock ExprBlock_
		{		}
	| 'and' ExprBlock ExprBlock_
		{		}
	| 'or' ExprBlock ExprBlock_
		{		}
	| '==' ExprBlock ExprBlock_
		{		}
	| '>=' ExprBlock ExprBlock_
		{		}
	|
		{		}
	;

Const
	: 'NUMBER'
		{		}
	| 'STRING'
		{		}
	| bool
		{		}
	| 'undefined'
		{		}
	| 'null'
		{		}
	;

bool
	: 'true'
		{		}
	| 'yes'
		{		}
	| 'on'
		{		}
	| 'false'
		{		}
	| 'no'
		{		}
	| 'off'
		{		}
	;

IfBlock
	: IfCondition '\n' IndentExprs
		{		}
	;

IndentExprs
	: IndentExpr
		{		}
	| IndentExpr IndentExprs
		{		}
	;

IndentExpr
	:  '(' '\t' Block '\n' ')'
		{		}
	;

IfCondition
	: 'if' '(' ExprBlock ')'
		{		}
	| 'if' ExprBlock
		{		}
	;


ForBlock
	: ForCondition '\n' IndentExprs
		{		}
	;

ForCondition
	: 'for' 'VARIABLE' ',' 'VARIABLE' 'of' ExprBlock
		{		}
	| 'for' 'VARIABLE' 'of' ExprBlock
		{		}
	| 'for' 'VARIABLE' 'in' ExprBlock
		{		}
	;

ObjBlock
	: 'LEFT_BRACE' ObjExpr 'RIGHT_BRACE'
		{		}
	| ObjExpr
		{		}
	;

ObjExpr
	: SinLine
		{		}
	| MulLine
		{		}
	| 
		{		}
	;

SinLine
	: KeyValues	KeyValueEnd
		{		}
	;

KeyValues
	: KeyValue KeyValues
		{		}
	| 
		{		}
	;

KeyValue
	: AttrKey 'COLON' AttrValue ','
		{		}
	;

KeyValueEnd
	: AttrKey 'COLON' AttrValue
		{		}
	;

AttrKey
	: 'VARIABLE'
		{		}
	| 'NUMBER'
		{		}
	| 'STRING'
		{		}
	;

AttrValue
	: ExprBlock
		{		}
	;

MulLine
	: 'ENTERS' Lines
		{		}
	;
Lines
	: Line Lines
		{		}
	| Line
		{		}
	;

Line
	: '\t' KeyValueEnd 'ENTERS'
		{		}
	| '\t' KeyValue 'ENTERS'
		{		}
	; 	 


ArrayBlock
	: '[' ArrExpr ']'
		{		}
	;

ArrExpr
	: Elements EntersEmpty
		{		}
	| 
		{		}
	;

Elements 
	: MultiElement EntersEmpty ElementEnd
		{}
	;


MultiElement 
	: EntersEmpty ElementEnd ',' MultiElement 
		{}
	| 
		{}
	;

ElementEnd
	: ExprBlock
		{}
	;

EntersEmpty
	: 'ENTERS'
		{}
	| 
		{}
	;
