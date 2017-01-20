%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>

int rowno = 1;                          // Number of row

%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?

LIST    \{({NUM}+(\,{NUM})*)?\}

%%

[ \t]+  ;                               // Ignore blank space tab
\n      { return(ENDOFLINE); }          // Enter
{NUM}   { yylval.value = atof(yytext);
            return NUM; }
"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
"%"     { return(PROZENT); }            // Prozent
"^"     { return(POW); }                // Power
"!"     { return(FACT); }               // Factorial
"E"     { return(EXP); }                // E notation
"e"     { return(EUL); }                // Constant e
[pP][iI]        { return(PI); }         // Constant PI
[mM][oO][dD]    { return(MOD); }        // Modulo
[sS][qQ][rR][tT]   { return(SQRT); }    // Square root
[aA][bB][sS]   { return(ABS); }         // Absolute value
[cC][oO][sS]   { return(COS); }         // Cosinus
[sS][iI][nN]   { return(SIN); }         // Sinus
[gG][cC][dD]   { return(GCD); }         // GCD
[lL][cC][mM]   { return(LCM); }         // LCM
[mM][eE][aA][nN]   { return(MEAN); }    // Mean of a list
[sS][uU][mM][lL]   { return(SUML); }    // Sum of a list
[pP][rR][oO][dD][uU][cC][tT][lL]    { return(PRODL); }    // Sum of a list
[dD][iI][mM]   { return(DIM); }         // Dimension of a list
[bB][iI][nN]   { return(BIN); }         // Binary
[dD][eE][cC]   { return(DEC); }         // Dezimal
[aA][nN][sS]   { return(ANS); }         // Answer
","     { return(COMMA); }              // Separate expressions
"("     { return(OPEN); }
")"     { return(CLOSE); }
"{"     { return(CURO); }
"}"     { return(CURC); }
"["     { return(SQBO); }
"]"     { return(SQBC); }
"->"    { return(ARROW); }


[eE][xX][iI][tT]   { return(EXIT); }    // Exit
%%