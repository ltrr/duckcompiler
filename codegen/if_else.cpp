#include "if_else.h"
#include "instr.h"

// "if" condition "then" T_ENDL stmtlist elseif
//  | "if" condition "then" error T_ENDL stmtlist elseif
tuple4_vec if_Tree::genCode(context c){

    std::string hook;
    if (c.hook_addr.empty())
        hook = genAddr();
    else
        hook = c.hook_addr;

    //condition
    std:: string addr1 = genAddr();
    context c_left = context (addr1, c.break_label, c.continue_label);
    tuple4_vec left_v = left->genCode(c_left);

    // not condition
    std::string addr4 = genAddr();
    tuple4 opnot ("not",addr4, addr1, "");
    left_v.push_back(opnot);

    // ifgoto
    std::string addr5 = genAddr();
    tuple4 opifgoto ("ifgoto","",addr4, addr5);
    left_v.push_back(opifgoto);

    //stmtlist
    std:: string addr2 = genAddr();
    context c_midd = context (addr2, c.break_label, c.continue_label);
    tuple4_vec midd_v = midd->genCode(c_midd);
    //
    left_v.insert (end (left_v), begin(midd_v), end(midd_v));
    
    // label
    tuple4 oplabel ("label","", addr5, "");
    left_v.push_back(oplabel);

    //elsif
    std:: string addr3 = genAddr();
    context c_right = context (addr3, c.break_label, c.continue_label);
    tuple4_vec right_v = right->genCode(c_right);

    //
    left_v.insert (end (left_v), begin(right_v), end(right_v));

    return left_v;
}

