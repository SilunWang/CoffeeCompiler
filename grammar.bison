%lex
%%

//substitute map
and			return '&&'
'&&'		return '&&'
or   		return '||'
'||'		return '||'
is   		return '==='
'=='		return '==='
isnt 		return '!=='
'!='		return '!=='
not  		return '!'
yes  		return 'true'
no   		return 'false'
on   		return 'true'
off  		return 'false'

//
\s
//^[^\n\s]+	/* skip whitespace */

//comment 
^###([^#][\s\S]*?)(?:###[^\n\S]*|(?:###)?$)|^(?:\s*#(?!##[^#]).*)+		return 'COMMENT'

[a-zA-Z][a-zA-Z0-9_]*		return 'VARIABLE' 

//js keywords
'true'		return 'true'
'false'		return 'false'
'null'		return 'null'
'this'		return 'this'
'in'		return 'of'
'return'    return 'return'
'break'     return 'break'
'continue' 	return 'continue'
'if'		return 'if'
'else'		return 'else'
'for'		return 'for'
'while'		return 'while'
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
"%"                   return '%'
"("                   return '('
")"                   return ')'
"PI"                  return 'PI'



/* operator associations and precedence */
%left '+' '-'
%left '*' '/' '**' '\/\/'
%left '^'
%left '==' ''
%right '!'
%right '%'
%left UMINUS