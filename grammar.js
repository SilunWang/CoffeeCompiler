S->BS | EPS;
B->IFB|FORB|EXPB
B->B|B;

EXPB -> v = EXPB
EXPB -> OBJB|ARRAYB|CONST|v
EXPB -> EXPB opt EXPB|EXPB logical EXPB|EXPB comp EXPB
opt-> +|-|**|
logical -> and|or|
comp -> ==|>=

CONST -> num|stirng|boolean|undefined|null
boolean -> true| yes| on| false| no| off


IFB-> IFT \n(\tB\n)+
FORB -> FORT \n(\tB\n)+ 

OBJB:
O -> {E} | E
E -> Sin | Mul | e
Sin -> (n:v,)*(n:v)
Mul -> \n(\t n:v \n)+
v -> EXPB

ARRAYB: 
A -> [E]
E -> (element(\n)*,(\n)*)*element(\n)* | e


IFT -> if(\s)*(EXPB)|if(\s)* EXPB
FORT -> for v,v of EXPB|for v of EXPB| for v in EXPB
