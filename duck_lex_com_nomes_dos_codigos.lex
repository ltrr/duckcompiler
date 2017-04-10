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
(\/\/)(.*)[\n] {
    //printf("Comentário: %s\n", yytext);
    advance();
}

"import" {
	//printf("IMPORT\n");
	advance();
	return(T_IMPORT);
}

"return" {
	//printf("RETURN\n");
	advance();
	return(T_RETURN);
}

"break" {
	//printf("BREAK\n");
	advance();
	return(T_BREAK);
}

"continue" {
	//printf("CONTINUE\n");
	advance();
	return(T_CONTINUE);
}

"function" {
	//printf("FUNCTION\n");
	advance();
	return(T_FUNCTION);
}

"end" {
	//printf("END\n");
	advance();
	return(T_END);
}

"if" {
	//printf("IF\n");
	advance();
	return(T_IF);
}

"then" {
	//printf("THEN\n");
	advance();
	return(T_THEN);
}

"else" {
	//printf("ELSE\n");
	advance();
	return(T_ELSE);
}

"for" {
	//printf("FOR\n");
	advance();
	return(T_FOR);
}

"to" {
	//printf("TO\n");
	advance();
	return(T_TO);
}

"loop" {
	//printf("LOOP\n");
	advance();
	return(T_LOOP);
}

"while" {
	//printf("WHILE\n");
	advance();
	return(T_WHILE);
}

"do" {
	//printf("DO\n");
	advance();
	return(T_DO);
}

"iterate" {
	//printf("ITERATE\n");
	advance();
	return(T_ITERATE);
}

"and" {
	//printf("AND\n");
	advance();
	return(T_AND);
}

"or" {
	//printf("OR\n");
	advance();
	return(T_OR);
}

"not" {
	//printf("NOT\n");
	advance();
	return(T_NOT);
}

"(" {
	//printf(" ( \n");
	advance();
	return('(');
}

")" {
	//printf(" ) \n");
	advance();
	return(')');
}

"=" {
	//printf(" = \n");
	advance();
	return('=');
}

"." {
	//printf(" . \n");
	advance();
	return('.');
}

"{" {
	//printf(" { \n");
	advance();
	return('}');
}

"}" {
	//printf(" } \n");
	advance();
	return('}');
}

"[" {
	//printf(" [ \n");
	advance();
	return('[');
}

"]" {
	//printf(" ] \n");
	advance();
	return(']');
}

"==" {
	//printf(" == \n");
	advance();
	return(T_EQ);
}

"!=" {
	//printf(" != \n");
	advance();
	return(T_NEQ);
}

"<" {
	//printf(" < \n");
	advance();
	return('<');
}

">" {
	//printf(" > \n");
	advance();
	return('>');
}

"<=" {
	//printf(" <= \n");
	advance();
	return(T_LE);	// "Less or equal"
}

">=" {
	//printf(" >= \n");
	advance();
	return(T_GE);	// "Greater or equal"
}

"+" {
	//printf(" + \n");
	advance();
	return('+');
}

"-" {
	//printf(" - \n");
	advance();
	return('-');
}

"*" {
	//printf(" * \n");
	advance();
	return('*');
}

"/" {
	//printf(" / \n");
	advance();
	return('/');
}

"!" {
	//printf(" ! \n");
	advance();
	return('!');
}

"," {
	//printf(" , \n");
	advance();
	return(',');
}

":" {
	//printf(" : \n");
	advance();
	return(':');
}

"nill" {
	//printf("NILL\n");
	advance();
	return(T_NILL);
}

"true" {
	//printf("TRUE\n");
	advance();
	return(T_TRUE);
}

"false" {
	//printf("FALSE\n");
	advance();
	return(T_FALSE);
}

[+-]?[0-9]+ {
	//printf("Inteiro: %s\n", yytext);
	advance();
	return(T_INT);
}

[+-]?[0-9]+[\.][0-9]* {
	//printf("Float: %s\n", yytext);
	advance();
	return(T_FLOAT);
}

(\"[^\"\n]*\")|(\'[^\'\n]*\') {
	//printf("String: %s\n", yytext);
	advance();
	return(T_STRING);
}

[ \t\v\n\f]*	{ 
	//printf("Whitespace\n");
	white_advance();
}

[a-zA-Z_][a-zA-Z0-9_]* {
	/* yytext é a cadeia contendo o texto casado. */
	//printf("Identificador: %s\n", yytext);
	advance();
	return(T_ID);
}

<<EOF>>	{
		printf("Fim do arquivo.\n");
		return(T_EOF);
	}

. {
	//printf("Erro: %s\n", yytext);
	//printf("Linha %d, coluna %d\n", line, column);
	advance();
	return(ERRO);
}

%%
/*** seção de código C ***/

void PROGRAM();
void STMTLIST();
void STMT();
void IDENTIFIER();
void ASSIGNMENT();
void FUNCTIONDEF();
void IF();
void FORLOOP();
void WHILELOOP();
void INDEFINITELOOP();
void EXPR();
void PARAMETERS();
void PARAMETERS_();
void PARAMDECL();
void PARAMDECL_();
void CONDITION();
void CONDITION_();
void ELSEIF1();
void ELSEIF2();
void ARITHMETIC();
void L-VALUE();
void L-VALUE1();
void LOGIC();
void COMPARISON();
void COMPARISON_();
void TERM();
void TERM_();
void FACTOR();
void FINAL();
void BOOLEAN();
void INTEGER();
void FLOAT();
void STRING();
void OBJECT();
void OBJECT_();
void REFERENCE();
void REFERENCE_();
void REFERENCE2()
void ARGUMENTS();
void ARGUMENTS_();
void DICTIONARYINIT();
void DICTIONARYINIT_();
void ARRYINIT();
void ARRYINIT_();

int main(void)
{
    /* executa o analisador léxico. */
    // yylex();
    PROGRAM();
    return 0;
}
int yywrap(){ return 1; }

void PROGRAM(){
    printf("\tPROGRAM");
    STMTLIST();
}

void STMTLIST(){
    printf("\tSTMTLIST");
    yylex();
    if(yytext == ""){
	return;
    } else {
	STMT();
	STMTLIST();
    }
}

void STMT();
void IDENTIFIER();
void ASSIGNMENT();
void FUNCTIONDEF();
void IF();
void FORLOOP();
void WHILELOOP();
void INDEFINITELOOP();
void EXPR();
void PARAMETERS();
void PARAMETERS_();
void PARAMDECL();
void PARAMDECL_();
void CONDITION();
void CONDITION_();
void ELSEIF1();
void ELSEIF2();
void ARITHMETIC();
void L-VALUE();
void L-VALUE1();
void LOGIC();
void COMPARISON();
void COMPARISON_();
void TERM();
void TERM_();
void FACTOR();
void FINAL();
void BOOLEAN();
void INTEGER();
void FLOAT();
void STRING();
void OBJECT();
void OBJECT_();
void REFERENCE();
void REFERENCE_();
void REFERENCE2()
void ARGUMENTS();
void ARGUMENTS_();
void DICTIONARYINIT();
void DICTIONARYINIT_();
void ARRYINIT();
void ARRYINIT_();

// lex ducklex --> Gera o codigo C do analisador
// gcc lex.yy.c -o duck_lex --> compila o analisador
// https://www.lysator.liu.se/c/ANSI-C-grammar-l.html
