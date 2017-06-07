%{
#include <iostream>
#include "instr.h"
#include "literal.h"
#include "statement.h"
#include "lvalue.h"

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

program	: stmtlist	{ onFinish($1); };

stmtlist	: %empty { $$ = CodeTreePtr(new EmptyCodeTree()); }
		| stmt stmtlist { $$ = CodeTreePtr(new StmtList($1, $2)); }
		;

stmt	: "import" T_ID T_ENDL
	| T_ENDL { $$ = CodeTreePtr(new EmptyCodeTree()); }
	| expr T_ENDL { $$ = $1; }
	| assignment T_ENDL
	| functiondef T_ENDL
	| if T_ENDL
	| forloop T_ENDL
	| whileloop T_ENDL
	| indefloop T_ENDL
	| "return" expr T_ENDL { $$ = CodeTreePtr(new ReturnStmt($2)); }
	| "break" T_ENDL
	| "continue" T_ENDL
	| error T_ENDL
	;

functiondef	: "function" T_ID parameters T_ENDL stmtlist "end" { $$ = CodeTreePtr(new FunctionDef($2, $3, $5)); }
            ;

parameters	: %empty { $$ = CodeTreePtr(new EmptyCodeTree()); }
		| "(" ")" { $$ = CodeTreePtr(new EmptyCodeTree()); }
		| "(" paramdecl ")" { $$ = $2; }
		;

paramdecl	: T_ID { $$ = CodeTreePtr(new FunctionParams($1)); }
		| paramdecl "," T_ID { $$ = CodeTreePtr(new FunctionParams($3, $1)); }
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

assignment	: lvalue "=" assignment { $$ = CodeTreePtr(new Assignment($1, $3)); }
		| lvalue "=" condition { $$ = CodeTreePtr(new Assignment($1, $3)); }
		;

expr	: condition { $$ = $1; }
	;

lvalue	: T_ID { $$ = $1; }
	| reference "." T_ID { $$ = CodeTreePtr(new LValue($1, $3, true)); }
	| reference "[" expr "]" { $$ = CodeTreePtr(new LValue($1, $3, false)); }
	;

reference	: lvalue { $$ = $1; }
		| reference "(" ")" { $$ = CodeTreePtr(new FunctionCall($1)); }
		| reference "(" arguments ")" { $$ = CodeTreePtr(new FunctionCall($1, $3)); }
		| reference "(" arguments error ")"
		;

arguments	: arguments "," expr { $$ = CodeTreePtr(new FunctionArgs($3, $1)); }
		| expr { $$ = CodeTreePtr(new FunctionArgs($1)); }
		;

condition	: condition "and" logic { $$ = CodeTreePtr(new BinOp("and", $1, $3)); }
		| condition "or" logic { $$ = CodeTreePtr(new BinOp("or", $1, $3)); }
		| logic { $$ = $1; }
		;

logic	: "not" comparison { $$ = CodeTreePtr(new UnOp("not", $2)); }
	| comparison { $$ = $1; }
	;

comparison	: comparison "==" arithmetic { $$ = CodeTreePtr(new BinOp("eq", $1, $3)); }
		| comparison "!=" arithmetic { $$ = CodeTreePtr(new BinOp("neq", $1, $3)); }
		| comparison "<" arithmetic { $$ = CodeTreePtr(new BinOp("lt", $1, $3)); }
		| comparison ">" arithmetic { $$ = CodeTreePtr(new BinOp("gt", $1, $3)); }
		| comparison "<=" arithmetic { $$ = CodeTreePtr(new BinOp("le", $1, $3)); }
		| comparison ">=" arithmetic { $$ = CodeTreePtr(new BinOp("ge", $1, $3)); }
		| arithmetic { $$ = $1; }
		;

arithmetic	: arithmetic "+" term { $$ = CodeTreePtr(new BinOp("add", $1, $3)); }
		| arithmetic "-" term { $$ = CodeTreePtr(new BinOp("sub", $1, $3)); }
		| term { $$ = $1; }
		;

term	: term "*" factor { $$ = CodeTreePtr(new BinOp("mul", $1, $3)); }
	| term "/" factor { $$ = CodeTreePtr(new BinOp("div", $1, $3)); }
	| factor { $$ = $1; }
	;

factor	: "-" factor { $$ = CodeTreePtr(new UnOp("inv", $2)); }
	| "!" factor { $$ = CodeTreePtr(new UnOp("neg", $2)); }
	| final { $$ = $1; }
	;

final	: "(" expr ")" { $$ = $2; }
	| boolean { $$ = $1; }
	| T_INT { $$ = $1; }
	| T_FLOAT { $$ = $1; }
	| T_STRING { $$ = $1; }
	| object
	| reference { $$ = $1; }
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
