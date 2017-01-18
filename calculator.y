%{
int yylex();
void yyerror(char *s);

extern int tokenvalue;
extern int rowno;

#include <stdio.h>
#define prompt printf("\n%5d : ",++rowno)
%}

%start line
%token PLUS MINUS MULT DIV OPEN CLOSE NUM ENDOFLINE EMPTY

%%

line    :                                           /* leeres Symbol (Epsilon) */
        | expr {printf("%d",$1); prompt;} ENDOFLINE line
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
        | NUM { $$ = tokenvalue; }
        | MINUS NUM { $$ = -tokenvalue; }
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