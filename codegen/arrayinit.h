#ifndef DUCK_ARRAYINIT_H_
#define DUCK_ARRAYINIT_H_

#include "instr.h"

class ArrayInit : public CodeTree{
public:
    ArrayInit(CodeTreePtr expr, CodeTreePtr ainit):
        expr(expr), ainit(ainit) { }
    
    tuple4_vec genCode(context c);

private:
    CodeTreePtr expr;
    CodeTreePtr ainit;
};

#endif

