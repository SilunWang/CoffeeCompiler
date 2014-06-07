%lex
%%

//operator
'->'				  return '->'
[0-9]+(\.[0-9]+)?\b   return 'NUMBER'
\".*\"				  return 'STRING'
\'.*\'				  return 'STRING'
\*{2}				  return 'POW'
\*{1}                 return '*'
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


';'				/* skip whitespace */
[\s<br />]+ 	/* skip whitespace */

//comment 
//^###([^#][\s\S]*?)(?:###[^<br />\S]*|(?:###)?$)|^(?:\s*#(?!##[^#]).*)+		return 'COMMENT'

//js keywords
'this'		return 'this'
'in'		return 'in'
'of'		return 'of'
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

[a-zA-Z][a-zA-Z0-9_]*		return 'VARIABLE' 

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
		{ $$ = $1 + ';<br />'; }
	| ForBlock
		{ $$ = $1; }
	| WhileBlock
		{ $$ = $1; }
	| IfBlock
		{ $$ = $1; }
	| IfBlock ElseBlock
		{ $$ = $1 + $2; }
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
	| 'VARIABLE' '=' FUNCTION
		{ $$ = $1 + ' ' + $2 + ' ' + $3; }
	| FUNCTION
		{ $$ = '(' + $1 + ')'; }
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
	| 'return' ExprBlock
		{ $$ = $1 + $2; }
	| 'break'
		{ $$ = $1; }
	| 'continue'
		{ $$ = $1; }
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
		{ $$ = '[]' }
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
		{ $$ = '{}'; }
	| ObjExpr
		{ $$ = '{' + $1 + '}'; }
	;

ObjExpr
	: KeyValueEnd KeyValues
		{ $$ = $1 + $2; }
	;

KeyValueEnd
	: AttrKey 'COLON' AttrValue
		{ $$ = $1 + $2 + $3; }
	;

KeyValues
	: KeyValue KeyValues
		{ $$ = $1 + $2; }
	| 
		{ $$ = ''; }
	;

KeyValue
	: ',' KeyValueEnd 
		{ $$ = $1 + $2; }
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

IfBlock
	: IfCondition LEFT_BRACE Blocks RIGHT_BRACE
		{ $$ = $1 + ' {' + '<br />' + $3 + '}<br />'; }
	;

IfCondition
	: 'if' '(' ExprBlock ')'
		{ $$ = 'if' + '(' + $3 + ')'; }
	| 'if' ExprBlock
		{ $$ = 'if' + '(' + $2 + ')';}
	;

ElseBlock
	: 'else' LEFT_BRACE Blocks RIGHT_BRACE
		{ $$ = $1 + ' {' + '<br />' + $2 + '}<br />'; }
	;

Blocks
	: Block
		{ $$ = $1; }
	| Block Blocks
		{ $$ = $1 + $2; }
	;

ForBlock
	: ForCondition LEFT_BRACE Blocks RIGHT_BRACE
		{ $$ = $1 + $3 + '}<br />'; }
	;

WhileBlock
	: WhileCondition LEFT_BRACE Blocks RIGHT_BRACE
		{ $$ = $1 + ' {' + '<br />' + $3 + '}<br />'; }
	;

WhileCondition
	: 'while' '(' ExprBlock ')'
		{ $$ = 'while' + '(' + $3 + ')'; }
	| 'while' ExprBlock
		{ $$ = 'while' + '(' + $2 + ')';}
	;

ForCondition
	: 'for' 'VARIABLE' ',' 'VARIABLE' 'of' ObjBlock
		{ 
			$$ = '_ref = ' + $6 + '<br />' + 
		         'for (' + $2 + ' in _ref) {' + '<br />' +
		         $4 + ' = _ref[' + $2 + ']' + ';<br />';
		}
	| 'for' 'VARIABLE' ',' 'VARIABLE' 'of' 'VARIABLE'
		{ 
			$$ = 'for (' + $2 + ' in ' + $6 + ') {' + '<br />' +
		         $4 + ' = ' + $6 + '[' + $2 + ']' + ';<br />';
		}
	| 'for' 'VARIABLE' 'of' ObjBlock
		{ $$ = 'for (' + $2  + ' in ' + $4 + ') {' + '<br />'; }
	| 'for' 'VARIABLE' 'of' 'VARIABLE'
		{ $$ = 'for (' + $2  + ' in ' + $4 + ') {' + '<br />'; }
	| 'for' 'VARIABLE' 'in' ArrayBlock
		{
			$$ = '_ref = ' + $4 + '<br />' +
			     'for (_' + $2 + ' = 0, _len = _ref.length; _' + 
				 $2 + ' < _len; _' + $2 + '++) {' + '<br />' +
				 $2 + ' = _ref[_' + $2 + ']_' + ';<br />';
		}
	| 'for' 'VARIABLE' 'in' 'VARIABLE'
		{
			$$ = 'for (_' + $2 + ' = 0, _len = ' + $4 + '.length; _' + 
				 $2 + ' < _len; _' + $2 + '++) {' + '<br />' +
				 $2 + ' = ' + $4 + '[_' + $2 + ']_' + ';<br />';
		}
	;

FUNCTION
	: '(' VARIABLES ')' '->' LEFT_BRACE S RIGHT_BRACE
		{ $$ = 'function(' + $2 + ') {' + '<br />' + $6 + '}'; }
	;

VARIABLES
	: 'VARIABLE' VARIABLES_
		{ $$ = $1 + $2; }
	| 
		{ $$ = ''; }
	;

VARIABLES_
	: VARIABLE_ VARIABLES_
		{ $$ = $1 + $2; }
	|
		{ $$ = ''; }
	;

VARIABLE_
	: ', ' 'VARIABLE'
		{ $$ = $1 + $2; }
	;
