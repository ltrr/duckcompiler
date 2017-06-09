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
	
	if(modo.compare("array") == 0){
		context c_init = context(addr,c.break_label,c.continue_label);
		tuple4_vec acode = init->genCode(c_init);
		obcode.insert(end(obcode), begin(acode), end(acode));
		//
	} else if(modo.compare("dict") == 0){
		
	} else {
		obcode.push_back(tuple4("lito",addr,"",""));
	}
	return obcode;
}

