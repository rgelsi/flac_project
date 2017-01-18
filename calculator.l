%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

int tokenvalue = EMPTY;     /*Programmglob. Var., der im Falle */
                            /* einer Zahl Zahlenwert CLOSEgew. Wird */
int rowno = 1;           /* Programmg. Variable: enthaelt immer */
                            /* Nummer der aktuellen Eingabezeile */
%}
%%

[ \t]+  ;                   /* Leer- und Tabzeichen ueberlesen */
\n      { return(ENDOFLINE); }
[0-9]+  { tokenvalue = strtol(yytext,NULL,10); return(NUM); }
"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
"("     { return(OPEN); }
")"     { return(CLOSE); }
.       { tokenvalue = yytext[0]; return(EMPTY); }
%%