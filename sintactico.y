%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int Dibujar=0, Recursion=0,MaxRecursion;
char *Lexema[100], *Token[100];
int SubIndice=0, SubIndiceMax, NumLineas=1, EstadoScanner=0;
%}
%token AND CPAR APAR COMA ASTERISCO YIEL RETU CONST ASSCS NL
%%
/*stmt: CONST_NAME NL  {printf("La cadena ingresa es aceptada \n");}*/
/* los subtipos */
CONST_NAME 	: RETU NL {Valido();DibujarTodo(1);yyparse();}
		| RETU APAR CALL_ARGS CPAR NL {Valido();DibujarTodo(2);yyparse();}
                | RETU APAR RETU COMA YIEL CPAR NL {Valido();DibujarTodo();yyparse();}
                | RETU APAR RETU CPAR NL {Valido();DibujarTodo();yyparse();}
                | RETU APAR RETU COMA ASSOCS COMA ASTERISCO RETU CPAR NL {Valido();DibujarTodo(3);yyparse();}
                | YIEL NL {Valido();DibujarTodo(4);yyparse();}
                | YIEL APAR RETU CPAR NL {Valido();DibujarTodo();yyparse();}
		| RETU YIEL NL {Valido();DibujarTodo(5);yyparse();}
		| RETU YIEL APAR CALL_ARGS CPAR NL {Valido();DibujarTodo(6);yyparse();}
                | CONST
		;


/* listado de errores */
| NL {	
	printf("Ingrese una cadena para analizar\n");
	yyparse();
	}
|RETU APAR CPAR NL {	
	printf("ERROR: Se esperaba el terminal 'const' entre los parentesis\n");
	yyparse();
	}
|RETU APAR YIEL CPAR NL {	
	printf("ERROR: Se esperaba el terminal 'const' entre los parentesis\n");
	yyparse();
	}
|YIEL APAR RETU COMA CONST_NAME CPAR NL {	
	printf("ERROR: Sentencia no valida\n");
	yyparse();
	}
|RETU APAR CONST_NAME NL {	
	printf("ERROR: Se esperaba el terminal ')' al final de la sentencia\n");
	yyparse();
	}
|RETU YIEL CPAR NL {	
	printf("ERROR: No se esperaba el terminal ')' al final de la sentencia\n");
	yyparse();
	}
| YIEL APAR CONST_NAME CPAR NL {
      printf("ERROR: Se esperaba el terminal 'return' al principio de la sentencia\n");
	yyparse();
	}
|RETU YIEL CONST_NAME NL {	
	printf("ERROR: Se esperaban los terminales '(' y ')' para el terminal const\n");
	yyparse();
	}
| RETU APAR RETU COMA CPAR NL {	
	printf("ERROR: Se esperaba el terminal 'yield' despues de la coma\n");
	yyparse();
	}
| error NL {
	printf("ERROR: Ingrese otra cadena para analizar\n");
	yyerrok;
	yyparse();
	}
CALL_ARGS	: ARGS 
		| ARGS COMA ASSOCS 
		| ARGS COMA ASTERISCO CONST_NAME 
		| ARGS COMA AND CONST_NAME 
		| ARGS COMA ASSOCS COMA ASTERISCO CONST_NAME 
		| ARGS COMA ASSOCS COMA AND CONST_NAME 
		| ARGS COMA ASTERISCO CONST_NAME COMA AND CONST_NAME 
		| ARGS COMA ASSOCS COMA ASTERISCO CONST_NAME COMA AND CONST_NAME 
		;
/* los que terminan en expresiones simples */
ASSOCS		: ASSCS
		;
ARGS		: CONST_NAME 
		| CONST_NAME LOOP 
		;
LOOP		: COMA CONST_NAME 
		|
		;

%%
extern FILE *yyin;
int main(argc, argv)
int argc;
char **argv;
{
	FILE *ArchEnt;
	if (argc == 2)
	{
		ArchEnt=fopen(argv[1], "r");
		if (!ArchEnt) {
			fprintf(stderr, "No se encuentra el archivo %s\n", argv[1]);
			exit(1);
		}
		yyin=ArchEnt;
		EstadoScanner=1;
	}
	printf("Ingrese cadena a analizar\n");
	return yyparse();
}
yyerror(char* s) {
	 /*printf("%s",s);*/
         getchar();
	
}

/* La llamada a la accion principal */

int Valido(){
	printf("La cadena ingresada es correcta\n");
	return 0;
}
/* La llamada a la finalizacion del analizador */
int yywrap() {
	EstadoScanner=2;
	printf("El analisis ha concluido\n");
	return 1;
}
int DibujarTodo(int SubParam){
	DibujarTablaDeTokens();
	DibujarArbol(SubParam);
	return 0;
}


