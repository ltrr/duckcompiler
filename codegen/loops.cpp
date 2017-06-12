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

	return indefloop;
}
///////////////////

//"while" condition "do" T_ENDL stmtlist "loop"
tuple4_vec WhileLoop::genCode(context c){
//Condition
	std::string addr1 = genAddr();
	context initial = context (addr1, c.break_label, c.continue_label);
	tuple4_vec whileloop = cond->genCode(initial);
		
//Label Entrada do loop
	std::string label1 = genLabel();
	tuple4 oplabel1("label", label1, "","");
	whileloop.push_back(oplabel1);
	
//NotCond
	std::string addr2 = genAddr();
	tuple4 condnot("not", addr1, addr2, "");
	whileloop.push_back(condnot);
	
//IfGoto
	std::string label2 = genLabel();
    tuple4 opifgoto ("ifgoto", addr2, label2, "");
    whileloop.push_back(opifgoto);

//Stmts
	std::string addr3 = genAddr();
	context c_midd = context(addr3, c.break_label, c.continue_label);
	tuple4_vec stmtv = stmts->genCode(c_midd);
	whileloop.insert(end(whileloop), begin(stmtv), end(stmtv));
	
//Goto Começo do loop
	tuple4 opgoto("goto", label1,"","");
	whileloop.push_back(opgoto);
	
//Label Saida do Loop
	tuple4 oplabel2("label", label2 , "", "");
	whileloop.push_back(oplabel2);
	
	return whileloop;
}
////////////////
//forloop	: "for" T_ID "=" arithmetic "to" arithmetic "do" T_ENDL stmtlist "loop"
tuple4_vec ForLoop::genCode(context c){
//T_ID
	std::string addr1 = genAddr();
	context initial = context(addr1, c.break_label, c.continue_label);
	tuple4_vec forloop = id->genCode(initial);

//arithmetic1
	std::string addr2 = genAddr();
	context dois = context(addr2,c.break_label, c.continue_label);
	tuple4_vec arit1 = art1->genCode(dois);
	forloop.insert(end(forloop),begin(arit1),end(arit1));
	
//arithmetic2
	std::string addr3 = genAddr();
	context tres = context(addr3,c.break_label, c.continue_label);
	tuple4_vec arit2 = art2->genCode(tres);
	forloop.insert(end(forloop),begin(arit2),end(arit2));

//Label Entrada no Loop 
	std::string label1 = genLabel();
	tuple4 oplabel1("label", label1, "","");
	forloop.push_back(oplabel1);

//Comparativo dos aritmeticos
	std::string addr4  = genAddr();
	tuple4 comp("eq", addr4, addr2, addr3);
	forloop.push_back(comp);

//IfGoto
	std::string label2 = genLabel();
	tuple4 opifgoto("ifgoto", addr4, label2, "");
	forloop.push_back(opifgoto);
	
//Stmts
	std::string addr5 = genAddr();
	context c_stmts = context(addr5, c.break_label, c.continue_label);
	tuple4_vec stmtv = stmts->genCode(c_stmts);
	forloop.insert(end(forloop), begin(stmtv), end(stmtv));
	
//incr
	tuple4 incr("add",addr2,addr2,"1");
	forloop.push_back(incr);

//Goto L1
    tuple4 opgoto ("goto",label1,"", "");
    forloop.push_back(opgoto);
	
//Label de saida
	tuple4 oplabel2("label",label2, "","");
	forloop.push_back(oplabel2);
	
	
	return forloop;
}






