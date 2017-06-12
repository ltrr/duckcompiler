
#include "instr.h"

/////////////// Indef Loop
class IndefLoop : public CodeTree {

public:

	IndefLoop(CodeTreePtr midd) : 
		midd(midd) {}


	tuple4_vec genCode(context c);

private:
	CodeTreePtr midd;

};

////////////// While Loop
class WhileLoop : public CodeTree{

public:

	WhileLoop(CodeTreePtr cond, CodeTreePtr stmts):
		cond(cond), stmts(stmts) {}
		
		
		tuple4_vec genCode(context c);

private:
	CodeTreePtr cond;
	CodeTreePtr stmts;

};

///////////////For Loop 
//"for" T_ID "=" arithmetic "to" arithmetic "do" T_ENDL stmtlist "loop"
class ForLoop : public CodeTree{

public:
	ForLoop(CodeTreePtr id, CodeTreePtr art1, CodeTreePtr art2, CodeTreePtr stmts) :
	id(id), art1(art1), art2(art2), stmts(stmts){}
	
	tuple4_vec genCode(context c);
	
private:
	CodeTreePtr	id;
	CodeTreePtr	art1;
	CodeTreePtr	art2;
	CodeTreePtr	stmts;
};
