#ifndef DUCK_INSTR_H_
#define DUCK_INSTR_H_

#include <iostream>
#include <string>
#include <vector>
#include <memory>


/////////////////////////////
struct tuple4 {
	std::string instr;
	std::string addr1, addr2, addr3;

	tuple4() : instr(""), addr1(""), addr2(""), addr3("") {}

	tuple4(std::string instr, std::string addr1, std::string addr2, std::string addr3) :
		instr(instr), addr1(addr1), addr2(addr2), addr3(addr3) {}
};

typedef std::vector<tuple4> tuple4_vec;


/////////////////////////////
struct context {
	std::string hook_addr, break_label, continue_label;

	context(std::string hook_addr, std::string break_label, std::string continue_label) :
		hook_addr(hook_addr), break_label(break_label), continue_label(continue_label) {}
};


/////////////////////////////
class CodeTree {
public:
	virtual tuple4_vec genCode(context c);
};

typedef std::shared_ptr<CodeTree> CodeTreePtr;


/////////////////////////////
class BinOp : public CodeTree {
public:
	BinOp(std::string instr, CodeTreePtr left, CodeTreePtr right) :
		instr(instr), left(left), right(right) {}

	tuple4_vec genCode(context c);

private:
	std::string instr;
	CodeTreePtr left;
	CodeTreePtr right;
};


/////////////////////////////
std::string genAddr();
std::string genLabel();
void printTuples(std::ostream& os, const tuple4_vec& v);


#endif // DUCK_INSTR_H_
