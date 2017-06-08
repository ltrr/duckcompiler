#ifndef DUCK_ARRAYINIT_H_
#define DUCK_ARRAYINIT_H_

#include "instr.h"

class ArrayInit : public CodeTree{
public:
    ArrayInit(CodeTreePtr ainit, CodeTreePtr expr):
        ainit(ainit), expr(expr) { }
        
    tuple4_vec genCode(context c);

private:
    CodeTreePtr ainit;
    CodeTreePtr expr;
};

#endif

