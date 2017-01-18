%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>

int tokenvalue = EMPTY;     /* Programmglobale Variable, der im Falle */
                            /* einer Zahl Zahlenwert zugewiesen wird. */
int rowno = 1;              /* Programmglob. Variable: */
                            /* enthaelt immer Nummer der akt. Eingabezeile */
%}
%%

[ \t]+  ;                   /* Leer- und Tabzeichen ueberlesen */
\n      { return(ENDOFLINE); }
[0-9]+  { tokenvalue = strtol(yytext,NULL,10); return(NUM); }
"+"     { return(PLUS); }
"-"     { return(MINUS); }
"*"     { return(MULT); }
"/"     { return(DIV); }
"^"     { return(POW); }
"("     { return(OPEN); }
")"     { return(CLOSE); }
.       { tokenvalue = yytext[0]; return(EMPTY); }
%%