%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    void yyerror(const char *message);
    int i;
    int j;
    struct Node {
        int data;
        struct Node* head;
        struct Node* next;
    };
    struct Node* newNode(int data) {
        struct Node* node = (struct Node *) malloc(sizeof(struct Node));
        node->data = data;
        return node;
    }
    struct Node* nextNode(struct Node* current) {
        struct Node* next_node = current->next;
        free(current);
        return next_node;
    }
%}

%union {
    int ival;
    struct Node* arr;
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
PROGRAM     : STMT
            ;
STMT        : EXP | PRINTSTMT | STMT EXP | STMT PRINTSTMT
            ;
PRINTSTMT   : Lpa printnum EXP Rpa      { printf("%d\n",$3); }
            | Lpa printbool EXP Rpa     { if($3 == 0) { printf("#f\n"); } else { printf("#t\n"); }; }
            ;
EXPLIST     : EXP           { 
                $$ = newNode($1);
                $$->next = NULL;
                $$->head = $$;
            }
            | EXPLIST EXP   { 
                $$ = newNode($2);
                $$->next = NULL;
                $$->head = $1->head;
                $1->next = $$;
            }
            ; 
EXP         : boolval       { $$ = $1; }
            | num           { $$ = $1; }
            | NUMOP 
            | LOGICALOP
            | IFEXP
            ;
NUMOP       : PLUS | MINUS | MULTIPLY | DIVIDE | MODULUS | GREATER | SMALLER | EQUAL
            ;
PLUS        : Lpa pls EXP EXPLIST Rpa   { 
                $$ = $3; 
                 
                for (struct Node* iter_node = $4->head; iter_node != NULL ; iter_node = nextNode(iter_node)) { 
                    $$ += iter_node->data; 
                }; 
            }
            ;
MINUS       : Lpa min EXP EXP Rpa       { $$ = $3 - $4; }
            ;
MULTIPLY    : Lpa mul EXP EXPLIST Rpa   { 
                $$ = $3; 
                 
                for (struct Node* iter_node = $4->head; iter_node != NULL ; iter_node = nextNode(iter_node)) { 
                    $$ *= iter_node->data; 
                };  
            }
            ;
DIVIDE      : Lpa divv EXP EXP Rpa      { $$ = $4 == 0 ? 0 : $3 / $4; }
            ;
MODULUS     : Lpa mod EXP EXP Rpa       { $$ = $4 == 0 ? 0 : $3 % $4; }
            ;
GREATER     : Lpa gre EXP EXP Rpa       { if($3 > $4) { $$ = 1; } else { $$ = 0; }; }
            ;
SMALLER     : Lpa sma EXP EXP Rpa       { if($3 < $4) { $$ = 1; } else { $$ = 0; }; }
            ;
EQUAL       : Lpa eq EXP EXPLIST Rpa    { 
                $$ = 1; 
                 
                for (struct Node* iter_node = $4->head; iter_node != NULL ; iter_node = nextNode(iter_node)) { 
                    if ($3 != iter_node->data) $$ = 0; 
                }; 
            }
            ;
LOGICALOP   : ANDOP | OROP | NOTOP
            ;
ANDOP       : Lpa andd EXP EXPLIST Rpa  { 
                $$ = $3; 
                 
                for (struct Node* iter_node = $4->head; iter_node != NULL ; iter_node = nextNode(iter_node)) { 
                    $$ &= iter_node->data; 
                };  
            }
            ;
OROP        : Lpa orr EXP EXPLIST Rpa   { 
                $$ = $3; 
                 
                for (struct Node* iter_node = $4->head; iter_node != NULL ; iter_node = nextNode(iter_node)) { 
                    $$ |= iter_node->data; 
                };  
            }
            ;
NOTOP       : Lpa nott EXP Rpa          { if($3 == 0) { $$ = 1; } else { $$ = 0; }; }
            ;
IFEXP       : Lpa iff TESTEXP THENEXP ELSEEXP Rpa  { if($3 == 1) { $$ = $4; } else { $$ = $5; }; }
            ;
TESTEXP     : EXP
            ;
THENEXP     : EXP
            ;
ELSEEXP     : EXP
%%

void yyerror (const char *message) {
    fprintf (stderr, "%s\n",message);
}
int main() {
    yyparse();
    return 0;
}