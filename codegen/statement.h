#ifndef DUCK_STATEMENT_H_
#define DUCK_STATEMENT_H_

#include "instr.h"


/////////////////////////////
class StmtList : public CodeTree {
public:
	StmtList(CodeTreePtr stmt, CodeTreePtr stmt_list) :
		stmt(stmt), stmt_list(stmt_list) {}

	tuple4_vec genCode(context c);

private:
    CodeTreePtr stmt;
	CodeTreePtr stmt_list;
};


/////////////////////////////
class FunctionDef : public CodeTree {
public:
	FunctionDef(CodeTreePtr name, CodeTreePtr params, CodeTreePtr content) :
		name(name), params(params), content(content) {}

	tuple4_vec genCode(context c);
private:
	CodeTreePtr name;
	CodeTreePtr params;
	CodeTreePtr content;
};


/////////////////////////////
class FunctionParams : public CodeTree {
public:
	FunctionParams(CodeTreePtr ident, CodeTreePtr next) :
		ident(ident), next(next) {}

	FunctionParams(CodeTreePtr ident) :
		ident(ident) {}

	tuple4_vec genCode(context c);
private:
	CodeTreePtr ident;
	CodeTreePtr next;
};


/////////////////////////////
class Identifier : public CodeTree {
public:
	Identifier(std::string name) : name(name) {}

	tuple4_vec genCode(context c);
private:
	std::string name;
};

#endif
