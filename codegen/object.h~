#ifndef DUCK_OBJECT_H_
#define DUCK_OBJECT_H_

#include "instr.h"

class Obj : public CodeTree{
public:
	Obj() : init(new EmptyCodeTree()) { }
	Obj(CodeTreePtr init, std::string tipo) : init(init), tipo(tipo);

	tuple4_vec genCode(context c);

private:
	CodeTreePtr init;	// initarray or initdict
	std::string tipo;	// "array" or "dict"
};

#endif

