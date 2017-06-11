#ifndef DUCK_OBJECT_H_
#define DUCK_OBJECT_H_

#include "instr.h"

class Obj : public CodeTree{
public:
	Obj(){
		init = new EmptyCodeTree();
		// modo = "";
	}
	// Obj(CodeTreePtr init, std::string modo) : init(init), modo(modo);

	tuple4_vec genCode(context c);

private:
	CodeTreePtr init;	// initarray or initdict
	// std::string modo;	// "array" or "dict"
};

#endif

