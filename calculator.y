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

#define e  2.71828182845904523536028747135266249775724709369995
#define pi 3.14159265358979323846264338327950288419716939937510

#define prompt printf("\n%5d : ",++rowno)
%}

%union {
    double value;			//value of an identifier of type NUM
    int digit;              //value of an identifier of type DIGIT
}

%start line
%token <value> NUM
%token <digit> DIGIT
%token PLUS MINUS MULT DIV POW FACT MOD COMMA EXP EUL PI SQRT ABS COS SIN MEAN SUML PRODL OPEN CLOSE CURO CURC ENDOFLINE EMPTY EXIT
%type <value> expr
%type <value> term
%type <value> power
%type <value> factorial
%type <value> exponent
%type <value> final

%type <value> sumlist
%type <value> prodlist

%%

line    : // Empty
        | expr {printf("%f",$1); prompt;} ENDOFLINE line
        ;

expr    : expr PLUS term { $$ = $1 + $3; }
        | expr MINUS term { $$ = $1 - $3; }
        | term { $$ = $1; }
        ;

term    : term MULT power { $$ = $1 * $3; }
        | term DIV power { $$ = $1 / $3; }
        | power { $$ = $1; }
        ;

power   : power POW factorial { $$ = pow( $1, $3 ); }
        | factorial { $$ = $1; }
        ;

factorial   : factorial FACT { $$ = fac($1); }
            | exponent { $$ = $1; }
            ;

exponent: exponent EXP final { $$ = $1 * pow( 10, $3 ); }
        | final { $$ = $1; }
        ;

final   : MOD OPEN expr COMMA expr CLOSE { $$ = fmod( $3, $5 ); }
        | EUL POW OPEN expr CLOSE { $$ = pow( e, $4 ); }
        | SQRT OPEN expr CLOSE { $$ = sqrt( $3 ); }
        | ABS OPEN expr CLOSE { $$ = fabs( $3 ); }
        | COS OPEN expr CLOSE { $$ = cos( $3 ); }
        | SIN OPEN expr CLOSE { $$ = sin( $3 ); }
        | SUML OPEN CURO sumlist CURC CLOSE { $$ = $4 ; }
        | PRODL OPEN CURO prodlist CURC CLOSE { $$ = $4 ; }
        | OPEN expr CLOSE { $$ = $2; }
        | PI { $$ = pi; }
        | NUM { $$ = $1; }
        | MINUS NUM { $$ = -$2; }
        | EXIT { exit(0); }
        ;

sumlist : expr COMMA sumlist { $$ = $1 + $3; }
        | expr  { $$ = $1; }
        ;

prodlist: expr COMMA prodlist { $$ = $1 * $3; }
        | expr  { $$ = $1; }
        ;


%%

#include "lex.yy.c"

void yyerror(char *s)
{
    printf("%s\n", s);
}

int main(void)
{
 printf("%5d : ", rowno);
 yyparse();
 return(0);
}

// Debug
/*main()
{
  extern int yydebug;
  yydebug = 1;
  return yyparse();
}*/