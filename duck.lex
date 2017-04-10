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
		/*** seção de regras ***/
// Comentário
(\/\/)(.*)[\n] {
    printf("Comentário: %s\n", yytext);
    advance();
}

// Palavras-chave
"import" {
	printf("IMPORT\n");
	advance();
	return(T_IMPORT);
}

"return" {
	printf("RETURN\n");
	advance();
	return(T_RETURN);
}

"break" {
	printf("BREAK\n");
	advance();
	return(T_BREAK);
}

"continue" {
	printf("CONTINUE\n");
	advance();
	return(T_CONTINUE);
}

"function" {
	printf("FUNCTION\n");
	advance();
	return(T_FUNCTION);
}

"end" {
	printf("END\n");
	advance();
	return(T_END);
}

"if" {
	printf("IF\n");
	advance();
	return(T_IF);
}

"then" {
	printf("THEN\n");
	advance();
	return(T_THEN);
}

"else" {
	printf("ELSE\n");
	advance();
	return(T_ELSE);
}

"for" {
	printf("FOR\n");
	advance();
	return(T_FOR);
}

"to" {
	printf("TO\n");
	advance();
	return(T_TO);
}

"loop" {
	printf("LOOP\n");
	advance();
	return(T_LOOP);
}

"while" {
	printf("WHILE\n");
	advance();
	return(T_WHILE);
}

"do" {
	printf("DO\n");
	advance();
	return(T_DO);
}

"iterate" {
	printf("ITERATE\n");
	advance();
	return(T_ITERATE);
}

"and" {
	printf("AND\n");
	advance();
	return(T_AND);
}

"or" {
	printf("OR\n");
	advance();
	return(T_OR);
}

"not" {
	printf("NOT\n");
	advance();
	return(T_NOT);
}

// Símbolos especiais
"(" {
	printf(" ( \n");
	advance();
	return(T_LPARENS);
}

")" {
	printf(" ) \n");
	advance();
	return(T_RPARENS);
}

"=" {
	printf(" = \n");
	advance();
	return(T_ASSIGN);
}

"." {
	printf(" . \n");
	advance();
	return(T_DOT);
}

"{" {
	printf(" { \n");
	advance();
	return(T_LBRACES);
}

"}" {
	printf(" } \n");
	advance();
	return(T_RBRACES);
}

"[" {
	printf(" [ \n");
	advance();
	return(T_LBRACKET);
}

"]" {
	printf(" ] \n");
	advance();
	return(T_RBRACKET);
}

"==" {
	printf(" == \n");
	advance();
	return(T_EQ);
}

"!=" {
	printf(" != \n");
	advance();
	return(T_NEQ);
}

"<" {
	printf(" < \n");
	advance();
	return(T_LT);
}

">" {
	printf(" > \n");
	advance();
	return(T_GT);
}

"<=" {
	printf(" <= \n");
	advance();
	return(T_LE);	// "Less or equal"
}

">=" {
	printf(" >= \n");
	advance();
	return(T_GE);	// "Greater or equal"
}

"+" {
	printf(" + \n");
	advance();
	return(T_PLUS);
}

"-" {
	printf(" - \n");
	advance();
	return(T_MINUS);
}

"*" {
	printf(" * \n");
	advance();
	return(T_TIMES);
}

"/" {
	printf(" / \n");
	advance();
	return(T_DIV);
}

"!" {
	printf(" ! \n");
	advance();
	return(T_NEG);
}

"," {
	printf(" , \n");
	advance();
	return(T_COMMA);
}

":" {
	printf(" : \n");
	advance();
	return(T_COLON);
}

// Literais

"nill" {
	printf("NILL\n");
	advance();
	return(NILL);
}

"true" {
	printf("TRUE\n");
	advance();
	return(VERDADEIRO);
}

"false" {
	printf("FALSE\n");
	advance();
	return(FALSO);
}

[+-]?[0-9]+ {
	printf("Inteiro: %s\n", yytext);
	advance();
	return(INTEIRO);
}

[+-]?[0-9]+[\.][0-9]* {
	printf("Float: %s\n", yytext);
	advance();
	return(FLOAT);
}

(\"[^\"\n]*\")|(\'[^\'\n]*\') {
	printf("String: %s\n", yytext);
	advance();
	return(STRING);
}

// Caracteres brancos
[ \t\v\n\f]*	{ 
	//printf("Whitespace\n");
	white_advance();
}

// Identificadores
[a-zA-Z_][a-zA-Z0-9_]* {
	/* yytext é a cadeia contendo o texto casado. */
	printf("Identificador: %s\n", yytext);
	advance();
	return(IDENTIFICADOR);
}

<<EOF>>	{
		printf("Fim do arquivo.\n");
		return(T_EOF);
	}

. {
	printf("Erro: %s\n", yytext);
	printf("Linha %d, coluna %d\n", line, column);
	advance();
	return(ERRO);
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
