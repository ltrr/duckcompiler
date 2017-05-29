#ifndef DUCK_INSTR_H_
#define DUCK_INSTR_H_

#include <string>
#include <vector>
#include <memory>

struct tuple4 {
	std::string instr;
	std::string addr1, addr2, addr3;

	tuple4(std::string instr, std::string addr1, std::string addr2, std::string addr3) :
		instr(instr), addr1(addr1), addr2(addr2), addr3(addr3) {}
};

struct context {
	std::string hook_addr, break_label, continue_label;

	context(std::string hook_addr, std::string break_label, std::string continue_label) :
		hook_addr(hook_addr), break_label(break_label), continue_label(continue_label) {}
};

typedef std::vector<tuple4> tuple4_vec;

class CodeTree {
	virtual tuple4_vec genCode(context c);
};

typedef std::shared_ptr<CodeTree> CodeTreePtr;

#endif
