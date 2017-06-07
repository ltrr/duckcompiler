#ifndef DUCK_LOOP_H_
#define DUCK_LOOP_H_

#include "instr.h"
#include "statement.h"

///////////////
class IndefLoop : public CodeTree {
public:
	IndefLoop(CodeTreePtr stmt, CodeTreePtr stmt_list) : 
		stmt(stmt), stmt_list(stmt_list) {}

	tuple4_vec genCode(context c);

private:
	CodeTreePtr stmt_list;

};

#endif
