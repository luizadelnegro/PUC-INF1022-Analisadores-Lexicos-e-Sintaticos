%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>

  int yylex();
  void yyerror();
  extern int linha;
  extern FILE *yyin;
%}

%union {char *id;}
%token ENTRADA 
%token SAIDA 
%token FIM 
%token ENQUANTO 
%token FACA 
%token INC 
%token DEC 
%token ZERA
%token SE 
%token ENTAO
%token <id> ID 
%type <id> cmd cmds varlist 

%%

program:
  ENTRADA varlist SAIDA varlist cmds FIM {
    FILE *file = fopen("output.py", "w");
    if (file == NULL) exit(1); // error opening file
    char* codigo = malloc(strlen($2) + strlen($4) + strlen($5) + 15);
    strcpy(codigo, "def func(");
    strcat(codigo, $2);
    strcat(codigo, "):\n");
    strcat(codigo, "    ");
    strcat(codigo, $5);
    strcat(codigo, "    ");
    strcat(codigo, "return ");
    strcat(codigo, $4);
    strcat(codigo, "");
    fprintf(file, "%s", codigo);
    fclose(file);

    printf("codigo gerado, resultado em 'output.py'\n");

    exit(0);
  }
;

varlist:
  varlist ID {
    char* codigo = malloc(strlen($1) + strlen($2) + 1);
    strcpy(codigo, $1);
    strcat(codigo, $2);
    $$ = codigo;
  }
  | ID {$$ = $1;}
;



cmds:
  cmd cmds {
    char* codigo = malloc(strlen($1) + strlen($2) + 1);
    strcat(codigo, "    ");
    strcpy(codigo, $1);
    strcat(codigo, "    ");
    strcat(codigo, $2);
    $$ = codigo;
  }
  | cmd {$$ = $1;}
;

cmd:
  ENQUANTO ID FACA cmds FIM {
    char* codigo = malloc(strlen($2) + strlen($4) + 12); 
    strcpy(codigo, "while ");
    strcat(codigo, $2); 
    strcat(codigo, ": \n"); 
    strcat(codigo, "        ");
    strcat(codigo, $4); 
    $$ = codigo;
  }
  | ID '=' ID {
    char* codigo = malloc(strlen($1) + strlen($3) + 6); 
    strcpy(codigo, $1);
    strcat(codigo, " = "); 
    strcat(codigo, $3); 
    strcat(codigo, "\n"); 
    $$ = codigo;
  }
  | INC '(' ID ')' {
    char* codigo = malloc(strlen($3) + 5); 
    strcat(codigo, "    ");
    strcpy(codigo, $3);
    strcat(codigo, "+=1 \n"); 
    $$ = codigo;
  }
  | DEC '(' ID ')' {
    char* codigo = malloc(strlen($3) + 5); 
    strcpy(codigo, $3);
    strcat(codigo, "-=1 \n"); 
    $$ = codigo;
  }
  | ZERA '(' ID ')' {
    char* codigo = malloc(strlen($3) + 7); 
    strcpy(codigo, $3);
    strcat(codigo, " = 0\n"); 
    $$ = codigo;
  }
  | SE ID ENTAO cmds FIM{
        char* codigo = malloc(strlen($2) + strlen($4) + 12); 
        strcpy(codigo, "if ");
        strcat(codigo, $2); 
        strcat(codigo, ": \n"); 
        strcat(codigo, "        ");
        strcat(codigo, $4); 
        $$ = codigo;
  }
;

%%

void yyerror(){
  fprintf(stderr, "Syntax error at line %d\n", linha);
};  

int main (int argc, char** argv) {
  if (argc > 1) {
    yyin = fopen(argv[1], "r");
  }
  yyparse();
  if (argc > 1) {
    fclose(yyin);
  }

  return(0);
}