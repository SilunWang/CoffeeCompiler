%lex
%%

//operator
[0-9]+(\.[0-9]+)?\b   return 'NUMBER'
\".*\"				  return 'STRING'
\'.*\'				  return 'STRING'
\*{2}				  return 'POW'
\*{1}                 return '*'
\#{2}				  return 'INDENT'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"!"                   return '!'
"%"                   return 'MOD'
'='					  return '='
"PI"                  return 'PI'

<<EOF>>               return 'EOF'

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
'[' 		return 'LEFT_BRACKET'
']' 		return 'RIGHT_BRACKET'
'(' 		return '('
')' 		return ')'
','			return ','
':'			return 'COLON'
';'			return 'SEMICOLON'

[\s\n]+ 	/* skip whitespace */

//comment 
//^###([^#][\s\S]*?)(?:###[^\n\S]*|(?:###)?$)|^(?:\s*#(?!##[^#]).*)+		return 'COMMENT'

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




/lex

/* operator associations and precedence */
%left '+' '-'
%left '*' '/' 'POW'
%left '^'
%left '=='
%right '!'
%right '%'
%left UMINUS

%start coffee

%% /* language grammar */

coffee
    : S EOF
        { return $1; }
    ;

S
	: Block S
		{ $$ = $1 + $2; }
	| 
		{ $$ = ''; }
	;

Block
	: ExprBlock
		{ $$ = $1; }
	| ForBlock
		{ $$ = $1; }
	| IfBlock
		{ $$ = $1; }
	;

ExprBlock
	: ObjBlock 
		{ $$ = $1; }
	| ArrayBlock 
		{ $$ = $1; }
	| Const 
		{ $$ = $1; }
	| 'VARIABLE' '=' ExprBlock
		{ $$ = $1 + ' ' + $2 + ' ' + $3; }
	| 'VARIABLE'
		{ $$ = $1; }
	| ExprBlock '+' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '-' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '*' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '/' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock 'POW' ExprBlock
		{ $$ = 'Math.pow(' + $1 + ', ' + $3 + ')'; }		
	;

Const
	: 'NUMBER'
		{ $$ = $1; }
	| 'STRING'
		{ $$ = $1; }
	| bool
		{ $$ = $1; }
	| 'undefined'
		{ $$ = $1; }
	| 'null'
		{ $$ = $1; }
	;

bool
	: 'true'
		{ $$ = 'true'; }
	| 'false'
		{ $$ = 'false';	}
	;



ArrayBlock
	: 'LEFT_BRACKET' MultiElement
		{ $$ = $1 + $2; }
	| 'LEFT_BRACKET' 'RIGHT_BRACKET'
		{ $$ = "[]" }
	;


MultiElement 
	: ElementEnd ',' MultiElement 
		{ $$ = $1 + $2 + ' ' + $3; }
	| ElementEnd 'RIGHT_BRACKET'
		{ $$ = $1 + ']' }
	;

ElementEnd
	: ExprBlock
		{ $$ = $1; }
	;


ObjBlock
	: 'LEFT_BRACE' ObjExpr 'RIGHT_BRACE'
		{ $$ = '{' + $2 + '}'; }
	| 'LEFT_BRACE' 'RIGHT_BRACE'
		{ $$ = "{}"; }
	| ObjExpr
		{ $$ = $1; }
	;

ObjExpr
	: SinLine 
		{ $$ = $1; }
//	| MulLine
//		{ $$ = $1; }
	;

SinLine
	: KeyValueEnd KeyValues
		{ $$ = $1 + $2; }
	;

KeyValues
	: KeyValue KeyValues
		{ $$ = $1 + $2; }
	| 
		{ $$ = ""; }
	;

KeyValue
	: ',' AttrKey 'COLON' AttrValue 
		{ $$ = $1 + $2 + $3 + $4; }
	;

KeyValueEnd
	: AttrKey 'COLON' AttrValue
		{ $$ = $1 + $2 + $3; }
	;

AttrKey
	: 'VARIABLE'
		{ $$ = $1; }
	| 'NUMBER'
		{ $$ = $1; }
	| 'STRING'
		{ $$ = $1; }
	;

AttrValue
	: ExprBlock
		{ $$ = $1; }
	;
