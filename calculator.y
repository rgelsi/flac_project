%{
int yylex();
void yyerror(char *s);

extern int rowno;

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <math.h>

double fac(double x) {
    if(x==0){
        return (double) 1;
    }else{
        return (x*fac(x-1));
    }
}

#define prompt printf("\n%5d : ",++rowno)
%}

%union {
    double value;			//value of an identifier of type NUM
    int digit;
}

%start line
%token <value> NUM
%token <digit> DIGIT
%token PLUS MINUS MULT DIV POW FACT MOD COMMA EXP OPEN CLOSE ENDOFLINE EMPTY
%type <value> expr
%type <value> term
%type <value> factor
%type <value> factorial
%type <value> exponent
%type <value> final

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

factor  : factor POW factorial { $$ = pow( $1, $3 ); }
        | factorial { $$ = $1; }
        ;

factorial   : factorial FACT { $$ = fac($1); }
            | exponent { $$ = $1; }
            ;

exponent: exponent EXP final { $$ = $1 * pow( 10, $3 ); }
        | final { $$ = $1; }
        ;

final   : MOD OPEN expr COMMA expr CLOSE { $$ = fmod( $3, $5 ); }
        | OPEN expr CLOSE { $$ = $2; }
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