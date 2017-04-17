/*** seção de definição ***/

%{
#include <cstdio>
#include <vector>
#include "table.h"

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
	advance();
	return T_IMPORT;
}

"return" {
	advance();
	return T_RETURN;
}

"break" {
	advance();
	return T_BREAK;
}

"continue" {
	advance();
	return T_CONTINUE;
}

"function" {
	advance();
	return T_FUNCTION;
}

"end" {
	advance();
	return T_END;
}

"if" {
	advance();
	return T_IF;
}

"then" {
	advance();
	return T_THEN;
}

"else" {
	advance();
	return T_ELSE;
}

"for" {
	advance();
	return T_FOR;
}

"to" {
	advance();
	return T_TO;
}

"loop" {
	advance();
	return T_LOOP;
}

"while" {
	advance();
	return T_WHILE;
}

"do" {
	 printf("DO\n");
	advance();
	return T_DO;
}

"iterate" {
	advance();
	return T_ITERATE;
}

"and" {
	advance();
	return T_AND;
}

"or" {
	advance();
	return T_OR;
}

"not" {
	advance();
	return T_NOT;
}

"(" {
	advance();
	return T_LPARENS;
}

")" {
	advance();
	return T_RPARENS;
}

"=" {
	advance();
	return T_ASSIGN;
}

"." {
	advance();
	return T_DOT;
}

"[" {
	advance();
	return T_LBRACKET;
}

"]" {
	advance();
	return T_RBRACKET;
}

"{" {
	advance();
	return T_LBRACES;
}

"}" {
	advance();
	return T_RBRACES;
}

"==" {
	advance();
	return T_EQ;
}

"!=" {
	advance();
	return T_NEQ;
}

"<" {
	advance();
	return T_LT;
}

">" {
	advance();
	return T_GT;
}

"<=" {
	advance();
	return T_LE;
}

">=" {
	advance();
	return T_GE;
}

"+" {
	advance();
	return T_PLUS;
}

"-" {
	advance();
	return T_MINUS;
}

"*" {
	advance();
	return T_TIMES;
}

"/" {
	advance();
	return T_DIV;
}

"!" {
	advance();
	return T_NEG;
}

"," {
	advance();
	return T_COMMA;
}

":" {
	advance();
	return T_COLON;
}

"nill" {
	advance();
	return T_NILL;
}

"true" {
	advance();
	return T_TRUE;
}

"false" {
	advance();
	return T_FALSE;
}

[0-9]+ {
	advance();
	return T_INT;
}

[0-9]+[\.][0-9]* {
	advance();
	return T_FLOAT;
}

(\"[^\"\n]*\")|(\'[^\'\n]*\') {
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
	advance();
	return T_ID;
}

<<EOF>>	{
	return T_EOF;
}

. {
	fprintf(stderr, "Erro Lexico: %s\n", yytext);
	fprintf(stderr, "Linha %d, coluna %d\n", line, column);
	advance();
}

%%
/*** seção de código C ***/

void printident(int level) {
	for (int i = 0; i < level; i++) printf(" ");
}

int main()
{
	std::vector<ii> stack;
	stack.push_back(ii(NT_PROGRAM, 0));
	int tok = yylex();

	bool success = true;

	while (!stack.empty()) {
		int symbol = stack.back().first;
		int level = stack.back().second;
		stack.pop_back();
		if (symbol > 0) { //terminal
			if (symbol != tok) {
				if (success) {
					fprintf(stderr, "Erro sintatico: linha %d, coluna %d\n", line, column);
					fprintf(stderr, "(expecting %s, got %s)\n", symbol_names[symbol], symbol_names[tok]);
					success = false;
				}
			} else {
		        	printident(level);
				printf("%s (%s)\n", symbol_names[symbol], yytext);
				success = true;
			}
			tok = yylex();
		} else { //nonterminal

			int prod = table[-symbol][tok];
			if (prod == POPCODE || prod == SCANCODE) {
				if (success) {
					fprintf(stderr, "Erro sintatico: linha %d, coluna %d\n", line, column);
					fprintf(stderr, "(no rule for %s)\n", symbol_names[tok]);
					success = false;
				}
				while (prod == SCANCODE && tok != T_EOF) {
					tok = yylex();
					prod = table[-symbol][tok];	
				}
			}
			else {
			        printident(level);
				printf("%s\n", symbol_names[symbol]);
				for (int x : productions[prod]) {
					stack.push_back(ii(x, level+1));
				}
				success = true;
			}
		}
    	}
	return 0;
}
int yywrap(){ return 1; }


