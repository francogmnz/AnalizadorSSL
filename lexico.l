%{
#include "sintactico.tab.h"
#include <stdio.h>
#include <string.h>
extern char *Lexema[100], *Token[100];
extern int SubIndice, SubIndiceMax, NumLineas;
%}
%%
.AND. {CargarSubCadenas("AND");
    	return (AND);}
return {CargarSubCadenas("RETU");
    	return (RETU);}
yield {CargarSubCadenas("YIEL");
    	return (YIEL);}
")" {CargarSubCadenas("CPAR");
    	return (CPAR);}
"(" {CargarSubCadenas("APAR");
    	return (APAR);}
asscs {CargarSubCadenas("ASSCS");
    	return (ASSCS);}
"const" {CargarSubCadenas("CONST");
    	return (CONST);}
"," {CargarSubCadenas("COMA");
    	return (COMA);}
"*" {CargarSubCadenas("ASTERISCO");
    	return (ASTERISCO);}

\n   {     
      
	SubIndiceMax=SubIndice;
	SubIndice=0;
	NumLineas++;
       return (NL);}
%%
int CargarSubCadenas(char* NomToken){
	Lexema[SubIndice]=(char*)malloc((strlen(yytext)+1)*sizeof(char));
	strcpy(Lexema[SubIndice],yytext);
	Token[SubIndice]=(char*)malloc((strlen(NomToken)+1)*sizeof(char));
	strcpy(Token[SubIndice],NomToken);
	SubIndice++;
	return 0;
}