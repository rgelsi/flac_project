%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>

int rowno = 1;              /* Programmglob. Variable: */
                            /* enthaelt immer Nummer der akt. Eingabezeile */
%}

DIGIT    [0-9]
NUM      {DIGIT}+(\.{DIGIT}+)?

%%

[ \t]+  ;                   /* Leer- und Tabzeichen ueberlesen */
\n      { return(ENDOFLINE); }
{NUM}   { yylval.value = atof(yytext);
            return NUM; }
"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
"("     { return(OPEN); }
")"     { return(CLOSE); }
%%