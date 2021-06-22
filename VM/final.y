%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
int temp;
int temp2;
%}
%union {
int ival;
struct def{
int x[100];
int n;
} arr;
}
%token <ival> num boolval
%token <ival> id
%token Lpa Rpa
%token eq
%token pls min
%token mul divv mod
%token gre sma
%token andd orr nott
%token def fun
%token iff printnum printbool
%type <ival> EXP NUMOP PLUS MINUS MULTIPLY DIVIDE MODULUS GREATER SMALLER EQUAL 
%type <ival> LOGICALOP ANDOP OROP NOTOP IFEXP TESTEXP THENEXP ELSEEXP
%type <arr> EXPLIST

%%
PROGRAM : STMT
;
STMT : EXP | PRINTSTMT | STMT EXP | STMT PRINTSTMT
;
PRINTSTMT : Lpa printnum EXP Rpa {printf("%d\n",$3);}
| Lpa printbool EXP Rpa {if($3==0){printf("#f\n");}else{printf("#t\n");};}
;
EXPLIST : EXP {$$.x[0] = $1;$$.n = 1;}
| EXPLIST EXP {$$.x[$1.n] = $2;$$.n = $1.n + 1;}
; 
EXP : boolval {$$ = $1;}
| num {$$ = $1;}
| NUMOP
| LOGICALOP
| IFEXP
;
NUMOP : PLUS | MINUS | MULTIPLY | DIVIDE | MODULUS | GREATER | SMALLER | EQUAL
;
PLUS : Lpa pls EXP EXPLIST Rpa {$$ = $3;for(temp = 0 ; temp < $4.n ; temp++){$$ += $4.x[temp];};}
;
MINUS : Lpa min EXP EXP Rpa {$$ = $3 - $4;}
;
MULTIPLY : Lpa mul EXP EXPLIST Rpa {$$ = $3;for(temp = 0 ; temp < $4.n ; temp++){$$ *= $4.x[temp];};}
;
DIVIDE : Lpa divv EXP EXP Rpa {$$ = $3 / $4;}
;
MODULUS : Lpa mod EXP EXP Rpa {$$ = $3 % $4;}
;
GREATER : Lpa gre EXP EXP Rpa {if($3>$4){$$ = 1;}else{$$ = 0;};}
;
SMALLER : Lpa sma EXP EXP Rpa {if($3<$4){$$ = 1;}else{$$ = 0;};}
;
EQUAL : Lpa eq EXP EXPLIST Rpa {temp2=1 ; for(temp = 0 ; temp < $4.n ; temp++){if($4.x[temp]!=$3){temp2=0;};} ; if(temp2==1){$$ = 1;}else{$$ = 0;};}
;
LOGICALOP : ANDOP | OROP | NOTOP
;
ANDOP : Lpa andd EXP EXPLIST Rpa {if($3==0){temp2=0;}else{temp2=1;} ; for(temp = 0 ; temp < $4.n ; temp++){if($4.x[temp]==0){temp2=0;};} ; if(temp2==1){$$ = 1;}else{$$ = 0;};}
;
OROP : Lpa orr EXP EXPLIST Rpa {if($3==0){temp2=0;}else{temp2=1;} ; for(temp = 0 ; temp < $4.n ; temp++){if($4.x[temp]==1){temp2=1;};} ; if(temp2==1){$$ = 1;}else{$$ = 0;};}
;
NOTOP : Lpa nott EXP Rpa {if($3==0){$$ = 1;}else{$$ = 0;};}
;
IFEXP : Lpa iff TESTEXP THENEXP ELSEEXP Rpa {if($3==1){$$ = $4;}else{$$ = $5;};}
;
TESTEXP : EXP
;
THENEXP : EXP
;
ELSEEXP : EXP
%%
void yyerror (const char *message)
{
fprintf (stderr, "%s\n",message);
}
int main() {
yyparse();
return 0;
}