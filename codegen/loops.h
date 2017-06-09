#include "instr.h"

///////////////
class IndefLoop : public CodeTree {
public:
	IndefLoop(CodeTreePtr midd) : midd(midd) {}

	tuple4_vec genCode(context c);

private:
	CodeTreePtr midd;

};

//////////////
class WhileLoop : public CodeTree{
public:
	WhileLoop(CodeTreePtr cond, CodeTreePtr stmts) : cond(cond), stmts(stmts) {}
	
	tuple4_vec genCode(context c);
	
private:
	CodeTreePtr cond;
	CodeTreePtr stmts;

};
