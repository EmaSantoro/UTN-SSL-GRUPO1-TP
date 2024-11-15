
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

%token CADENA ENTERO SI
%token IDENTIFICADOR
%token FINSENTENCIA
%token SENTENCIA
%token COND ASIGNACION
%token PALABRA NUM
%token ERROR
%token CORCHIZQ CORCHDER

%%

sentencias: sentencia
		  | sentencia sentencias;

sentencia: sentencia_inicio FINSENTENCIA;

sentencia_inicio: condicional
				| asignacion	
				| crear_variable;

condicional: SI condicion CORCHIZQ sentencias CORCHDER;

asignacion: IDENTIFICADOR ASIGNACION operador;

crear_variable: tipo IDENTIFICADOR
		      | tipo asignacion; 

condicion: operador COND operador;

operador: IDENTIFICADOR
	    | PALABRA 
		| NUM;

tipo: CADENA
	| ENTERO;

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
