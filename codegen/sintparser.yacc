%{
#include <iostream>
#include "instr.h"
#include "literal.h"

int yylex();
void yyerror(const char*);

extern int line;
extern int column;

bool has_error = false;

#define YYSTYPE CodeTreePtr
%}

%token T_IMPORT "import"
%token T_RETURN "return"
%token T_BREAK "break"
%token T_CONTINUE "continue"
%token T_FUNCTION "function"
%token T_END "end"
%token T_IF "if"
%token T_THEN "then"
%token T_ELSE "else"
%token T_FOR "for"
%token T_TO "to"
%token T_LOOP "loop"
%token T_WHILE "while"
%token T_DO "do"
%token T_ITERATE "iterate"
%token T_AND "and"
%token T_OR "or"
%token T_NOT "not"
%token T_LPARENS "("
%token T_RPARENS ")"
%token T_ASSIGN "="
%token T_DOT "."
%token T_LBRACKET "["
%token T_RBRACKET "]"
%token T_EQ "=="
%token T_NEQ "!="
%token T_LT "<"
%token T_GT ">"
%token T_LE "<="
%token T_GE ">="
%token T_PLUS "+"
%token T_MINUS "-"
%token T_TIMES "*"
%token T_DIV "/"
%token T_NEG "!"
%token T_COMMA ","
%token T_COLON ":"
%token T_NILL "nill"
%token T_TRUE "true"
%token T_FALSE "false"
%token T_INT "int"
%token T_FLOAT "float"
%token T_STRING "string"
%token T_ENDL "endline"
%token T_ID "identifier"

%define parse.error verbose

%%

program	: stmtlist;

stmtlist	: %empty
		| stmt stmtlist
		;

stmt	: "import" T_ID T_ENDL
	| T_ENDL
	| expr T_ENDL
	| assignment T_ENDL
	| functiondef T_ENDL
	| if T_ENDL
	| forloop T_ENDL
	| whileloop T_ENDL
	| indefloop T_ENDL
	| "return" expr T_ENDL
	| "break" T_ENDL
	| "continue" T_ENDL
	| error T_ENDL
	;

functiondef	: "function" T_ID parameters T_ENDL stmtlist "end"
            ;

parameters	: %empty
		| "(" ")"
		| "(" paramdecl ")"
		;

paramdecl	: T_ID
		| paramdecl "," T_ID
		;

if	: "if" condition "then" T_ENDL stmtlist elseif
	| "if" condition "then" error T_ENDL stmtlist elseif
	;

elseif	: "else" T_ENDL stmtlist "end"
	| "else" if
	| "end"
	;

forloop	: "for" T_ID "=" arithmetic "to" arithmetic "do" T_ENDL stmtlist "loop"
		| "for" T_ID "=" arithmetic "to" arithmetic "do" error T_ENDL stmtlist "loop"
		;

whileloop	: "while" condition "do" T_ENDL stmtlist "loop"
			| "while" condition "do" error T_ENDL stmtlist "loop"
			;

indefloop	: "iterate" T_ENDL stmtlist "loop"
			;

assignment	: lvalue "=" assignment
		| lvalue "=" condition
		;

expr	: condition
	;

lvalue	: T_ID
	| reference "." T_ID
	| reference "[" expr "]"
	;

reference	: lvalue
		| reference "(" ")"
		| reference "(" arguments ")"
		| reference "(" arguments error ")"
		;

arguments	: arguments "," expr
		| expr
		;

condition	: condition "and" logic
		| condition "or" logic
		| logic
		;

logic	: "not" comparison
	| comparison
	;

comparison	: comparison "==" arithmetic
		| comparison "!=" arithmetic
		| comparison "<" arithmetic
		| comparison ">" arithmetic
		| comparison "<=" arithmetic
		| comparison ">=" arithmetic
		| arithmetic
		;

arithmetic	: arithmetic "+" term
		| arithmetic "-" term
		| term
		;

term	: term "*" factor
	| term "/" factor
	| factor
	;

factor	: "-" factor
	| "!" factor
	| final
	;

final	: "(" expr ")"
	| boolean
	| T_INT
	| T_FLOAT
	| T_STRING
	| object
	| reference
	;

object	: "[" "]"
	| "[" arrayinit "]"
	| "[" dictinit "]"
	| "[" arrayinit error "]"
	| "[" dictinit error "]"
	;

arrayinit	: arrayinit "," expr
		| expr
		;

dictinit	: dictinit "," T_ID ":" expr
		| T_ID ":" expr
		;

boolean : "true"
	| "false"
	;

%%

void yyerror(const char *s)
{
	has_error = true;
	std::cerr << s << std::endl;
	std::cerr << "on line " << line
                  << ", column " << column
                  << std::endl;
}
