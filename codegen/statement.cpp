#include "statement.h"

/////////////////////////////
tuple4_vec StmtList::genCode(context c) {
    tuple4_vec instr1 = this->stmt->genCode(c);
    tuple4_vec instr2 = this->stmt_list->genCode(c);
    instr1.insert(end(instr1), begin(instr2), end(instr2));
    return instr1;
}
