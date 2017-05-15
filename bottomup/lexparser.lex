%option noyywrap

%{

#include "stringtree.h"
#include "tokens.h"

int line = 1;	// A linha do caractere corrente
int column = 1;	// A coluna do caractere corrente

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

(\/\/)(.*)[\n] {
	white_advance();
}

"import" {
	advance();
	yylval = StringTree("IMPORT");
	return T_IMPORT;
}

"return" {
	advance();
	yylval = StringTree("RETURN");
	return T_RETURN;
}

"break" {
	advance();
	yylval = StringTree("BREAK");
	return T_BREAK;
}

"continue" {
	advance();
	yylval = StringTree("CONTINUE");
	return T_CONTINUE;
}

"function" {
	advance();
	yylval = StringTree("FUNCTION");
	return T_FUNCTION;
}

"end" {
	advance();
	yylval = StringTree("END");
	return T_END;
}

"if" {
	advance();
	yylval = StringTree("IF");
	return T_IF;
}

"then" {
	advance();
	yylval = StringTree("THEN");
	return T_THEN;
}

"else" {
	advance();
	yylval = StringTree("ELSE");
	return T_ELSE;
}

"for" {
	advance();
	yylval = StringTree("FOR");
	return T_FOR;
}

"to" {
	advance();
	yylval = StringTree("TO");
	return T_TO;
}

"loop" {
	advance();
	yylval = StringTree("LOOP");
	return T_LOOP;
}

"while" {
	advance();
	yylval = StringTree("WHILE");
	return T_WHILE;
}

"do" {
	advance();
	yylval = StringTree("DO");
	return T_DO;
}

"iterate" {
	advance();
	yylval = StringTree("ITERATE");
	return T_ITERATE;
}

"and" {
	advance();
	yylval = StringTree("AND");
	return T_AND;
}

"or" {
	advance();
	yylval = StringTree("OR");
	return T_OR;
}

"not" {
	advance();
	yylval = StringTree("NOT");
	return T_NOT;
}

"(" {
	advance();
	yylval = StringTree("(");
	return T_LPARENS;
}

")" {
	advance();
	yylval = StringTree(")");
	return T_RPARENS;
}

"=" {
	advance();
	yylval = StringTree("=");
	return T_ASSIGN;
}

"." {
	advance();
	yylval = StringTree(".");
	return T_DOT;
}

"[" {
	advance();
	yylval = StringTree("[");
	return T_LBRACKET;
}

"]" {
	advance();
	yylval = StringTree("]");
	return T_RBRACKET;
}

"==" {
	advance();
	yylval = StringTree("==");
	return T_EQ;
}

"!=" {
	advance();
	yylval = StringTree("!=");
	return T_NEQ;
}

"<" {
	advance();
	yylval = StringTree("<");
	return T_LT;
}

">" {
	advance();
	yylval = StringTree(">");
	return T_GT;
}

"<=" {
	advance();
	yylval = StringTree("<=");
	return T_LE;
}

">=" {
	advance();
	yylval = StringTree(">=");
	return T_GE;
}

"+" {
	advance();
	yylval = StringTree("+");
	return T_PLUS;
}

"-" {
	advance();
	yylval = StringTree("-");
	return T_MINUS;
}

"*" {
	advance();
	yylval = StringTree("*");
	return T_TIMES;
}

"/" {
	advance();
	yylval = StringTree("/");
	return T_DIV;
}

"!" {
	advance();
	yylval = StringTree("!");
	return T_NEG;
}

"," {
	advance();
	yylval = StringTree(",");
	return T_COMMA;
}

":" {
	advance();
	yylval = StringTree(":");
	return T_COLON;
}

"nill" {
	advance();
	yylval = StringTree("NILL");
	return T_NILL;
}

"true" {
	advance();
	yylval = StringTree("TRUE");
	return T_TRUE;
}

"false" {
	advance();
	yylval = StringTree("FALSE");
	return T_FALSE;
}

[0-9]+ {
	advance();
	yylval = StringTree("INT");
	return T_INT;
}

[0-9]+[\.][0-9]* {
	advance();
	yylval = StringTree("FLOAT");
	return T_FLOAT;
}

(\"[^\"\n]*\")|(\'[^\'\n]*\') {
	white_advance();
	yylval = StringTree("STRING");
	return T_STRING;
}

[\n] {
	white_advance();
	yylval = StringTree("ENDL");
	return T_ENDL;
}

[ \t\v\f]*	{ 
	white_advance();
}

[a-zA-Z_][a-zA-Z0-9_]* {
	advance();
	yylval = StringTree("ID");
	return T_ID;
}

<<EOF>>	{
	//return T_EOF;
	return 0;
}

. {
	fprintf(stderr, "Erro Lexico: %s\n", yytext);
	fprintf(stderr, "Linha %d, coluna %d\n", line, column);
	advance();
}
