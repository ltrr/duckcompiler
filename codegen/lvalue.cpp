#include "lvalue.h"
#include "instr.h"

tuple4_vec Identifier::genCode(context c) {
    if (c.mode == Mode::Load) {
        return { tuple4("load", c.hook_addr, this->name, "") };
    }
    else {
        return { tuple4("save", c.hook_addr, this->name, "") };
    }
}
