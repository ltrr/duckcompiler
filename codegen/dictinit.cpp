#include "dictinit.h"
#include "instr.h"

tuple4_vec DictInit::genCode(context c){
    tuple4_vec dcode;
    //
    // load ADDR IDENTIFIER # t_addr = T_ID
    //      load t_addr T_ID
    // setindex ADDR ADDR ADDR # t_dict[t_addr] = t_expr_addr   // t_dict must be passed inside the context
    //      setindex t_dict t_addr t_expr
    std::string expr_addr = genAddr();
    std::string id_addr = genAddr();
    std::string dict_addr = c.obj_addr;
    tuple4_vec expr_code = expr->genCode(context(expr_addr,c.break_label,c.continue_label));
    dcode.insert(end(dcode),begin(expr_code),end(expr_code));
    dcode.push_back(tuple4("load",id_addr,t_id->name,""));  // t_id must be initialized as an Identifier
    dcode.push_back(tuple4("setindex",dict_addr,id_addr,expr_addr));
    if(dict_init != NULL){  // dictinit is just one (key : value) pair
        std::string dictinit_addr = genAddr();
        tuple4_vec dictinit_code = dict_init->genCode(context(dictinit_addr,c.break_label,c.continue_label,c.obj_addr));
        dcode.insert(end(dcode),begin(dictinit_code),end(dictinit_code));
    }
    return dcode;
}

