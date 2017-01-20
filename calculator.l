%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>

%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?

LIST    \{({NUM}+(\,{NUM})*)?\}

LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT})*

%%

[ \t]+  ;                                   // Ignore blank space tab
\n      { return(ENDOFLINE); }              // Enter

{NUM}   { yylval.value = atof(yytext);
            return NUM; }

"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
"%"     { return(PER); }                    // Percent
"^"     { return(POW); }                    // Power
"!"     { return(FACT); }                   // Factorial
"E"     { return(EXP); }                    // E notation
"e"     { return(EUL); }                    // Constant e
[pP][iI]        { return(PI); }             // Constant PI
[mM][oO][dD]    { return(MOD); }            // Modulo
[sS][qQ][rR][tT]   { return(SQRT); }        // Square root
[aA][bB][sS]   { return(ABS); }             // Absolute value

[sS][iI][nN]   { return(SIN); }             // Sinus
[cC][oO][sS]   { return(COS); }             // Cosinus
[tT][aA][nN]   { return(TAN); }             // Tangent
[sS][iI][nN][hH]   { return(SINH); }
[cC][oO][sS][hH]   { return(COSH); }
[tT][aA][nN][hH]   { return(TANH); }
[aA][sS][iI][nN]   { return(ASIN); }
[aA][cC][oO][sS]   { return(ACOS); }
[aA][tT][aA][nN]   { return(ATAN); }
[aA][tT][aA][nN]2   { return(ATAN2); }
[aA][sS][iI][nN][hH]   { return(ASINH); }
[aA][cC][oO][sS][hH]   { return(ACOSH); }
[aA][tT][aA][nN][hH]   { return(ATANH); }

[cC][eE][iI][lL] { return(CEIL); }          // Ceil
[fF][lL][oO][oO][rR] { return(FLOOR); }     // Floor

[lL][nN]   { return (LN); }                 // Natural logarithm
[lL][oO][gG]10   { return(LOG10); }         // Log base 10

[cC][bB][rR][tT]   { return(CBRT); }
[hH][yY][pP][oO][tT]   { return(HYPOT); }

[cC][oO][mM][pP] { return (COMP); }

[bB][iI][nN][tT][oO][dD][eE][cC]  { return (BTD); }     // Binary to Dezimal
[dD][eE][cC][tT][oO][bB][iI][nN]  { return (DTB); }     // Dezimal to Binary

[nN][oO][tT]    { return (NOT); }
[aA][nN][dD]    { return (AND); }
[oO][rR]    { return (OR); }
[nN][aA][nN][dD]    { return (AND); }
[nN][oO][rR]    { return (NOR); }
[xX][oO][rR]    { return (XOR); }

[gG][cC][dD]   { return(GCD); }             // GCD
[lL][cC][mM]   { return(LCM); }             // LCM
[mM][eE][aA][nN]   { return(MEAN); }        // Mean of a list
[sS][uU][mM][lL]   { return(SUML); }        // Sum of a list
[pP][rR][oO][dD][uU][cC][tT][lL]    { return(PRODL); }    // Sum of a list
[dD][iI][mM]   { return(DIM); }             // Dimension of a list

[aA][nN][sS]   { return(ANS); }             // Answer

","     { return(COMMA); }                  // Separate expressions
"("     { return(OPEN); }
")"     { return(CLOSE); }
"{"     { return(CURO); }
"}"     { return(CURC); }
"["     { return(SQBO); }
"]"     { return(SQBC); }
"->"    { return(ARROW); }


[eE][xX][iI][tT]   { return(EXIT); }    // Exit

{ID}     {yylval.lexeme = strdup(yytext);
          return ID;}

. return yytext[0];
%%