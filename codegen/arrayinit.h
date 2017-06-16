#ifndef DUCK_ARRAYINIT_H_
#define DUCK_ARRAYINIT_H_

#include "instr.h"

class ArrayInit : public CodeTree{
public:
    ArrayInit(CodeTreePtr expr, CodeTreePtr ainit):
        expr(expr), ainit(ainit) { }
    
    ArrayInit(CodeTreePtr expr):
        expr(expr) { this->ainit = NULL; }
    
    tuple4_vec genCode(context c);

private:
    CodeTreePtr expr;
    CodeTreePtr ainit;
};

#endif

