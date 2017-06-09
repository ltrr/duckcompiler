
#include "instr.h"

///////////////
class IndefLoop : public CodeTree {
public:
<<<<<<< HEAD
	IndefLoop(CodeTreePtr midd) : midd(midd) {}
=======
	IndefLoop(CodeTreePtr stmt, CodeTreePtr stmt_list) : 
		stmt(stmt), stmt_list(stmt_list) {}
>>>>>>> c602f628b3975df7a0240e8a8e0b6a8685a4dbb8

	tuple4_vec genCode(context c);

private:
<<<<<<< HEAD
	CodeTreePtr midd;

};

//////////////
=======
	CodeTreePtr stmt_list;

};

