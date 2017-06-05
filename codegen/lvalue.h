#ifndef DUCK_LVALUE_H_
#define DUCK_LVALUE_H_

#include "instr.h"

/////////////////////////////
class Identifier : public CodeTree {
public:
	Identifier(std::string name) : name(name) {}

	tuple4_vec genCode(context c);
private:
	std::string name;
};


/////////////////////////////
class LValue : public CodeTree {
public:
	LValue(CodeTreePtr reference, CodeTreePtr index, bool direct)
		: reference(reference), index(index), direct(direct) {}

	tuple4_vec genCode(context c);
private:
	CodeTreePtr reference;
	CodeTreePtr index;
	bool direct;
};


#endif // DUCK_LVALUE_H_
