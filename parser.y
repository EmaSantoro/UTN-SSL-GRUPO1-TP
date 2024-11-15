

%{

#include <string.h>
#include <stdio.h>

extern FILE * yyin;
extern int yylineno;
extern int yylex();
extern int columnas;
extern int linea_en_bytes;

#define YYERROR_VERBOSE 1

void yyerror(const char *s);

%}

/* declare tokens */

%token CADENA ENTERO SHOW CONCAT
%token IDENTIFICADORCAD 
%token IDENTIFICADORENT
%token FINSENTENCIA
%token SENTENCIA
%token COND 
%token ASIGNACION
%token PALABRA 
%token NUM
%token ERROR


%%

sentencias: sentencia
		  | sentencia sentencias;

sentencia: sentencia_inicio FINSENTENCIA;

sentencia_inicio: asignacion
                | show
                | concatenar	
				| crear_variable;

asignacion: identificador ASIGNACION operador;

show: SHOW operador;

concatenar: PALABRA CONCAT PALABRA

crear_variable: tipo identificador;
			  
operador: PALABRA 
		| NUM;

tipo: CADENA
	| ENTERO;

identificador: IDENTIFICADORENT | IDENTIFICADORCAD;

%%


int main(int argc, char **argv)

{
	yyin = fopen(argv[1], "r");
	yylex();
	yyparse();
	fclose(yyin);
}

void yyerror(const char *s)
{
	
	printf("\n");
	printf("Error in line: %d \n", yylineno);

	printf("\n");
	fprintf(stderr, "%s:\n", s);
	
	char* buffer = malloc(100);
	fseek(yyin, linea_en_bytes, SEEK_SET);
		
	int tamanio; 
	fgets(buffer, 100, yyin);

	printf("\n");
	printf("  %s", buffer);
	printf("  ");

	for(int i=0; i<columnas-2; i++){
		printf("_");
	}
		printf("^ \n");

	printf("\n");
}
