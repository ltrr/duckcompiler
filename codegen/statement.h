#ifndef DUCK_STATEMENT_H_
#define DUCK_STATEMENT_H_

#include "instr.h"

class StmtList : public CodeTree {
public:
	StmtList(CodeTreePtr stmt, CodeTreePtr stmt_list) :
		stmt(stmt), stmt_list(stmt_list) {}

	tuple4_vec genCode(context c);

private:
    CodeTreePtr stmt;
	CodeTreePtr stmt_list;
};

#endif
