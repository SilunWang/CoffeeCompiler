S->BS | EPS;
B->IFB|FORB|EXPB
B->B|B;

EXPB -> v = EXPB
EXPB -> OBJB|ARRAYB|CONST|v|BOOLB
EXPB -> EXPB opt EXPB
opt-> +|-|**|

BOOLB -> v|CONST c EXPB
BOOLB -> BOOLB l BOOLB
l -> and|or|
c -> ==|>=


IFB-> IFT \n(\tB\n)+
FORB -> FORT \n(\tB\n)+ 

OBJB:
O -> {E} | E
E -> Sin | Mul | e
Sin -> (n:v,)*(n:v)
Mul -> \n(\t n:v \n)+
v -> EXPB

ARRAYB: 
A -> [E]|
E -> (element(\n)*,(\n)*)*element(\n)* | e

CONST -> num|stirng|boolean|undefined|null

IFT -> if(\s)*(EXPB)|
BOOLB -> v|CONST
