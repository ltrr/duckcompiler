#include "statement.h"

/////////////////////////////
tuple4_vec StmtList::genCode(context c) {
    tuple4_vec instr1 = this->stmt->genCode(c);
    tuple4_vec instr2 = this->stmt_list->genCode(c);
    instr1.insert(end(instr1), begin(instr2), end(instr2));
    return instr1;
}


/////////////////////////////
tuple4_vec FunctionDef::genCode(context c) {

    auto label = genLabel();
    auto hook = genAddr();

    tuple4_vec instr { tuple4 ("litf", hook, label, "") };

    context name_subcontext(hook, Mode::Save);
    tuple4_vec name_instr = this->name->genCode(name_subcontext);
    instr.insert(end(instr), begin(name_instr), end(name_instr));


    context content_subcontext("", "", "");
    tuple4_vec params_code = this->params->genCode(content_subcontext);
    tuple4_vec content_code = this->content->genCode(content_subcontext);
    params_code.insert(end(params_code), begin(content_code), end(content_code));
    function_defs[label] = params_code;

    return instr;
}


/////////////////////////////
tuple4_vec FunctionParams::genCode(context c) {

    tuple4_vec instr;
    if (next) {
        instr = next->genCode(c);
    }

    auto hook = genAddr();
    instr.push_back(tuple4("pop", hook, "", ""));

    context ident_subcontext(hook, Mode::Save);
    tuple4_vec ident_instr = this->ident->genCode(ident_subcontext);
    instr.insert(end(instr), begin(ident_instr), end(ident_instr));

    return instr;
}


/////////////////////////////
tuple4_vec Identifier::genCode(context c) {
    if (c.mode == Mode::Load) {
        return { tuple4("load", c.hook_addr, this->name, "") };
    }
    else {
        return { tuple4("save", c.hook_addr, this->name, "") };
    }
}
