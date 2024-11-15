%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"


#define BYTES_RENGLON          bytes += strlen(yytext);
#define COLUMNAS_SUMA  BYTES_RENGLON columnas += strlen(yytext);
#define COLUMNAS_RESET columnas = 1;
#define LINEA_BYTES linea_en_bytes += bytes; bytes = 0;

void error_alfabeto();
void error_identificadores();
void punto();
int columnas = 0;
int bytes = 0;
int linea_en_bytes = 0;


%}


%option noyywrap
%option yylineno

/* Seccion Tokens */
NUM		           [0-9]+
Mayuscula	       [A-Z]+
Minuscula	       [a-z]+
palabra		       ({Minuscula}|{Mayuscula})+

COND    (==)

IdentificadorCad       _[A-Za-z]*
IdentificadorEnt        E[0-9]*

FinDeSentencia 	    ["/"]

ent         "ent"
cad         "cad"
si          "si"
show        "show"
concat      "concat"


%%

{IdentificadorCad}			  { if(strlen(yytext)<17) { COLUMNAS_SUMA; printf("IDENTIFICADORCAD: %s\n", yytext); return IDENTIFICADORCAD; } \
						    else { error_identificadores();} ;}
{IdentificadorEnt}			  { if(strlen(yytext)<17) { COLUMNAS_SUMA; printf("IDENTIFICADORENT: %s\n", yytext); return IDENTIFICADORENT; } \
						    else { error_identificadores();} ;}  

{ent}		              { COLUMNAS_SUMA; printf("ENTERO: %s\n", yytext); return ENTERO; }
{cad}		              { COLUMNAS_SUMA; printf("CADENA: %s\n", yytext); return CADENA; }
{si}			          { COLUMNAS_SUMA; printf("SI: %s\n", yytext); return SI; } 
{show}                    { COLUMNAS_SUMA; printf("SHOW: %s\n", yytext); return SHOW; } 
{concat}                  { COLUMNAS_SUMA; printf("CONCAT: %s\n", yytext); return CONCAT; } 

{palabra}				  { COLUMNAS_SUMA; printf("PALABRA: %s\n", yytext); return PALABRA; }

{NUM}					  { COLUMNAS_SUMA; printf("NUM: %s\n", yytext); return NUM; }

{COND}					  { COLUMNAS_SUMA; printf("COND: %s\n", yytext); return COND; }

{FinDeSentencia}          { COLUMNAS_SUMA; printf("FINSENTENCIA: %s\n", yytext); return FINSENTENCIA; }

->						  { COLUMNAS_SUMA; printf("ASIGNACION: %s\n", yytext); return ASIGNACION; }

"\n"					  { COLUMNAS_SUMA; COLUMNAS_RESET; LINEA_BYTES; }

[ \t]				      { COLUMNAS_SUMA; }

"["		   		          { COLUMNAS_SUMA; printf("CORCHIZQ: %s\n", yytext); return CORCHIZQ; }
"]"						  { COLUMNAS_SUMA; printf("CORCHDER: %s\n", yytext); return CORCHDER; }


"."						  { COLUMNAS_SUMA; punto(); }
.						  { COLUMNAS_SUMA; error_alfabeto(); }

%%


void error_identificadores(){	
	printf("\"%s\" no puede ser usado como identificador \n", yytext); 
	printf("Los identificadores tienen que tener como maximo 16 caracteres y deben empezar con _ si es cadena o E si es entero\n");
	printf("\n");
	exit(1);
 }

void error_alfabeto(){
	printf("\n");
    printf("\"%s\" no es parte del alfabeto del lenguaje \n", yytext); 
    exit(1);
}

void punto(){
    printf("\n");
	printf("Termino la lectura del archivo correctamente\n");
    exit(1);
}