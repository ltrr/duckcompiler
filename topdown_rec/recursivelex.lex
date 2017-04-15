/*** seção de definição ***/

%{
#include <stdio.h>
#include <vector>
#include "table.h"
#include "def.h"

using namespace std;

int line = 1;	// A linha do caractere corrente
int column = 1;	// A coluna do caractere corrente
int level = 0;
int tok;

void printlvl(char* nt){
	for(int i = 0; i < level; i++)
		printf(" ");
	printf("%s\n",nt);
}

bool inside(int s, vector<int> symbols){
	bool ins = false;
	for(int i = 0; i < symbols.size(); i++)
		if(s == symbols[i])
			return true;
	return false;
}

void printerror(){
	printf("Erro sintatico: linha %d, coluna %d\n", line, column);
	printf("(got %s)\n", symbol_names[tok]);
}

void match(int symbol);

void advance()
// Adiciona o tamanho da string lida ao contador de coluna
{
	column += yyleng;
}

void white_advance()
// Avança o cursor baseado no conteúdo dele
{
	char *end = yytext + yyleng;
	for (char* c = yytext; c != end; c++) {	// Avança caractere por caractere da linha
		if (*c == '\n') {	// Verifica final da linha
			line += 1;
			column = 1;
		}
		else {
			column += 1;
		}
	}
}

%}

%%
		/*** seção de regras ***/
(\/\/)(.*)[\n] {
    printf("Comentário: %s\n", yytext);
    advance();
}

"import" {
	// printf("IMPORT\n");
	advance();
	return T_IMPORT;
}

"return" {
	// printf("RETURN\n");
	advance();
	return T_RETURN;
}

"break" {
	// printf("BREAK\n");
	advance();
	return T_BREAK;
}

"continue" {
	// printf("CONTINUE\n");
	advance();
	return T_CONTINUE;
}

"function" {
	// printf("FUNCTION\n");
	advance();
	return T_FUNCTION;
}

"end" {
	// printf("END\n");
	advance();
	return T_END;
}

"if" {
	// printf("IF\n");
	advance();
	return T_IF;
}

"then" {
	// printf("THEN\n");
	advance();
	return T_THEN;
}

"else" {
	// printf("ELSE\n");
	advance();
	return T_ELSE;
}

"for" {
	// printf("FOR\n");
	advance();
	return T_FOR;
}

"to" {
	// printf("TO\n");
	advance();
	return T_TO;
}

"loop" {
	// printf("LOOP\n");
	advance();
	return T_LOOP;
}

"while" {
	// printf("WHILE\n");
	advance();
	return T_WHILE;
}

"do" {
	 printf("DO\n");
	advance();
	return T_DO;
}

"iterate" {
	// printf("ITERATE\n");
	advance();
	return T_ITERATE;
}

"and" {
	// printf("AND\n");
	advance();
	return T_AND;
}

"or" {
	// printf("OR\n");
	advance();
	return T_OR;
}

"not" {
	// printf("NOT\n");
	advance();
	return T_NOT;
}

"(" {
	// printf(" ( \n");
	advance();
	return T_LPARENS;
}

")" {
	// printf(" ) \n");
	advance();
	return T_RPARENS;
}

"=" {
	// printf(" = \n");
	advance();
	return T_ASSIGN;
}

"." {
	// printf(" . \n");
	advance();
	return T_DOT;
}

"[" {
	// printf(" [ \n");
	advance();
	return T_LBRACKET;
}

"]" {
	// printf(" ] \n");
	advance();
	return T_RBRACKET;
}

"==" {
	// printf(" == \n");
	advance();
	return T_EQ;
}

"!=" {
	// printf(" != \n");
	advance();
	return T_NEQ;
}

"<" {
	// printf(" < \n");
	advance();
	return T_LT;
}

">" {
	// printf(" > \n");
	advance();
	return T_GT;
}

"<=" {
	// printf(" <= \n");
	advance();
	return T_LE;
}

">=" {
	// printf(" >= \n");
	advance();
	return T_GE;
}

"+" {
	// printf(" + \n");
	advance();
	return T_PLUS;
}

"-" {
	// printf(" - \n");
	advance();
	return T_MINUS;
}

"*" {
	// printf(" * \n");
	advance();
	return T_TIMES;
}

"/" {
	// printf(" / \n");
	advance();
	return T_DIV;
}

"!" {
	// printf(" ! \n");
	advance();
	return T_NEG;
}

"," {
	// printf(" , \n");
	advance();
	return T_COMMA;
}

":" {
	// printf(" : \n");
	advance();
	return T_COLON;
}

"nill" {
	// printf("NILL\n");
	advance();
	return T_NILL;
}

"true" {
	// printf("TRUE\n");
	advance();
	return T_TRUE;
}

"false" {
	// printf("FALSE\n");
	advance();
	return T_FALSE;
}

[0-9]+ {
	// printf("Inteiro: %s\n", yytext);
	advance();
	return T_INT;
}

[0-9]+[\.][0-9]* {
	// printf("Float: %s\n", yytext);
	advance();
	return T_FLOAT;
}

(\"[^\"\n]*\")|(\'[^\'\n]*\') {
	// printf("String: %s\n", yytext);
	advance();
	return T_STRING;
}

