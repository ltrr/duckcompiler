#include "instr.h"

/////////////////////////////
tuple4_vec CodeTree::genCode(context c) {
	return tuple4_vec { tuple4("...", "", "", "") };
}


/////////////////////////////
tuple4_vec EmptyCodeTree::genCode(context c) {
	return tuple4_vec();
}


/////////////////////////////
tuple4_vec BinOp::genCode(context c) {
  std::string hook;
  if (c.hook_addr.empty())
    hook = genAddr();
  else
    hook = c.hook_addr;

  std::string addr1 = genAddr();
  context c_left = context(addr1, c.break_label, c.continue_label);
  tuple4_vec left_v = left->genCode(c_left);

  std::string addr2 = genAddr();
  context c_right = context(addr2, c.break_label, c.continue_label);
  tuple4_vec right_v = right->genCode(c_right);

  left_v.insert(end(left_v), begin(right_v), end(right_v));

  tuple4 op (this->instr, hook, addr1, addr2);
  left_v.push_back(op);

  return left_v;
}


/////////////////////////////
int last_addr = 0;
std::string genAddr() {
	last_addr += 1;
	return "t" + std::to_string(last_addr);
}

int last_label = 0;
std::string genLabel() {
	last_label += 1;
	return "L" + std::to_string(last_label);
}

void printTuples(std::ostream& os, const tuple4_vec& v) {
	for (tuple4 t : v) {
    os << t.instr << " "
       << t.addr1 << " "
       << t.addr2 << " "
       << t.addr3 << std::endl;
  }
}
