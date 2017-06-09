#include "instr.h"

///////////////
class IndefLoop : public CodeTree {
public:
	IndefLoop(CodeTreePtr midd) : midd(midd) {}

	tuple4_vec genCode(context c);

private:
	CodeTreePtr midd;

};