[\n] {
	white_advance();
	return T_ENDL;
}

[ \t\v\f]*	{ 
	//printf("Whitespace\n");
	white_advance();
}

[a-zA-Z_][a-zA-Z0-9_]* {
	/* yytext é a cadeia contendo o texto casado. */
	// printf("Identificador: %s\n", yytext);
	advance();
	return T_ID;
}

<<EOF>>	{
		printf("Fim do arquivo.\n");
		return T_EOF;
	}

. {
	printf("Erro Lexico: %s\n", yytext);
	printf("Linha %d, coluna %d\n", line, column);
	advance();
}

%%
/*** seção de código C ***/
int main(void)
{
    /* executa o analisador léxico. */
    // yylex();
    PROGRAM();
    return 0;
}
int yywrap(){ return 1; }
void match(int symbol){
	if(symbol == tok){
		level++;
		printlvl(yytext);
		level--;
		tok = yylex();
	} else {
		printerror();
	}
}

// ----- Seção de código das funções de recursão do analisador

void PROGRAM(){
    printlvl("PROGRAM");
    tok = yylex();
    STMTLIST();
}

void STMTLIST(){
	level++;
    printlvl("STMTLIST");
    if(inside(tok, {T_EOF, T_LOOP, T_END, T_ELSE})){	// epsilon ??
    	match(tok);
    } else if(inside(tok, {T_IMPORT,T_ENDL,T_RETURN,T_BREAK,T_CONTINUE,T_ID,T_IF, 						T_WHILE,T_FUNCTION,T_ITERATE,T_FOR})) {
		STMT();
		STMTLIST();
    } else {	// Error
    	printerror();
    }
    level--;
}

void STMT(){
	level++;
	printlvl("STMT");
	if(tok == T_IMPORT){
		match(T_IMPORT);
		match(T_ID);
		match(T_ENDL);
	} else if(tok == T_ENDL){
		match(T_ENDL);
	} else if(tok == T_ID){
		L_VALUE();
		LVSTMT();
		match(T_ENDL);
	} else if(tok == T_FUNCTION){
		FUNCTIONDEF();
		match(T_ENDL);
	} else if(tok == T_IF){
		IF();
		match(T_ENDL);
	} else if(tok == T_FOR){
		FORLOOP();
		match(T_ENDL);
	} else if(tok == T_WHILE){
		WHILELOOP();
		match(T_ENDL);
	} else if(tok == T_ITERATE){
		INDEFINITELOOP();
		match(T_ENDL);
	} else if(tok == T_RETURN){
		match(T_RETURN);
		EXPR();
		match(T_ENDL);
	} else if(tok == T_BREAK){
		match(T_BREAK);
		match(T_ENDL);
	} else if(tok == T_CONTINUE){
		match(T_CONTINUE);
		match(T_ENDL);
	} else {
		printerror();
	}
	level--;
}

void LVSTMT(){
	level++;
	printlvl("LVSTMT");
	if(tok == T_ASSIGN){
		ASSIGNMENT();
	} else if(tok == T_LPARENS){
		CALL();
	} else {
		printerror();
	}
	level--;
}

void CALL(){
	level++;
	if(tok == T_LPARENS){
		match(T_LPARENS);
		CALL1();
	} else {
		printerror();
	}
	level--;
}

void CALL1(){
	level++;
	if(tok == T_RPARENS){
		match(T_RPARENS);
	} else if(inside(tok,{T_NOT,T_MINUS,T_NEG,T_LPARENS,T_INT,T_FLOAT,T_STRING,T_NILL, 						T_TRUE,T_FALSE,T_LBRACKET,T_LBRACES,T_ID})){
		ARGUMENTS();
		match(T_RPARENS);
	} else {
		printerror();
	}
	level--;
}

void FUNCTIONDEF(){
	level++;
	if(tok == T_FUNCTION){
		match(T_FUNCTION);
		match(T_ID);
		PARAMETERS();
		match(T_ENDL);
		STMTLIST();
		match(T_END);
	} else {
		printerror();
	}
	level--;
}

void PARAMETERS(){}
void ARGUMENTS(){}
void IDENTIFIER(){}
void ASSIGNMENT(){}
void IF(){}
void FORLOOP(){}
void WHILELOOP(){}
void INDEFINITELOOP(){}
void EXPR(){}
void PARAMETERS_(){}
void PARAMDECL(){}
void PARAMDECL_(){}
void CONDITION(){}
void CONDITION_(){}
void ELSEIF1(){}
void ELSEIF2(){}
void ARITHMETIC(){}
void L_VALUE(){}
void L_VALUE1(){}
void LOGIC(){}
void COMPARISON(){}
void COMPARISON_(){}
void TERM(){}
void TERM_(){}
void FACTOR(){}
void FINAL(){}
void BOOLEAN(){}
void INTEGER(){}
void FLOAT(){}
void STRING(){}
void OBJECT(){}
void OBJECT_(){}
void REFERENCE(){}
void REFERENCE_(){}
void REFERENCE2(){}
void ARGUMENTS(){}
void ARGUMENTS_(){}
void DICTIONARYINIT(){}
void DICTIONARYINIT_(){}
void ARRAYINIT(){}
void ARRAYINIT_(){}

//
//
//
