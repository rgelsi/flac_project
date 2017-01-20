%{
int yylex();
void yyerror(char *s);

double ans = 0;

int counter = 0;

int rowno = 1;                          // Number of row

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <math.h>

#include "myFunctions.h"

#define e  2.71828182845904523536028747135266249775724709369995
#define pi 3.14159265358979323846264338327950288419716939937510

#define prompt printf("\n%3d : ",++rowno)
%}

%union {
    char* lexeme;
    double value;			//value of an identifier of type NUM
    int digit;              //value of an identifier of type DIGIT
}

%start line

%token <value> NUM
%token <digit> DIGIT

%left PLUS MINUS MULT DIV POW FACT MOD COMMA EXP EUL PI SQRT ABS GCD LCM MEAN SUML PRODL DIM ANS BIN DEC ARROW OPEN CLOSE CURO CURC SQBO SQBC ENDOFLINE EMPTY EXIT
%left COS SIN TAN SINH COSH TANH ASIN ACOS ATAN ATAN2 ASINH ACOSH ATANH CEIL FLOOR LN LOG10 CBRT HYPOT PER COMP BTD DTB NOT AND OR NAND NOR XOR
%right PROZENT

%type <value> expr
%type <value> term
%type <value> power
%type <value> factorial
%type <value> exponent
%type <value> percent
%type <value> final
%type <value> sumlist
%type <value> prodlist
%type <value> meanlist
%type <value> dimlist

%token <lexeme> ID

%%

line    : // Empty
        | expr {ans = $1; printf("%.11g",$1); prompt;} ENDOFLINE line
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

exponent: exponent EXP percent { $$ = $1 * pow( 10, $3 ); }
        | percent { $$ = $1; }
        ;

percent : percent PER { $$ = $1 / 100; }
        | final { $$ = $1; }
        ;

final   : MOD OPEN expr COMMA expr CLOSE { $$ = fmod( $3, $5 ); }
        | EUL POW OPEN expr CLOSE { $$ = pow( e, $4 ); }
        | SQRT OPEN expr CLOSE { $$ = sqrt( $3 ); }
        | ABS OPEN expr CLOSE { $$ = fabs( $3 ); }
        | GCD OPEN expr COMMA expr CLOSE { $$ = gcd( $3, $5 ); }
        | LCM OPEN expr COMMA expr CLOSE { $$ = lcm( $3, $5 ); }

        | SIN OPEN expr CLOSE { $$ = sin( $3 ); }
        | COS OPEN expr CLOSE { $$ = cos( $3 ); }
        | TAN OPEN expr CLOSE { $$ = tan( $3 ); }
        | SINH OPEN expr CLOSE { $$ = sinh( $3 ); }
        | COSH OPEN expr CLOSE { $$ = cosh( $3 ); }
        | TANH OPEN expr CLOSE { $$ = tanh( $3 ); }
        | ASIN OPEN expr CLOSE { $$ = asin( $3 ); }
        | ACOS OPEN expr CLOSE { $$ = acos( $3 ); }
        | ATAN OPEN expr CLOSE { $$ = atan( $3 ); }
        | ATAN2 OPEN expr COMMA expr CLOSE { $$ = atan2( $3, $5 ); }
        | ASINH OPEN expr CLOSE { $$ = asinh( $3 ); }
        | ACOSH OPEN expr CLOSE { $$ = acosh( $3 ); }
        | ATANH OPEN expr CLOSE { $$ = atanh( $3 ); }

        | CEIL OPEN expr CLOSE { $$ = ceil( $3 ); }
        | FLOOR OPEN expr CLOSE { $$ = floor( $3 ); }

        | LN OPEN expr CLOSE { $$ = log( $3 ); }
        | LOG10 OPEN expr CLOSE { $$ = log10( $3 ); }
        | CBRT OPEN expr CLOSE { $$ = cbrt( $3 ); }
        | HYPOT OPEN expr COMMA expr CLOSE { $$ = hypot( $3, $5 ); }
        | COMP OPEN expr COMMA expr CLOSE { $$ = comp( $3, $5 ); }
        
        | BTD OPEN expr CLOSE { $$ = binToDec( $3 ); }
        | DTB OPEN expr CLOSE { $$ = decToBin( $3 ); }

        | AND OPEN expr COMMA expr CLOSE { $$ = and( $3, $5 ); }
        | OR OPEN expr COMMA expr CLOSE { $$ = or( $3, $5 ); }
        | NAND OPEN expr COMMA expr CLOSE { $$ = nand( $3, $5 ); }
        | NOR OPEN expr COMMA expr CLOSE { $$ = nor( $3, $5 ); }
        | XOR OPEN expr COMMA expr CLOSE { $$ = xor( $3, $5 ); }
        | NOT OPEN expr CLOSE { $$ = not( $3 ); }

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
        | expr  { $$ = 1; }
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
 printf("%3d : ", rowno);
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