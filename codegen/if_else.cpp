#include "if_else.h"
#include "instr.h"

// "if" condition "then" T_ENDL stmtlist elseif
//  | "if" condition "then" error T_ENDL stmtlist elseif

// "else" T_ENDL stmtlist "end" { $$ = $3; }
//  | "else" if { $$ = $2; }
//  | "end" { $$ = CodeTreePtr(new EmptyCodeTree()); }

tuple4_vec if_Tree::genCode(context c){

    std::string hook;
    hook = c.hook_addr;

    //condition
    std:: string addr1 = genAddr();
    context c_left = context (addr1, c.break_label, c.continue_label);
    tuple4_vec left_v = left->genCode(c_left);

    //stmtlist
    std:: string addr2 = genAddr();
    context c_midd = context (addr2, c.break_label, c.continue_label);
    tuple4_vec midd_v = midd->genCode(c_midd);


   // else if
    std:: string addr3 = genAddr();
    context c_right = context (addr3, c.break_label, c.continue_label);
    tuple4_vec right_v = right->genCode(c_right);

    // not condition
    std::string addr4 = genAddr();
    tuple4 opnot ("not",addr4, addr1, "");
    left_v.push_back(opnot);

    // ifgoto
    std::string label1 = genLabel();
    tuple4 opifgoto ("ifgoto", addr4, label1, "");
    left_v.push_back(opifgoto);

    // statement list
    left_v.insert (end (left_v), begin(midd_v), end(midd_v));

    //goto
    std::string label2 = genLabel();
    tuple4 opgoto ("goto", label2, "", "");
    left_v.push_back(opgoto);

    // label 1
    tuple4 oplabel1 ("label",label1,"", "");
    left_v.push_back(oplabel1);

    // else if
    left_v.insert (end (left_v), begin(right_v), end(right_v));

    // label 2
    tuple4 oplabel2 ("label", label2,"", "");
    left_v.push_back(oplabel2);

    return left_v;
}
