#include <iostream>
#include "instr.h"
#include "literal.h"

int yyparse();

void onFinish(CodeTreePtr program) {
    context c;
    printTuples(std::cout, program->genCode(c));
}

int main() {
    yyparse();
}
