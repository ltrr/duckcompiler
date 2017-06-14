#include "loops.h"
#include "instr.h"
/////////////////////////
//BREAK BRAKE BREIKE
tuple4_vec Break::genCode(context c){
	//Goto Label
	tuple4_vec breaq;
	tuple4 opgoto("goto",c.break_label,"","");
	breaq.push_back(opgoto);
	return breaq;
}

//CONTINUE
tuple4_vec Continue::genCode(context c){
	//Goto Label
	tuple4_vec cont;
	tuple4 opgoto("goto",c.continue_label, "","");
	cont.push_back(opgoto);
	return cont;
}

// iterate 'stmts' loop
tuple4_vec IndefLoop::genCode(context c){
	//vetor
	std::string addr2 = genAddr();
	context initial = context (addr2, c.break_label, c.continue_label);
	tuple4_vec indefloop;
	//Label de começo de loop
	std::string labelcom = genLabel();
	tuple4 oplabelcom("label",labelcom,"","");
	indefloop.push_back(oplabelcom);
	//Label de fim de loop
	std::string labelfim = genLabel();
	tuple4 oplabelfim("label",labelfim,"","");
	//stmts
	std::string addr1 = genAddr();
	context c_midd = context(addr1, labelfim, labelcom);
	tuple4_vec middv = midd->genCode(c_midd);
	indefloop.insert(end(indefloop), begin(middv), end(middv));
	//Goto 
	tuple4 opgoto("goto",labelcom,"", "");
	indefloop.push_back(opgoto);
	//pusha a label
	indefloop.push_back(oplabelfim);
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
	tuple4 condnot("not", addr2, addr1, "");
	whileloop.push_back(condnot);
	
//IfGoto
	std::string label2 = genLabel();
    tuple4 opifgoto ("ifgoto", addr2, label2, "");
    whileloop.push_back(opifgoto);

//Stmts
	std::string addr3 = genAddr();
	context c_midd = context(addr3, label2, label1);
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
//Label do incremento, para o CONTINUE
	std::string label3 = genLabel();
	tuple4 oplabel3("label",label3,"","");
	
//Stmts
	std::string addr5 = genAddr();
	context c_stmts = context(addr5, label2, label3);
	tuple4_vec stmtv = stmts->genCode(c_stmts);
	forloop.insert(end(forloop), begin(stmtv), end(stmtv));
//label do incremento vai aqui
	forloop.push_back(oplabel3);
//incr
	std::string addrI = genAddr(); 
	tuple4 liti("liti",addrI,"1","");
	forloop.push_back(liti);
	tuple4 incr("add",addr2,addr2,addrI);
	forloop.push_back(incr);

//Goto L1
    tuple4 opgoto ("goto",label1,"", "");
    forloop.push_back(opgoto);
	
//Label de saida
	tuple4 oplabel2("label",label2, "","");
	forloop.push_back(oplabel2);
	
	
	return forloop;
}






