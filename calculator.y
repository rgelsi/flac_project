%{
int yylex();
void yyerror(char *s);

extern int rowno;

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

#define prompt printf("\n%5d : ",++rowno)
%}

%union {
    double value;			//value of an identifier of type NUM
}

%start line
%token <value> NUM
%token PLUS MINUS MULT DIV OPEN CLOSE ENDOFLINE EMPTY

%type <value> expr
%type <value> term
%type <value> factor

%%

line    : /* leeres Symbol (Epsilon) */
        | expr {printf("%f",$1); prompt;} ENDOFLINE line
        ;

expr    : expr PLUS term { $$ = $1 + $3; }
        | expr MINUS term { $$ = $1 - $3; }
        | term { $$ = $1; }
        ;

term    : term MULT factor { $$ = $1 * $3; }
        | term DIV factor { $$ = $1 / $3; }
        | factor { $$ = $1; }
        ;

factor  : OPEN expr CLOSE { $$ = $2; }
        | NUM { $$ = $1; }
        | MINUS NUM { $$ = -$2; }
        ;

%%

#include "lex.yy.c"

void yyerror(char *s)       /* Routine wird bei Fehler aufgerufen */
{                           /* und gibt Fehlermeld. `s' aus, was */
    printf("%s\n", s);      /* die Meldung 'syntax error' ist. */
}

int main(void)
{
 printf("%5d : ", rowno);
 yyparse();
 return(0);
}