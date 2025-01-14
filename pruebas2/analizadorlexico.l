/*

	Elaboro: Aurelio Rojas Eng, Emilio Garcia Sanchez
	Fecha de entrega: 17 de marzo de 2022

*/
%{
#include <stdio.h>
#include <stdlib.h>

int valor; //Para poder conseguir el valor del token
int i,j; //Solo sirve para hacer iteraciones

//Apuntadores de archivos para la creacion de salidas .txt
FILE *tablaSimbolos; //Crea el txt para la tabla de simbolos
FILE *tablaLiteralesCadenas; //Crea el txt para la tabla de literales de cadenas
FILE *tablaLiteralesConstantes; //Crea el txt para la tabla de literales de constantes
FILE *tablaTokens; //Es la salida mas importante, genera los tokens con los valores y las clases

//Funciones para crear las Tablas de ayuda, los operadores, palabras reservadas, constantes reales y caracteres especiales tienen sus propias tablas.
void agregarTablaLiteralesCadenas(); //Tabla de ayuda para las cadenas. Debe llevar posicion, y la cadena
void agregarTablaSimbolos();  //Tabla de ayuda para identificadores. Tiene posicion, nombre del identificador y valor entero en -1
void agregarTablaLiteralesReales();  //Tabla de ayuda para los numeros reales. Lleva la posicion y la constante real
void agregarToken(int clase, int valor);//Sirve dando el numero de la clase y el valor en tablas o de la constante, si fuera el caso.

//Apuntadores de las tablas, sirven de ayuda para conseguir las listas ligadas
int *apuntadorCadenas, *apuntadorSimbolos, *apuntadorReales, *apuntadorTokens;

//Banderas Importantes para los apuntadores. Mencionan el tamano de las listas. Todas inicializadas en 0 por ser globales.
int tamC, tamS, tamR, tamT;

//A PARTIR DE AQUI SOLO ES LA CREACION DE LOS CATALOGOS O LAS TABLAS CONSTANTES
char tabla_palabras_reservadas[11][9]={	"cadena",
					"devuelve",
					"entero",
					"flotante",
					"hacer",
					"mientras",
					"nulo",
					"para",
					"si",
					"sino",
					"vacio"	};
char tabla_op_relacional[6][5]={"<M>", "<m>", "<=>", "<M=>", "<m=>", "<$=>"};
char tabla_op_asignacion[9][4]={"i_i", "M_i", "m_i", "a_i", "d_i", "p_i", "A_i", "P_i", "B_i"};
char tabla_op_aritmetico[6][5]={"sum", "res", "mult", "div", "mod", "pow"};
%}
identificador    [0-9][A-Za-z_]+|[A-Za-z][A-Za-z0-9_]*
const_num_entera    [1-9][0-9]*|0[0-7]|0[xX][0-9A-Fa-f]+
op_relacional    <[mM=]>|<[mM$]=>
op_asignacion    [iMmadpAPB]_i
palabra_reservada    "cadena"|"devuelve"|"entero"|"flotante"|"hacer"|"mientras"|"nulo"|"para"|"si"|"sino"|"vacio"
especial    [.:{}()]
op_aritmetico    "sum"|"res"|"mult"|"div"|"mod"|"pow"
const_cadena    \"[^"]{0,38}\"
const_num_real    [0-9]*\.[0-9]+|[0-9]+\.[0-9]*
error    [^{identificador}|{const_num_entera}|{op_relacional}|{op_asignacion}|{palabra_reservada}|{especial}|{op_aritmetico}|{const_cadena}|{const_num_real}|\t|\n|" "|\r|\v]
%%
{palabra_reservada}    {int valor, bandera;
			char lectura[9];
			strcpy(lectura, yytext);
			for(i=0; i<11; i++){
				bandera=0;
				for(j=0; j<yyleng; j++){
					if(tabla_palabras_reservadas[i][j] != lectura[j]){
						bandera=1;
					}
				}
				if(bandera == 0) valor = i;
			}
			agregarToken(4, valor);}
{op_aritmetico}     {int valor, bandera;
			char lectura[5];
			strcpy(lectura, yytext);
			for(i=0; i<6; i++){
				bandera=0;
				for(j=0; j<yyleng; j++){
					if(tabla_op_aritmetico[i][j] != lectura[j]){
						bandera=1;
					}
				}
				if(bandera == 0) valor = i;
			}
			agregarToken(6, valor);}
{op_asignacion}     {int valor, bandera;
			char lectura[5];
			strcpy(lectura, yytext);
			for(i=0; i<6; i++){
				bandera=0;
				for(j=0; j<yyleng; j++){
					if(tabla_op_asignacion[i][j] != lectura[j]){
						bandera=1;
					}
				}
				if(bandera == 0) valor = i;
			}
			agregarToken(3, valor);}
{op_relacional}     {int valor, bandera;
			char lectura[4];
			strcpy(lectura, yytext);
			for(i=0; i<9; i++){
				bandera=0;
				for(j=0; j<yyleng; j++){
					if(tabla_op_relacional[i][j] != lectura[j]){
						bandera=1;
					}
				}
				if(bandera == 0) valor = i;
			}
			agregarToken(2, valor);}
{identificador}     {agregarTablaSimbolos();
			agregarTablaSimbolos();
			agregarToken(0, valor);}
{const_cadena}     {agregarTablaLiteralesCadenas();
			agregarToken(7,valor);}
{const_num_real}     {agregarTablaLiteralesReales();
			agregarToken(8, valor);}
{const_num_entera}     {int valor;
			agregarToken(1, (int)*yytext);}
{especial}     {agregarToken(5,(int)*yytext);}
{error}    {printf("\nNo se encuentra %s",yytext);}
%%
void agregarTablaSimbolos(){
	
}

void agregarTablaLiteralesCadenas(){
	
}

void agregarTablaLiteralesReales(){
	
}

void agregarToken(int clase, int valor){
	char buffer[10] = "\nTokens";
	tablaTokens = fopen ( "tablaTokens.txt", "w+" );
	fprintf(tablaTokens, buffer);
	fprintf(tablaTokens,"\nClase: %d, Valor: %d",clase,valor);	
}

int main(int argc, char *argv[]){	
	yyin = fopen(argv[1],"r");
	yylex();
	return(0);
}
