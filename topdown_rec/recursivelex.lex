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
int tok,exp;
bool p_error = true;

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

int yylex();

void printerror(){
	if (p_error) {
		fprintf(stderr, "Erro sintatico: linha %d, coluna %d\n", line, column);
		fprintf(stderr, "Unexpected symbol %s (%s)\n", yytext, symbol_names[tok]);
		while (tok != T_ENDL && tok != T_EOF) {
			tok = yylex();
		}
		if(tok != T_EOF)
			tok = yylex();
		p_error = false;
	}
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
    //printf("Comentário: %s\n", yytext);
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
	// printf("DO\n");
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

"{" {
	// printf(" { \n");
	advance();
	return T_LBRACES;
}

"}" {
	// printf(" } \n");
	advance();
	return T_RBRACES;
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
		//printf("Fim do arquivo.\n");
		//match(T_EOF);
		return T_EOF;
	}

. {
	fprintf(stderr,"Erro Lexico: %s\n", yytext);
	fprintf(stderr,"Linha %d, coluna %d\n", line, column);
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
	exp = symbol;
	if(symbol == tok){
		level++;
		printlvl(yytext);
		level--;
		p_error = true;
	} else if(p_error) {
		fprintf(stderr,"Erro sintatico: linha %d, coluna %d\n", line, column);
		fprintf(stderr,"Got %s (%s), expected %s\n", yytext, symbol_names[tok], symbol_names[exp]);
		while (tok != T_ENDL && tok != T_EOF) {
			tok = yylex();
		}
		p_error = false;
	}
	if (tok != T_EOF)
		tok = yylex();
}

// ----- Seção de código das funções de recursão do analisador

void PROGRAM(){
    printlvl("PROGRAM");
    tok = yylex();
    if(inside(tok,{T_IMPORT, T_ENDL, T_RETURN, T_BREAK, T_CONTINUE, T_ID, T_IF, T_WHILE, T_FUNCTION, T_ITERATE, T_FOR})){
	STMTLIST();
    } else {
	printerror();
    }
    match(T_EOF);
}

void STMTLIST(){
    level++;
    printlvl("STMTLIST"); // T_LOOP,
    if(inside(tok,{T_LOOP,T_END,T_ELSE,T_EOF})){
	// epsilon
    } else if(inside(tok, {T_IMPORT, T_ENDL, T_RETURN, T_BREAK, T_CONTINUE, T_ID, T_IF, T_WHILE, T_FUNCTION, T_ITERATE, T_FOR})) {
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
	printlvl("CALL");
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
	printlvl("CALL1");
	if(tok == T_RPARENS){
		match(T_RPARENS);
	} else if(inside(tok,{T_NOT, T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		ARGUMENTS();
		match(T_RPARENS);
	} else {
		printerror();
	}
	level--;
}

void FUNCTIONDEF(){
	level++;
	printlvl("FUNCTIONDEF");
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

void PARAMETERS(){
	level++;
	printlvl("PARAMETERS");
	if(tok == T_LPARENS){
		match(T_LPARENS);
		PARAMETERS1();
	} else {
		printerror();
	}
	level--;
}

void PARAMETERS1(){
	level++;
	printlvl("PARAMETERS1");
	if(tok == T_RPARENS){
		match(T_RPARENS);
	} else if(tok == T_ID){
		PARAMDECL();
		match(T_RPARENS);
	} else {
		printerror();
	}
	level--;
}

void PARAMDECL(){
	level++;
	printlvl("PARAMDECL");
	if(tok == T_ID){
		match(T_ID);
		PARAMDECL1();
	} else {
		printerror();
	}
	level--;
}

void PARAMDECL1(){
	level++;
	printlvl("PARAMDECL1");
	if(tok == T_COMMA){
		match(T_COMMA);
		match(T_ID);
		PARAMDECL1();
	} else if(tok == T_RPARENS){
		// epsilon
	} else {
		printerror();
	}
	level--;
}

void IF(){
	level++;
	printlvl("IF");
	if(tok == T_IF){
		match(T_IF);
		CONDITION();
		match(T_THEN);
		match(T_ENDL);
		STMTLIST();
		ELSEIF1();
	} else {
		printerror();
	}
	level--;
}

void ELSEIF1(){
	level++;
	printlvl("ELSEIF1");
	if(tok == T_ELSE){
		match(T_ELSE);
		ELSEIF2();
	} else if(tok == T_END){
		match(T_END);
	} else {
		printerror();
	}
	level--;
}

void ELSEIF2(){
	level++;
	printlvl("ELSEIF2");
	if(tok == T_ENDL){
		match(T_ENDL);
		STMTLIST();
		match(T_END);
	} else if(tok == T_IF){
		IF();		
	} else {
		printerror();
	}
	level--;
}

void FORLOOP(){
	level++;
	printlvl("FORLOOP");
	if(tok == T_FOR){
		match(T_FOR);
		match(T_ID);
		match(T_ASSIGN);
		ARITHMETIC();
		match(T_TO);
		ARITHMETIC();
		match(T_DO);
		match(T_ENDL);
		STMTLIST();
		match(T_LOOP);
	} else {
		printerror();
	}
	level--;
}

void WHILELOOP(){
	level++;
	printlvl("WHILELOOP");
	if(tok == T_WHILE){
		match(T_WHILE);
		CONDITION();
		match(T_DO);
		match(T_ENDL);
		STMTLIST();
		match(T_LOOP);
	} else {
		printerror();
	}
	level--;
}

void INDEFINITELOOP(){
	level++;
	printlvl("INDEFINITELOOP");
	if(tok == T_ITERATE){
		match(T_ITERATE);
		match(T_ENDL);
		STMTLIST();
		match(T_LOOP);
	} else {
		printerror();
	}
	level--;
}

void ASSIGNMENT(){
	level++;
	printlvl("ASSIGNMENT");
	if(tok == T_ASSIGN){
		match(T_ASSIGN);
		CONDITION();
	} else {
		printerror();
	}
	level--;
}

void EXPR(){
	level++;
	printlvl("EXPR");
	if(inside(tok,{T_NOT, T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		CONDITION();
	} else {
		printerror();
	}
	level--;
}

void CONDITION(){
	level++;
	printlvl("CONDITION");
	if(inside(tok,{T_NOT, T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		LOGIC();
		CONDITION1();
	} else {
		printerror();
	}
	level--;
}

void CONDITION1(){
	level++;
	printlvl("CONDITION1");
	if(tok == T_AND){
		match(T_AND);
		LOGIC();
		CONDITION1();
	} else if(tok == T_OR){
		match(T_OR);
		LOGIC();
		CONDITION1();
	} else if(inside(tok,{T_DO, T_THEN, T_COMMA, T_RBRACKET, T_RPARENS, T_ENDL, T_RBRACES})){
		// epsilon
	} else {
		printerror();
	}
	level--;
}

void LOGIC(){
	level++;
	printlvl("LOGIC");
	if(tok == T_NOT){
		match(T_NOT);
		COMPARISON();
	} else if(inside(tok,{T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		COMPARISON();
	} else {
		printerror();
	}
	level--;
}

void COMPARISON(){
	level++;
	printlvl("COMPARISON");
	if(inside(tok,{T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		ARITHMETIC();
		COMPARISON1();
	} else {
		printerror();
	}
	level--;
}

void COMPARISON1(){
	level++;
	printlvl("COMPARISON1");
	if(tok == T_EQ){
		match(T_EQ);
		ARITHMETIC();
		COMPARISON1();
	} else if(tok == T_NEQ){
		match(T_NEQ);
		ARITHMETIC();
		COMPARISON1();
	} else if(tok == T_LT){
		match(T_LT);
		ARITHMETIC();
		COMPARISON1();
	} else if(tok == T_GT){
		match(T_GT);
		ARITHMETIC();
		COMPARISON1();
	} else if(tok == T_LE){
		match(T_LE);
		ARITHMETIC();
		COMPARISON1();
	} else if(tok == T_GE){
		match(T_GE);
		ARITHMETIC();
		COMPARISON1();
	} else if(inside(tok,{T_AND, T_OR, T_DO, T_THEN, T_COMMA, T_RBRACKET, T_RPARENS, T_ENDL, T_RBRACES})){
		// epsilon
	} else {
		printerror();
	}
	level--;
}

void ARITHMETIC(){
	level++;
	printlvl("ARITHMETIC");
	if(inside(tok,{T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
	        TERM();
		ARITHMETIC1();
	} else {
		printerror();
	}
	level--;
}

void ARITHMETIC1(){
	level++;
	printlvl("ARITHMETIC1");
	if(tok == T_PLUS){
		match(T_PLUS);
		TERM();
		ARITHMETIC1();
	} else if (tok == T_MINUS){
		match(T_MINUS);
		TERM();
		ARITHMETIC1();
	} else if(inside(tok,{T_EQ, T_NEQ, T_LT, T_GT, T_LE, T_GE, T_TO, T_DO, T_AND, T_OR, T_THEN, T_COMMA, T_RBRACKET, T_RPARENS, T_ENDL, T_RBRACES})){
		// epsilon
	} else {
		printerror();
	}
	level--;
}

void TERM(){
	level++;
	printlvl("TERM");
	if(inside(tok,{T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID}) ){
		FACTOR();
		TERM1();
	} else {
		printerror();
	}
	level--;
}

void TERM1(){
	level++;
	printlvl("TERM1");
	if(tok == T_TIMES ){
		match(T_TIMES);
		FACTOR();
		TERM1();
	} else if (tok == T_DIV){
		match(T_DIV);
		FACTOR();
		TERM1();
	} else if(inside(tok,{T_PLUS, T_MINUS, T_EQ, T_NEQ, T_LT, T_GT, T_LE, T_GE, T_TO, T_DO, T_AND, T_OR, T_THEN, T_COMMA, T_RBRACKET, T_RPARENS, T_ENDL, T_RBRACES})){
		// epsilon
	} else {
		printerror();
	}
	level--;
}

void FACTOR(){
	level++;
	printlvl("FACTOR");
	if(tok == T_MINUS){
		match(T_MINUS);
		FACTOR();
	} else if(tok == T_NEG){
		match(T_NEG);
		FACTOR();
	} else if(inside(tok,{T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		FINAL();
	} else {
		printerror();
	}
	level--;
}

void FINAL(){
	level++;
	printlvl("FINAL");
	if(tok == T_LPARENS){
		match(T_LPARENS);
		EXPR();
		match(T_RPARENS);
	} else if(inside(tok,{T_TRUE,T_FALSE})){
		BOOLEAN();
	} else if(tok == T_INT){
		match(T_INT);
	} else if(tok == T_FLOAT){
		match(T_FLOAT);
	} else if(tok == T_STRING){
		match(T_STRING);
	} else if(inside(tok,{T_LBRACKET,T_LBRACES})){
		OBJECT();
	} else if(tok == T_ID){
		REFERENCE();
	} else if(tok == T_NILL){
		match(T_NILL);
	} else {
		printerror();
	}
	level--;
}

void L_VALUE(){
	level++;
	printlvl("LVALUE");
	if(tok == T_ID){
		match(T_ID);
		L_VALUE1();
	} else {
		printerror();
	}
	level--;
}

void L_VALUE1(){
	level++;
	printlvl("LVALUE1");
	if(inside(tok,{T_LPARENS, T_ASSIGN, T_TIMES, T_DIV, T_PLUS, T_MINUS, T_EQ, T_NEQ, T_LT, T_GT, T_LE, T_GE, T_TO, T_DO, T_AND, T_OR, T_THEN, T_COMMA, T_RBRACKET, T_RPARENS, T_ENDL, T_RBRACES})){
		// epsilon
	} else if(tok == T_DOT){
		match(T_DOT);
		match(T_ID);
		L_VALUE1();
	} else if(tok == T_LBRACKET){
		match(T_LBRACKET);
		EXPR();
		match(T_RBRACKET);
		L_VALUE1();
	} else {
		printerror();
	}
	level--;
}

void REFERENCE(){
	level++;
	printlvl("REFERENCE");
	if(tok == T_ID){
		L_VALUE();
		REFERENCE1();
	} else {
		printerror();
	}
	level--;
}

void REFERENCE1(){
	level++;
	printlvl("REFERENCE1");
	if(inside(tok,{T_TIMES, T_DIV, T_PLUS, T_MINUS, T_EQ, T_NEQ, T_LT, T_GT, T_LE, T_GE, T_TO, T_DO, T_AND, T_OR, T_THEN, T_COMMA, T_RBRACKET, T_RPARENS, T_ENDL, T_RBRACES})){
		// epsilon
	} else if(tok == T_LPARENS){
		match(T_LPARENS);
		REFERENCE2();
	} else {
		printerror();
	}
	level--;
}

void REFERENCE2(){
	level++;
	printlvl("REFERENCE2");
	if(tok == T_RPARENS){
		match(T_RPARENS);
		REFERENCE1();
	} else if(inside(tok,{T_NOT, T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		ARGUMENTS();
		match(T_RPARENS);
		REFERENCE1();
	} else {
		printerror();
	}
	level--;
}

void ARGUMENTS(){
	level++;
	printlvl("ARGUMENTS");
	if(inside(tok,{T_NOT, T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		EXPR();
		ARGUMENTS1();
	} else {
		printerror();
	}
	level--;
}

void ARGUMENTS1(){
	level++;
	printlvl("ARGUMENTS1");
	if(tok == T_RPARENS){
		// epsilon
	} else if(tok == T_COMMA){
		match(T_COMMA);
		EXPR();
		ARGUMENTS1();
	} else {
		printerror();
	}
	level--;
}

void OBJECT(){
	level++;
	printlvl("OBJECT");
	if(tok == T_LBRACKET){
		match(T_LBRACKET);
		OBJECT1();
	} else if(tok == T_LBRACES){
		match(T_LBRACES);
		DICTIONARYINIT();
		match(T_RBRACES);
	} else {
		printerror();
	}
	level--;
}

void OBJECT1(){
	level++;
	printlvl("OBJECT1");
	if(tok == T_RBRACKET){
		match(T_RBRACKET);
	} else if(inside(tok,{T_NOT, T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		ARRAYINIT();
		match(T_RBRACKET);
	} else {
		printerror();
	}
	level--;
}

void ARRAYINIT(){
	level++;
	printlvl("ARRAYINIT");
	if(inside(tok,{T_NOT, T_MINUS, T_NEG, T_LPARENS, T_INT, T_FLOAT, T_STRING, T_NILL, T_TRUE, T_FALSE, T_LBRACKET, T_LBRACES, T_ID})){
		EXPR();
		ARRAYINIT1();
	} else {
		printerror();
	}
	level--;
}

void ARRAYINIT1(){
	level++;
	printlvl("ARRAYINIT1");
	if(tok == T_RBRACKET){
		// epsilon
	} else if(tok == T_COMMA){
		match(T_COMMA);
		EXPR();
		ARRAYINIT1();
	} else {
		printerror();
	}
	level--;
}

void DICTIONARYINIT(){
	level++;
	printlvl("DICTIONARYINIT");
	if(tok == T_ID){
		match(T_ID);
		match(T_COLON);
		EXPR();
		DICTIONARYINIT1();
	} else {
		printerror();
	}
	level--;
}

void DICTIONARYINIT1(){
	level++;
	printlvl("DICTIONARYINIT1");
	if(tok == T_RBRACES){
		// epsilon
	} else if(tok == T_COMMA){
		match(T_COMMA);
		match(T_ID);
		match(T_COLON);
		EXPR();
		DICTIONARYINIT1();
	} else {
		printerror();
	}
	level--;
}

void BOOLEAN(){
	level++;
	printlvl("BOOLEAN");
	if(tok == T_TRUE){
		match(T_TRUE);
	} else if(tok == T_FALSE){
		match(T_FALSE);
	} else {
		printerror();
	}
	level--;
}

//
//
//
