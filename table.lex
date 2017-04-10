/*** seção de definição ***/

%{
#include <cstdio>
#include <vector>
#include "tokens.h"

typedef std::pair<int, int> ii;

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
	white_advance();
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

int main()
{
	std::vector<ii> stack;
	stack.push_back(ii(NT_PROGRAM, 0));
	int tok = yylex();

	while (!stack.empty()) {
		int symbol = stack.back().first;
		int level = stack.back().second;
		stack.pop_back();
		if (symbol > 0) { //terminal
			if (symbol != tok) {
				printf("Erro sintatico: linha %d, coluna %d\n", line, column);
				printf("(expecting %s, got %s)\n", symbol_names[symbol], symbol_names[tok]);
				return 1;
			}
		        for (int i = 0; i < level; i++) printf(" ");
			printf("%s (%s)\n", symbol_names[symbol], yytext);
			tok = yylex();
		} else { //nonterminal
			int prod = table[-symbol][tok];
			if (prod == ERRORCODE) {
				printf("Erro sintatico: linha %d, coluna %d\n", line, column);
				printf("(no rule for %s)\n", symbol_names[tok]);
				return 1;
			}
		        for (int i = 0; i < level; i++) printf(" ");
			printf("%s\n", symbol_names[symbol]);
			for (int x : productions[prod]) {
				stack.push_back(ii(x, level+1));
			}
		}
	}

    /* executa o analisador léxico. */
    return 0;
}
int yywrap(){ return 1; }


