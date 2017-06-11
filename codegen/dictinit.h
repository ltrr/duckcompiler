#ifndef DUCK_DICTINIT_H_
#define DUCK_DICTINIT_H_

#include "instr.h"

class DictInit : public CodeTree{
public:
    DictInit(CodeTreePtr t_id, CodeTreePtr expr, CodeTreePtr dict_init) : 
        t_id(t_id), expr(expr), dict_init(dict_init);
    DictInit(CodeTreePtr t_id, CodeTreePtr expr) :
        t_id(t_id), expr(expr), dict_init(NULL);
    tuple4_vec genCode(context c);
private:
    CodeTreePtr t_id;
    CodeTreePtr expr;
    CodeTreePtr dict_init;
};

#endif