int DibujarTablaDeTokens(){
	int ContAuxT,ContAuxK;
	int LargoToken,LargoIzq,LargoDer;

	printf("\n===============================TABLA DE SIMBOLOS===============================\n");
	printf("|                LEXEMAS               |                 TOKENS               |\n");
	printf("---------------------------------------+---------------------------------------\n");

	for (ContAuxK=0;ContAuxK<SubIndiceMax;ContAuxK++){
		LargoToken=38-strlen(Lexema[ContAuxK]);
		
		if ((LargoToken & 1)==0){
			LargoIzq=LargoToken/2;
		}else{
			LargoIzq=(LargoToken+1)/2;
		}
		LargoDer=LargoToken-LargoIzq;
		printf("|");
		for (ContAuxT=0;ContAuxT<LargoIzq;ContAuxT++){
			printf(" ");
		}
		printf("%s",Lexema[ContAuxK]);
		for (ContAuxT=0;ContAuxT<LargoDer;ContAuxT++){
			printf(" ");
		}
		printf("|");
	
		LargoToken=38-strlen(Token[ContAuxK]);
		if ((LargoToken & 1)==0){
			LargoIzq=LargoToken/2;
		}else{
			LargoIzq=(LargoToken+1)/2;
		}
		LargoDer=LargoToken-LargoIzq;
		for (ContAuxT=0;ContAuxT<LargoIzq;ContAuxT++){
			printf(" ");
		}
		printf("%s",Token[ContAuxK]);
		for (ContAuxT=0;ContAuxT<LargoDer;ContAuxT++){
			printf(" ");
		}
		printf("|\n");
	}
	printf("===============================================================================\n\n\n");
	return 0;
}
int DibujarArbol(int SubTipo){



	switch (SubTipo){
                  case 1:  
                  printf("                              ----------  ARBOL DE DERIVACIONES ----------\n\n");
                  printf("                                                  CONST_NAME\n");
                  printf("                                                       |\n");
                  printf("                                          ----------------------\n");
                  printf("                                                       |\n"); 
                  printf("                                                     RETU\n");
                  printf("                                                       |\n");
                  printf("                                                     return \n");

               break;
                 case 2:  
                  printf("                              ----------  ARBOL DE DERIVACIONES ----------\n\n");
                  printf("                                                  CONST_NAME\n");
                  printf("                                                       |\n");
                  printf("                  --------------------------------------------------------------------------\n");
                  printf("                     |                                 |                     |        |\n"); 
                  printf("                    RETU                              APAR               CALL_ARGS   CPAR\n");
                  printf("                     |                                 |                     |        |\n");
                  printf("                     |                                 |                    ARGS      |\n");
                  printf("                     |                                 |                     |        |\n");
                  printf("                     |                                 |                 CONST_NAME   |\n");
                  printf("                     |                                 |                     |        |\n");
                  printf("                  return                               (                    const     )\n\n");
               break;
                 case 3:
            printf("                                          ------ARBOL DE DERIVACIONES-----\n\n");
            printf("                                                  CONST_NAME\n");
            printf("                                                       |\n");
            printf("                 -----------------------------------------------------------------------------------------------\n");
            printf("                     |                                 |              |                                     |\n"); 
            printf("                    RETU                             APAR          CALL_ARGS                               CPAR \n");
            printf("                     |                                 |              |                                     |\n");
            printf("                     |                                 |             ARGS                                   |\n");
            printf("                     |                                 |              |                                     |\n");
            printf("                     |                                 |     ----------------------------------------       | \n");
            printf("                     |                                 |        |     |    |     |    |           |         | \n");
            printf("                     |                                 |      ARGS  COMA ASSOCS COMA ASTERISCO CONST_NAME   | \n");
            printf("                     |                                 |         |     |    |     |    |           |        | \n");
            printf("                     |                                 |    CONST_NAME |    |     |    |           |        | \n");
            printf("                     |                                 |         |     |    |     |    |           |        | \n");
            printf("                return                                 (      return   ,  asscs   ,    *        return      ) \n");

            break;
                case 4:  
                  printf("                              ----------  ARBOL DE DERIVACIONES ----------\n\n");
                  printf("                                                  CONST_NAME\n");
                  printf("                                                       |\n");
                  printf("                                            ----------------------\n");
                  printf("                                                       |\n"); 
                  printf("                                                      YIEL\n");
                  printf("                                                       |\n");
                  printf("                                                     yield\n");                     
                break;
               case 5:
                   
                  printf("                              ----------  ARBOL DE DERIVACIONES ----------\n\n");
                  printf("                                                  CONST_NAME\n");
                  printf("                                                       |\n");
                  printf("                     --------------------------------------------------------\n");
                  printf("                     |                                 |\n"); 
                  printf("                    RETU                               YIEL\n");
                  printf("                     |                                 |\n");
                  printf("                   return                              yield\n");
               break;         
               case 6:   
            printf("                                          ------ARBOL DE DERIVACIONES-----\n\n");
            printf("                                                  CONST_NAME\n");
            printf("                                                       |\n");
            printf("                     ------------------------------------------------------------------\n");
            printf("                     |                                 |              |       |        |\n"); 
            printf("                    RETU                             YIEL            APAR  CALL_ARGS  CPAR\n");
            printf("                     |                                 |              |       |        |\n");
            printf("                     |                                 |              |      ARGS      |\n");
            printf("                     |                                 |              |       |        |\n");
            printf("                     |                                 |              |   CONST_NAME   |\n");
            printf("                     |                                 |              |       |        |\n");
            printf("                  return                              yield           (      const     )\n");

            break;
return 0;
}
}