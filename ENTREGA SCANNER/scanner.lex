/* 
 * Sample Scanner1: 
 * Description: Replace the string "username" from standard input 
 *              with the user's login name (e.g. lgao)
 * Usage: (1) $ flex sample1.lex
 *        (2) $ gcc lex.yy.c -lfl
 *        (3) $ ./a.out
 *            stdin> username
 *	      stdin> Ctrl-D
 * Question: What is the purpose of '%{' and '%}'?
 *           What else could be included in this section?
 */


%%
cad|s(how|i)|ent {printf("PALABRA RESERVADA: %s\n", yytext);}

_[a-zA-Z]{1,15} {printf("\nIDENTIFICADOR: %s\n", yytext);}

E[0-9]{1,16} {printf("IDENTIFICADOR: %s\n", yytext);}

-> {printf("OPERADOR: %s\n", yytext);}

"\["|"\]"|"\/" {printf("SIGNO PUNTUACION: %s\n", yytext);}

[0-9]{2,16} {printf("ENTERO: %s\n", yytext);}

([a-z]|[A-Z]){2,16} {printf("CADENA: %s\n", yytext);}

[a-zA-Z]|[0-9] {printf("CARACTER: %s\n", yytext);}


%%
int main(int argc, char **argv)
{
    yylex();
}

int yywrap(){}


