#include "arrayinit.h"
#include "instr.h"
#include <string>

tuple4_vec ArrayInit::genCode(context c){
    //
    tuple4_vec array_code;
    std::string expr_addr = genAddr();
    context expr_context(expr_addr, c.break_label, c.continue_label);
    tuple4_vec expr_code = expr->genCode(expr_context);
    array_code.insert(end(array_code),begin(expr_code),end(expr_code));
    array_code.push_back(tuple4("setindex",c.obj_addr,std::to_string(c.array_index),expr_addr));
    //
    std::string ainit_addr = genAddr();
    context ainit_context(ainit_addr, c.break_label, c.continue_label, c.obj_addr, c.array_index+1);
    tuple4_vec ainit_code = ainit->genCode(ainit_context);
    array_code.insert(end(array_code),begin(ainit_code),end(ainit_code));
    return array_code;
}

