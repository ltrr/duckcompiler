/*** seção de definição ***/

%{
#include <stdio.h>

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
	printf("IMPORT\n");
	advance();
}

"return" {
	printf("RETURN\n");
	advance();
}

"break" {
	printf("BREAK\n");
	advance();
}

"continue" {
	printf("CONTINUE\n");
	advance();
}

"function" {
	printf("FUNCTION\n");
	advance();
}

"end" {
	printf("END\n");
	advance();
}

"if" {
	printf("IF\n");
	advance();
}

"then" {
	printf("THEN\n");
	advance();
}

"else" {
	printf("ELSE\n");
	advance();
}

"for" {
	printf("FOR\n");
	advance();
}

"to" {
	printf("TO\n");
	advance();
}

"loop" {
	printf("LOOP\n");
	advance();
}

"while" {
	printf("WHILE\n");
	advance();
}

"do" {
	printf("DO\n");
	advance();
}

"iterate" {
	printf("ITERATE\n");
	advance();
}

"and" {
	printf("AND\n");
	advance();
}

"or" {
	printf("OR\n");
	advance();
}

"not" {
	printf("NOT\n");
	advance();
}

"(" {
	printf(" ( \n");
	advance();
}

")" {
	printf(" ) \n");
	advance();
}

"=" {
	printf(" = \n");
	advance();
}

"." {
	printf(" . \n");
	advance();
}

"[" {
	printf(" [ \n");
	advance();
}

"]" {
	printf(" ] \n");
	advance();
}

"==" {
	printf(" == \n");
	advance();
}

"!=" {
	printf(" != \n");
	advance();
}

"<" {
	printf(" < \n");
	advance();
}

">" {
	printf(" > \n");
	advance();
}

"<=" {
	printf(" <= \n");
	advance();
}

">=" {
	printf(" >= \n");
	advance();
}

"+" {
	printf(" + \n");
	advance();
}

"-" {
	printf(" - \n");
	advance();
}

"*" {
	printf(" * \n");
	advance();
}

"/" {
	printf(" / \n");
	advance();
}

"!" {
	printf(" ! \n");
	advance();
}

"," {
	printf(" , \n");
	advance();
}

":" {
	printf(" : \n");
	advance();
}

"nill" {
	printf("NILL\n");
	advance();
}

"true" {
	printf("TRUE\n");
	advance();
}

"false" {
	printf("FALSE\n");
	advance();
}

[+-]?[0-9]+ {
	printf("Inteiro: %s\n", yytext);
	advance();
}

[+-]?[0-9]+[\.][0-9]* {
	printf("Float: %s\n", yytext);
	advance();
}

(\"[^\"\n]*\")|(\'[^\'\n]*\') {
	printf("String: %s\n", yytext);
	white_advance();
}

[ \t\v\n\f]*	{ 
	//printf("Whitespace\n");
	white_advance();
}

[a-zA-Z_][a-zA-Z0-9_]* {
	/* yytext é a cadeia contendo o texto casado. */
	printf("Identificador: %s\n", yytext);
	advance();
}

<<EOF>>	{
		printf("Fim do arquivo.\n");
		return 0;
	}

. {
	printf("Erro: %s\n", yytext);
	printf("Linha %d, coluna %d\n", line, column);
	advance();
}

%%
/*** seção de código C ***/

int main(void)
{
    /* executa o analisador léxico. */
    yylex();
    return 0;
}
int yywrap(){ return 1; }

// lex ducklex --> Gera o codigo C do analisador
// gcc lex.yy.c -o duck_lex --> compila o analisador
// https://www.lysator.liu.se/c/ANSI-C-grammar-l.html
