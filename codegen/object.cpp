#include "object.h"
#include "instr.h"

tuple4_vec Obj::genCode(context c){
	tuple4_vec obcode;
	std::string hook;
	if (c.hook_addr.empty())
		hook = genAddr();
	else
		hook = c.hook_addr;
	std::string addr = genAddr();
	context c_init = context(addr,c.break_label,c.continue_label);
	c_init.obj_addr = hook;
	if(tipo.compare("array") == 0){
		c_init.array_index = 0;
	}

	if(tipo.compare("array") != 0 && tipo.compare("dict") != 0){
		obcode.push_back(tuple4("lito",hook,"",""));
	} else {
		tuple4_vec acode = init->genCode(c_init);
		obcode.insert(end(obcode), begin(acode), end(acode));
	}

	return obcode;
}

