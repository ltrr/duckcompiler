%{
#include <iostream>

#include "stringtree.h"

int yylex();
void yyerror(const char*);

extern int line; 
extern int column;

std::ostream& pprint(std::ostream& os, const StringTree& tree, int level) {
	for (int i = 0; i < level; i++) {
		os << " ";
	}
	os << tree.value << std::endl;
	for (auto child : tree.children) {
		pprint(os, child, level + 1);
	}
	return os;
}

std::ostream& operator<<(std::ostream& os, const StringTree& tree) {
	return pprint(os, tree, 0);
}

bool has_error = false;
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

program	: stmtlist { $$ = StringTree("program", { $1 });
		     if (!has_error) std::cout << $$; }
	;

stmtlist	: %empty { $$ = StringTree("stmtlist"); }
		| stmt stmtlist { $$ = StringTree("stmtlist", { $1, $2 }); }
		;

stmt	: "import" T_ID T_ENDL { $$ = StringTree("stmt", { $1, $2, $3 }); }
	| T_ENDL { $$ = StringTree("stmt", { $1 }); }
	| expr T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| assignment T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| functiondef T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| if T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| forloop T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| whileloop T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| indefloop T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| "return" expr T_ENDL { $$ = StringTree("stmt", { $1, $2, $3 }); }
	| "break" T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| "continue" T_ENDL { $$ = StringTree("stmt", { $1, $2 }); }
	| error T_ENDL
	;

functiondef	: "function" T_ID parameters T_ENDL stmtlist "end"
                    { $$ = StringTree("functiondef", { $1, $2, $3, $4, $5, $6 }); } ;

parameters	: %empty { $$ = StringTree("parameters"); }
		| "(" ")" { $$ = StringTree("parameters", { $1, $2 }); }
		| "(" paramdecl ")" { $$ = StringTree("parameters", { $1, $2, $3 }); }
		;

paramdecl	: T_ID { $$ = StringTree("paramdecl", { $1 }); }
		| paramdecl "," T_ID { $$ = StringTree("paramdecl", { $1, $2, $3 }); }
		;

if	: "if" condition "then" T_ENDL stmtlist elseif
	   { $$ = StringTree("if", { $1, $2, $3, $4, $5, $6 }); }
	| "if" condition "then" error T_ENDL stmtlist elseif
	;

elseif	: "else" T_ENDL stmtlist "end" { $$ = StringTree("elseif", { $1, $2, $3, $4 }); }
	| "else" if { $$ = StringTree("elseif", { $1, $2 }); }
	| "end" { $$ = StringTree("elseif", { $1 }); }
	;

forloop	: "for" T_ID "=" arithmetic "to" arithmetic "do" T_ENDL stmtlist "loop" 
  	  { $$ = StringTree("forloop", { $1, $2, $3, $4, $5, $6, $7, $8, $9, $10 }); }
	| "for" T_ID "=" arithmetic "to" arithmetic "do" error T_ENDL stmtlist "loop" 
	;

whileloop	: "while" condition "do" T_ENDL stmtlist "loop" 
		  { $$ = StringTree("whileloop", { $1, $2, $3, $4, $5, $6 }); }
		| "while" condition "do" error T_ENDL stmtlist "loop" 
		;

indefloop	: "iterate" T_ENDL stmtlist "loop" 
		  { $$ = StringTree("indefloop", { $1, $2, $3, $4 }); }
		;

assignment	: lvalue "=" assignment { $$ = StringTree("assignment", { $1, $2, $3 }); }
		| lvalue "=" condition { $$ = StringTree("assignment", { $1, $2, $3 }); }
		;

expr	: condition { $$ = StringTree("expr", { $1 }); }
	;

lvalue	: T_ID { $$ = StringTree("lvalue", { $1 }); }
	| reference "." T_ID { $$ = StringTree("lvalue", { $1, $2, $3 }); }
	| reference "[" expr "]" { $$ = StringTree("lvalue", { $1, $2, $3, $4 }); }
	;

reference	: lvalue { $$ = StringTree("reference", { $1 }); }
		| reference "(" ")" { $$ = StringTree("reference", { $1, $2, $3 }); }
		| reference "(" arguments ")" { $$ = StringTree("reference", { $1, $2, $3, $4 }); }
		| reference "(" arguments error ")"
		;

arguments	: arguments "," expr { $$ = StringTree("arguments", { $1, $2, $3 }); }
		| expr { $$ = StringTree("arguments", { $1 }); }
		;

condition	: condition "and" logic { $$ = StringTree("condition", { $1, $2, $3 }); }
		| condition "or" logic { $$ = StringTree("condition", { $1, $2, $3 }); }
		| logic { $$ = StringTree("condition", { $1 }); }
		;

logic	: "not" comparison { $$ = StringTree("logic", { $1, $2 }); }
	| comparison { $$ = StringTree("logic", { $1 }); }
	;

comparison	: comparison "==" arithmetic { $$ = StringTree("comparison", { $1, $2, $3 }); }
		| comparison "!=" arithmetic { $$ = StringTree("comparison", { $1, $2, $3 }); }
		| comparison "<" arithmetic { $$ = StringTree("comparison", { $1, $2, $3 }); }
		| comparison ">" arithmetic { $$ = StringTree("comparison", { $1, $2, $3 }); }
		| comparison "<=" arithmetic { $$ = StringTree("comparison", { $1, $2, $3 }); }
		| comparison ">=" arithmetic { $$ = StringTree("comparison", { $1, $2, $3 }); }
		| arithmetic { $$ = StringTree("comparison", { $1 }); }
		;

arithmetic	: arithmetic "+" term { $$ = StringTree("arithmetic", { $1, $2, $3 }); }
		| arithmetic "-" term { $$ = StringTree("arithmetic", { $1, $2, $3 }); }
		| term { $$ = StringTree("arithmetic", { $1 }); }
		;

term	: term "*" factor { $$ = StringTree("term", { $1, $2, $3 }); }
	| term "/" factor { $$ = StringTree("term", { $1, $2, $3 }); }
	| factor { $$ = StringTree("term", { $1 }); }
	;

factor	: "-" factor { $$ = StringTree("factor", { $1, $2 }); }
	| "!" factor { $$ = StringTree("factor", { $1, $2 }); }
	| final { $$ = StringTree("factor", { $1 }); }
	;

final	: "(" expr ")" { $$ = StringTree("final", { $1, $2, $3 }); }	
	| boolean { $$ = StringTree("final", { $1 }); }
	| T_INT { $$ = StringTree("final", { $1 }); }
	| T_FLOAT { $$ = StringTree("final", { $1 }); }
	| T_STRING { $$ = StringTree("final", { $1 }); }
	| object { $$ = StringTree("final", { $1 }); }
	| reference { $$ = StringTree("final", { $1 }); }
	;

object	: "[" "]" { $$ = StringTree("object", { $1, $2 }); }
	| "[" arrayinit "]" { $$ = StringTree("object", { $1, $2, $3 }); }
	| "[" dictinit "]" { $$ = StringTree("object", { $1, $2, $3 }); }
	| "[" arrayinit error "]"
	| "[" dictinit error "]"
	;

arrayinit	: arrayinit "," expr { $$ = StringTree("arrayinit", { $1, $2, $3 }); }
		| expr { $$ = StringTree("arrayinit", { $1 }); }
		;

dictinit	: dictinit "," T_ID ":" expr { $$ = StringTree("dictinit", { $1, $2, $3, $4, $5 }); }
		| T_ID ":" expr { $$ = StringTree("dictinit", { $1, $2, $3 }); }
		;

boolean : "true" { $$ = StringTree("boolean", { $1 }); }
	| "false" { $$ = StringTree("boolean", { $1 }); }
	; 

%%

int main()
{
	yyparse();
	return 0;
}

void yyerror(const char *s)
{
	has_error = true;
	std::cerr << s << std::endl;
	std::cerr << "on line " << line
                  << ", column " << column
                  << std::endl;
}
