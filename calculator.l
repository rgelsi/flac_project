%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>

%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?

LIST    \{({NUM}+(\,{NUM})*)?\}

%%

[ \t]+  ;                                   // Ignore blank space tab
\n      { return(ENDOFLINE); }              // Enter

{NUM}   { yylval.value = atof(yytext);
            return NUM; }

"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
"^"     { return(POW); }                    // Power
"!"     { return(FACT); }                   // Factorial
"%"     { return(PER); }                    // Percent
"E"     { return(EXP); }                    // E notation
"e"     { return(EUL); }                    // Constant e
[pP][iI]        { return(PI); }             // Constant PI
[mM][oO][dD]    { return(MOD); }            // Modulo
[sS][qQ][rR][tT]   { return(SQRT); }        // Square root
[cC][bB][rR][tT]   { return(CBRT); }        // Cubic root
[hH][yY][pP][oO][tT]   { return(HYPOT); }
[aA][bB][sS]   { return(ABS); }             // Absolute value
[iI][nN][tT][dD][iI][vV]   { return(INTDIV); }             // Absolute value

[gG][cC][dD]   { return(GCD); }             // GCD
[lL][cC][mM]   { return(LCM); }             // LCM

[lL][nN]   { return (LN); }                 // Natural logarithm
[lL][oO][gG]10   { return(LOG10); }         // Log base 10

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

[cC][eE][iI][lL][iI][nN][gG] { return(CEIL); }  // Ceiling
[fF][lL][oO][oO][rR] { return(FLOOR); }         // Floor

[rR][aA][nN][dD]   { return(RAND); }            // Dimension of a list

[cC][oO][mM][pP] { return (COMP); }             // Compare two numbers

[mM][eE][aA][nN]   { return(MEAN); }                        // Mean of a list
[vV][aA][rR][iI][aA][nN][cC][eE]   { return(VARIANCE); }    // Variance of a list
[sS][dD]   { return(SD); }                                  // Standard Deviation of a list
[sS][uU][mM]   { return(SUM); }                             // Sum of a list
[pP][rR][oO][dD][uU][cC][tT]    { return(PROD); }           // Sum of a list
[dD][iI][mM]   { return(DIM); }                             // Dimension of a list
[dD][oO][tT][pP]   { return(DOTP); }                        // Dot product of a list
[mM][aA][xX]   { return(MAX); }                             // The maximum element in a list
[mM][iI][nN]   { return(MIN); }                             // The minimum element in a list
[pP][oO][lL][yY][eE][vV][aA][lL]   { return(POLYEVAL); }    // The polynomial evaluated for the value of the second argument

[bB][iI][nN][tT][oO][dD][eE][cC]  { return (BTD); }     // Binary to Dezimal
[dD][eE][cC][tT][oO][bB][iI][nN]  { return (DTB); }     // Dezimal to Binary

[nN][oO][tT]    { return (NOT); }
[aA][nN][dD]    { return (AND); }
[oO][rR]    { return (OR); }
[nN][aA][nN][dD]    { return (NAND); }
[nN][oO][rR]    { return (NOR); }
[xX][oO][rR]    { return (XOR); }

[aA][nN][sS]   { return(ANS); }             // Previous result

","     { return(COMMA); }                  // Separate expressions
"("     { return(OPEN); }
")"     { return(CLOSE); }
"{"     { return(CURO); }
"}"     { return(CURC); }
"["     { return(SQBO); }
"]"     { return(SQBC); }
"->"    { return(ARROW); }


[eE][xX][iI][tT]   { return(EXIT); }    // Exit

. return yytext[0];
%%