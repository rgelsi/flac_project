%{
int yylex();
void yyerror(char *s);

extern int rowno;
double ans = 0;

int counter = 0;

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

int gcd (int a, int b) {
  int c;
  while ( a != 0 ) {
     c = a;
     a = b%a;
     b = c;
  }
  return b;
}

int lcm(int a, int b) {
    return (a * b) / gcd(a, b);
}


#define e  2.71828182845904523536028747135266249775724709369995
#define pi 3.14159265358979323846264338327950288419716939937510

#define prompt printf("\n%5d : ",++rowno)
%}

%union {
    char* lexeme;
    double value;			//value of an identifier of type NUM
    int digit;              //value of an identifier of type DIGIT
}

%start line
%token <value> NUM
%token <digit> DIGIT
%left PLUS MINUS MULT DIV POW FACT MOD COMMA EXP EUL PI SQRT ABS COS SIN GCD LCM MEAN SUML PRODL DIM ANS BIN DEC ARROW OPEN CLOSE CURO CURC SQBO SQBC ENDOFLINE EMPTY EXIT
%right PROZENT
%type <value> expr
%type <value> term
%type <value> power
%type <value> factorial
%type <value> exponent
%type <value> final

%type <value> sumlist
%type <value> prodlist
%type <value> meanlist
%type <digit> dimlist

%%

line    : // Empty
        | expr {ans = $1; printf("%f",$1); prompt;} ENDOFLINE line
        ;

expr    : expr PLUS term PROZENT { $$ = $1 + $1 * $3 / 100; }
        | expr MINUS term PROZENT { $$ = $1 - $1 * $3 / 100; }
        | expr PLUS term { $$ = $1 + $3; }
        | expr MINUS term { $$ = $1 - $3; }
        | term { $$ = $1; }
        ;

term    : term MULT power { $$ = $1 * $3; }
        | term DIV power { $$ = $1 / $3; }
        | term MULT power PROZENT { $$ = ($1 * $3) / 100; }
        | term DIV power PROZENT { $$ = $1 / ($3 / 100); }
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
        | GCD OPEN expr COMMA expr CLOSE { $$ = gcd( $3, $5 ); }
        | LCM OPEN expr COMMA expr CLOSE { $$ = lcm( $3, $5 ); }

        | SUML OPEN CURO sumlist CURC CLOSE { $$ = $4 ; }
        | PRODL OPEN CURO prodlist CURC CLOSE { $$ = $4 ; }
        | MEAN OPEN CURO meanlist CURC CLOSE { $$ = $4 / counter ; counter = 0; }
        | DIM OPEN CURO dimlist CURC CLOSE { $$ = $4 ; }

        | OPEN expr CLOSE { $$ = $2; }
        | PI { $$ = pi; }
        | NUM { $$ = $1; }
        | MINUS NUM { $$ = -$2; }
        | ANS { $$ = ans; }

        | EXIT { exit(0); }
        ;

sumlist : expr COMMA sumlist { $$ = $1 + $3; }
        | expr  { $$ = $1; }
        | { $$ = 0; }
        ;

prodlist: expr COMMA prodlist { $$ = $1 * $3; }
        | expr  { $$ = $1; }
        | { $$ = 0; }
        ;

meanlist: expr COMMA meanlist { counter++; $$ = $1 + $3; }
        | expr  { counter++; $$ = $1; }
        | { $$ = 0; }
        ;

dimlist : expr COMMA dimlist {  $$ = 1 + $3; }
        | expr  { counter++; $$ = 1; }
        | { $$ = 0; }
        ;

%%

#include "lex.yy.c"

void yyerror(char *s)
{
    printf("%s", s);
    prompt;
    yyparse();
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