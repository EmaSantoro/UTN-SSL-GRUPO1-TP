%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parserJuan.tab.h"


#define BYTES_RENGLON          bytes += strlen(yytext);
#define COLUMNAS_SUMA  BYTES_RENGLON columnas += strlen(yytext);
#define COLUMNAS_RESET columnas = 1;
#define LINEA_BYTES linea_en_bytes += bytes; bytes = 0;

void error_alfabeto();
void error_identificadores();
int columnas = 0;
int bytes = 0;
int linea_en_bytes = 0;


%}


/*SECCION DE OPCIONES*/
/* Esto indica a Flex que lea solo un fichero de entrada */
%option noyywrap
/* Nos permite obtener el numero de linea */
%option yylineno

/* Seccion Tokens */
NUM		           [0-9]+
Mayuscula	       [A-Z]+
Minuscula	       [a-z]+
palabra		       ({Minuscula}|{Mayuscula})+

COND    (==)

Asignacion (->)

Identificador       _[A-Za-z]*

FinDeSentencia 	    ["/"]

ent    "ent"
cad    "cad"
si     "si"


%%

{Identificador}           { if(strlen(yytext)<17) { COLUMNAS_SUMA; printf("IDENTIFICADOR: %s\n", yytext); return IDENTIFICADOR; } \
						    else { error_identificadores();} ;} 

{ent}		              { COLUMNAS_SUMA; printf("ENTERO: %s\n", yytext); return ENTERO; }
{cad}		              { COLUMNAS_SUMA; printf("CADENA: %s\n", yytext); return CADENA; }
{si}			          { COLUMNAS_SUMA; printf("SI: %s\n", yytext); return SI; } 

{palabra}				  { COLUMNAS_SUMA; printf("PALABRA: %s\n", yytext); return PALABRA; }

{NUM}					  { COLUMNAS_SUMA; printf("NUM: %s\n", yytext); return NUM; }

{COND}					  { COLUMNAS_SUMA; printf("COND: %s\n", yytext); return COND; }

{Asignacion}              { COLUMNAS_SUMA; printf("ASIGNACION: %s\n", yytext); return ASIGNACION; }

{FinDeSentencia}          { COLUMNAS_SUMA; printf("FINSENTENCIA: %s\n", yytext); return FINSENTENCIA; }

"\n"					  { COLUMNAS_SUMA; COLUMNAS_RESET; LINEA_BYTES; }

[ \t]				      { COLUMNAS_SUMA; }

"["		   		          { COLUMNAS_SUMA; printf("CORCHIZQ: %s\n", yytext); return CORCHIZQ; }
"]"						  { COLUMNAS_SUMA; printf("CORCHDER: %s\n", yytext); return CORCHDER; }

.		    		      { COLUMNAS_SUMA; error_alfabeto(); }

%%


void error_identificadores(){	
	printf("\"%s\" no puede ser usado como identificador \n", yytext); 
	printf("Recordar que los identificadores deben tener como maximo 16 caracteres y deben empezar con _\n");
	printf("\n");
 }

void error_alfabeto(){
	printf("\n");

	printf("Termino la lectura del archivo\n");
}
