%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

int tokenwert = NICHTS;     /*Programmglob. Var., der im Falle */
                            /* einer Zahl Zahlenwert zugew. Wird */
int zeilennr = 1;           /* Programmg. Variable: enthaelt immer */
                            /* Nummer der aktuellen Eingabezeile */
%}
%%

[ \t]+  ;                   /* Leer- und Tabzeichen ueberlesen */
\n      { return(ZEILENENDE); }
[0-9]+  { tokenwert = strtol(yytext,NULL,10); return(ZAHL); }
"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
"("     { return(AUF); }
")"     { return(ZU); }
.       { tokenwert = yytext[0]; return(NICHTS); }
%%