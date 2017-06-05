#include "lvalue.h"
#include "instr.h"

tuple4_vec Identifier::genCode(context c) {
    if (c.mode == Mode::Load) {
        return { tuple4("load", c.hook_addr, this->name, "") };
    }
    else if (c.mode == Mode::Save) {
        return { tuple4("save", c.hook_addr, this->name, "") };
    } else {
        return { tuple4("lit", c.hook_addr, this->name, "") };
    }
}


tuple4_vec LValue::genCode(context c) {

    tuple4_vec instr;

    auto hook1 = genAddr();
    context ref_subcontext(hook1, Mode::Load);
    tuple4_vec ref_instr = this->reference->genCode(ref_subcontext);
    instr.insert(end(instr), begin(ref_instr), end(ref_instr));

    auto hook2 = genAddr();
    context index_subcontext;
    if (direct)
        index_subcontext = context(hook2, Mode::Lit);
    else
        index_subcontext = context(hook2, Mode::Load);
    tuple4_vec index_instr = this->index->genCode(index_subcontext);
    instr.insert(end(instr), begin(index_instr), end(index_instr));

    if (c.mode == Mode::Save)
        instr.push_back( tuple4("setindex", hook1, hook2, c.hook_addr) );
    else if (c.mode == Mode::Load && !c.hook_addr.empty())
        instr.push_back( tuple4("getindex", c.hook_addr, hook1, hook2) );

    return instr;
}
