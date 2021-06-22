%{
#include "final.tab.h"
#include <stdio.h>
#include <string.h>
%}
Plus "+"
Minus "-"
Multiply "*"
Divide "/"
Modulus "mod"
Greater ">"
Smaller "<"
Equal "="
And "and"
Or "or"
Not "not"
Define "define"
Function "fun"
If "if"
Lpa "("
Rpa ")"
True #t
False #f
PrintNum "print-num"
PrintBool "print-bool"
Num (0|[1-9][0-9]*|[-][1-9][0-9]*)
Id [a-z]([a-z]|[0-9]|"-")*
Other1 [\t]
Other2 [\r]
Other3 [\n]
Other4 .
%%
{Plus} { return pls;}
{Minus} { return min;}
{Multiply} { return mul;}
{Divide} { return divv;}
{Modulus} { return mod;}
{Greater} { return gre;}
{Smaller} { return sma;}
{Equal} { return eq;}
{And} { return andd;}
{Or} { return orr;}
{Not} { return nott;}
{Define} { }
{Function} { }
{If} { return iff;}
{Lpa} { return Lpa;}
{Rpa} { return Rpa;}
{True} { yylval.ival = 1; return boolval;}
{False} { yylval.ival = 0; return boolval;}
{PrintNum} { return printnum;}
{PrintBool} { return printbool;}
{Num} { yylval.ival = atoi(yytext); return num; }
{Id} { yylval.ival = atoi(yytext); return id; }
{Other1} {}
{Other2} {}
{Other3} {}
{Other4} {}
%%