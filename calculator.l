%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>

int rowno = 1;                          // Number of row

%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?

%%

[ \t]+  ;                               // Ignore blank space tab
\n      { return(ENDOFLINE); }          // Enter
{NUM}   { yylval.value = atof(yytext);
            return NUM; }
"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
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
[mM][eE][aA][nN]   { return(MEAN); }    // Mean of a list
[sS][uU][mM][lL]   { return(SUML); }    // Sum of a list
[pP][rR][oO][dD][uU][cC][tT][lL]    { return(PRODL); }    // Sum of a list
","     { return(COMMA); }              // Separate expressions
"("     { return(OPEN); }
")"     { return(CLOSE); }
"{"     { return(CURO); }
"}"     { return(CURC); }

[eE][xX][iI][tT]   { return(EXIT); }    // Exit
%%