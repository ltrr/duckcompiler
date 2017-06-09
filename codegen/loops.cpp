#include "loops.h"
#include "instr.h"
/////////////////////////

// iterate 'stmts' loop
tuple4_vec IndefLoop::genCode(context c){

	
	//vetor
	std::string addr2 = genAddr();
	context initial = context (addr2, c.break_label, c.continue_label);
	tuple4_vec indefloop; 
	
	//Label 
	std::string label1 = genLabel();
	tuple4 oplabel1("label", label1,"","");
	indefloop.push_back(oplabel1);
	
	//stmts
	std::string addr1 = genAddr();
	context c_midd = context(addr1, c.break_label, c.continue_label);
	tuple4_vec middv = midd->genCode(c_midd);
	indefloop.insert(end(indefloop), begin(middv), end(middv));
	
	//Goto 
	tuple4 opgoto("goto",label1,"", "");
	indefloop.push_back(opgoto);

	//Label de saida de um brake
	std::string label2 = genLabel();
	tuple4 oplabel2("label",label2,"","");
	indefloop.push_back(oplabel2);

	return indefloop;
}

