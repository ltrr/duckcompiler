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


#endif // DUCK_LVALUE_H_
