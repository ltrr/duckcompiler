#include "loops.h"

/////////////////////////

// iterate 'stmts' loop
tuple4_vec IndefLoop::genCode(context c){
	auto cont = genLabel();
	auto brak = genLabel();
	//stmts
	std::string addr1 = genAddr();
	context c_left = context(addr1, c.break_label, c.continue_label);
	tuple4_vec left_v = left->genConde(c_left);

}
