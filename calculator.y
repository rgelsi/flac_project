%{
int yylex();
void yyerror(char *s);

extern int tokenwert;
extern int zeilennr;

#define prompt printf("\n%5d : ",++zeilennr)
%}

%start zeilen
%token PLUS MINUS MULT DIV AUF ZU ZAHL ZEILENENDE NICHTS

%%

zeilen  :                                           /* leeres Symbol (Epsilon) */
        | ausdruck {printf("%d",$1); prompt;} ZEILENENDE zeilen
        ;

ausdruck: ausdruck PLUS term { $$ = $1 + $3; }
        | ausdruck MINUS term { $$ = $1 - $3; }
        | term { $$ = $1; }
        ;

term    : term MULT factor { $$ = $1 * $3; }
        | term DIV factor { $$ = $1 / $3; }
        | factor { $$ = $1; }
        ;

factor  : AUF ausdruck ZU { $$ = $2; }
        | ZAHL { $$ = tokenwert; }
        | MINUS ZAHL { $$ = -tokenwert; }
        ;

%%

#include "lex.yy.c"

void yyerror(char *s)       /* Routine wird bei Fehler aufgerufen */
{                           /* und gibt Fehlermeld. `s' aus, was */
    printf("%s\n", s);      /* die Meldung 'syntax error' ist. */
}

int main(void)
{
 printf("%5d : ", zeilennr);
 yyparse();
 return(0);
}