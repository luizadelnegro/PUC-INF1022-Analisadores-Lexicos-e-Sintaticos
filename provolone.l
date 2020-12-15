%{
  #include <stdio.h>
  #include <string.h>
  #include "provolone.tab.h"

  int linha = 1;
%}

%%

ENTRADA     { return (ENTRADA); }
SAIDA       { return (SAIDA); }
FIM         { return (FIM); }
ENQUANTO    { return (ENQUANTO); }
FACA        { return (FACA); }
VEZES        { return (VEZES); }
INC         { return (INC); }
DEC         { return (DEC); }
ZERA        { return (ZERA); }
SE          { return (SE); }
ENTAO       { return (ENTAO); }
SENAO       { return (SENAO); }
[=()]       { return yytext[0]; }
[_a-zA-Z][_a-zA-Z0-9]*       { 
    yylval.id=strdup(yytext); 
    return (ID); 
    }
[\n]        { linha++; }
.           ;

%%
