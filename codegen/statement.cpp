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

    tuple4_vec instr { tuple4 ("func", hook, label, "") };

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

    auto hook = genAddr();
    instr.push_back(tuple4("pop", hook, "", ""));

    context ident_subcontext(hook, Mode::Save);
    tuple4_vec ident_instr = this->ident->genCode(ident_subcontext);
    instr.insert(end(instr), begin(ident_instr), end(ident_instr));

    if (next) {
        tuple4_vec next_instr = next->genCode(c);
        instr.insert(end(instr), begin(next_instr), end(next_instr));
    }

    return instr;
}


/////////////////////////////
tuple4_vec FunctionCall::genCode(context c) {

    auto hook = genAddr();
    context ref_subcontext(hook, Mode::Load);
    tuple4_vec ref_instr = this->reference->genCode(ref_subcontext);

    if (args) {
        tuple4_vec args_instr = this->args->genCode(c);
        ref_instr.insert(end(ref_instr), begin(args_instr), end(args_instr));
    }

    ref_instr.push_back( tuple4("call", hook, "", "") );
    if (!c.hook_addr.empty())
        ref_instr.push_back( tuple4("pop", c.hook_addr, "", "") );

    return ref_instr;
}


/////////////////////////////
tuple4_vec FunctionArgs::genCode(context c) {

    tuple4_vec instr;
    if (next) {
        instr = next->genCode(c);
    }

    auto hook = genAddr();

    context expr_subcontext(hook, Mode::Load);
    tuple4_vec expr_instr = this->expr->genCode(expr_subcontext);
    instr.insert(end(instr), begin(expr_instr), end(expr_instr));

    instr.push_back(tuple4("push", hook, "", ""));

    return instr;
}


/////////////////////////////
tuple4_vec ReturnStmt::genCode(context c) {
    auto hook = genAddr();
    context expr_subcontext(hook, Mode::Load);
    tuple4_vec expr_instr = this->expr->genCode(expr_subcontext);

    expr_instr.push_back(tuple4("push", hook, "", ""));
    expr_instr.push_back(tuple4("return", "", "", ""));

    return expr_instr;
}


/////////////////////////////
tuple4_vec Assignment::genCode(context c) {

    auto hook = c.hook_addr;
    if (hook.empty())
        hook = genAddr();

    context expr_subcontext(hook, Mode::Load);
    tuple4_vec expr_instr = this->expr->genCode(expr_subcontext);

    context lvalue_subcontext(hook, Mode::Save);
    tuple4_vec lvalue_instr = this->lvalue->genCode(lvalue_subcontext);

    expr_instr.insert(end(expr_instr), begin(lvalue_instr), end(lvalue_instr));

    return expr_instr;
}
