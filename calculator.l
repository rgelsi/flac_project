%option noyywrap
%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>

int rowno = 1;              /* Programmglob. Variable: */
                            /* enthaelt immer Nummer der akt. Eingabezeile */

double fac(double x) {
    if(x==0){
        return (double) 1;
    }else{
        return (x*fac(x-1));
    }
}

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
"^"     { return(POW); }
"!"     { return(FACT); }
"("     { return(OPEN); }
")"     { return(CLOSE); }
%%