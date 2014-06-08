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
'>='		return '>='
'<='		return '<='
'<'			return '<'
'>'			return '>'
'yes'  		return 'true'
'no'   		return 'false'
'on'   		return 'true'
'off'  		return 'false'

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

//punctuation
'{' 		return 'LEFT_BRACE'
'}' 		return 'RIGHT_BRACE'
'[' 		return 'LEFT_BRACKET'
']' 		return 'RIGHT_BRACKET'
'(' 		return '('
')' 		return ')'
','			return ','
':'			return 'COLON'


';'			/* skip whitespace */
[\s\n]+ 	/* skip whitespace */

//comment 
//^###([^#][\s\S]*?)(?:###[^\n\S]*|(?:###)?$)|^(?:\s*#(?!##[^#]).*)+		return 'COMMENT'

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

[a-zA-Z][a-zA-Z0-9_]*\[[a-zA-Z0-9_]+\]      return 'ARRAY_ELEMENT'
[a-zA-Z][a-zA-Z0-9_]*\.[a-zA-Z0-9_]+		return 'OBJ_ELEMENT' 
[a-zA-Z][a-zA-Z0-9_]*		return 'VARIABLE' 

/lex

/* operator associations and precedence */
%left '+' '-'
%left '*' '/' 'POW'
%left '^'
%left '==='
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
		{ $$ = $1 + ';\n'; }
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
	| EXT_VARIABLE '=' ExprBlock
		{ $$ = $1 + ' ' + $2 + ' ' + $3; }
	| EXT_VARIABLE
		{ $$ = $1; }
	| FUNCTION
		{ $$ = $1; }
	| 'VARIABLE' '(' ExprBlocks ')'
		{ $$ = $1 + $2 + $3 + $4; }
	| ExprBlock '+' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '-' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '*' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '/' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock CMP ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '&&' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| ExprBlock '||' ExprBlock
		{ $$ = $1 + $2 + $3; }
	| '(' ExprBlock ')'
		{ $$ = $1 + $2 + $3; }
	| '!' ExprBlock
		{ $$ = $1 + $2; }
	| ExprBlock 'POW' ExprBlock
		{ $$ = 'Math.pow(' + $1 + ', ' + $3 + ')'; }
	| 'return' ExprBlock
		{ $$ = $1 + ' ' + $2; }
	| 'break'
		{ $$ = $1; }
	| 'continue'
		{ $$ = $1; }
	;

CMP
	: '==='
		{ $$ = '==='; }
	| '!=='
		{ $$ = '!=='; }
	| '>='
		{ $$ = '>='; }
	| '<='
		{ $$ = '<='; }
	| '>'
		{ $$ = '>'; }
	| '<'
		{ $$ = '<'; }
	;

EXT_VARIABLE
	: 'VARIABLE'
		{ $$ = $1; }
	| 'ARRAY_ELEMENT'
		{ $$ = $1; }
	| 'OBJ_ELEMENT'
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
		{ $$ = $1 + ' ' + $2 + ' ' + $3; }
	;

KeyValues
	: KeyValue KeyValues
		{ $$ = $1 + $2; }
	| 
		{ $$ = ''; }
	;

KeyValue
	: ',' KeyValueEnd 
		{ $$ = $1 + ' ' + $2; }
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
		{ $$ = $1 + ' {' + '\n' + $3 + '}\n'; }
	;

IfCondition
	: 'if' '(' ExprBlock ')'
		{ $$ = 'if' + '(' + $3 + ')'; }
	| 'if' ExprBlock
		{ $$ = 'if' + '(' + $2 + ')';}
	;

ElseBlock
	: 'else' LEFT_BRACE Blocks RIGHT_BRACE
		{ $$ = $1 + ' {' + '\n' + $3 + '}\n'; }
	;

Blocks
	: Block
		{ $$ = $1; }
	| Block Blocks
		{ $$ = $1 + $2; }
	;

ForBlock
	: ForCondition LEFT_BRACE Blocks RIGHT_BRACE
		{ $$ = $1 + $3 + '}\n'; }
	;

WhileBlock
	: WhileCondition LEFT_BRACE Blocks RIGHT_BRACE
		{ $$ = $1 + ' {' + '\n' + $3 + '}\n'; }
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
			$$ = '_ref = ' + $6 + '\n' + 
		         'for (' + $2 + ' in _ref) {' + '\n' +
		         $4 + ' = _ref[' + $2 + ']' + ';\n';
		}
	| 'for' 'VARIABLE' ',' 'VARIABLE' 'of' 'VARIABLE'
		{ 
			$$ = 'for (' + $2 + ' in ' + $6 + ') {' + '\n' +
		         $4 + ' = ' + $6 + '[' + $2 + ']' + ';\n';
		}
	| 'for' 'VARIABLE' 'of' ObjBlock
		{ $$ = 'for (' + $2  + ' in ' + $4 + ') {' + '\n'; }
	| 'for' 'VARIABLE' 'of' 'VARIABLE'
		{ $$ = 'for (' + $2  + ' in ' + $4 + ') {' + '\n'; }
	| 'for' 'VARIABLE' 'in' ArrayBlock
		{
			$$ = '_ref = ' + $4 + '\n' +
			     'for (_' + $2 + ' = 0, _len = _ref.length; _' + 
				 $2 + ' < _len; _' + $2 + '++) {' + '\n' +
				 $2 + ' = _ref[_' + $2 + ']' + ';\n';
		}
	| 'for' 'VARIABLE' 'in' 'VARIABLE'
		{
			$$ = 'for (_' + $2 + ' = 0, _len = ' + $4 + '.length; _' + 
				 $2 + ' < _len; _' + $2 + '++) {' + '\n' +
				 $2 + ' = ' + $4 + '[_' + $2 + ']' + ';\n';
		}
	;

FUNCTION
	: '(' VARIABLES ')' '->' LEFT_BRACE S RIGHT_BRACE
		{ $$ = 'function(' + $2 + ') {' + '\n' + $6 + '}'; }
	|	'->' LEFT_BRACE S RIGHT_BRACE
		{ $$ = 'function() {' + '\n' + $3 + '}'; }
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
	: ',' 'VARIABLE'
		{ $$ = $1 + ' ' + $2; }
	;

ExprBlocks
	: ExprBlock ExprBlocks_
		{ $$ = $1 + $2; }
	|
		{ $$ = ''; }
	;

ExprBlocks_
	: ExprBlock_ ExprBlocks_
		{ $$ = $1 + $2; }
	|
		{ $$ = ''; }
	;

ExprBlock_
	: ',' ExprBlock
		{ $$ = $1 + ' ' + $2; }
	;
