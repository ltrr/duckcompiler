#include <iostream>
#include "instr.h"


int main() {

  CodeTreePtr left_ptr = CodeTreePtr(new CodeTree());
  CodeTreePtr right_ptr = CodeTreePtr(new CodeTree());

  context c("", "", "");

  CodeTreePtr op1_ptr = CodeTreePtr(new BinOp("add", left_ptr, right_ptr));
  CodeTreePtr op2_ptr = CodeTreePtr(new BinOp("sub", left_ptr, right_ptr));
  CodeTreePtr op3_ptr = CodeTreePtr(new BinOp("mul", op1_ptr, op2_ptr));
  printTuples(std::cout, op3_ptr->genCode(c));
}
