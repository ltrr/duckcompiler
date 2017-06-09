#include <iostream>
#include <map>
#include <string>
#include "instr.h"
#include "literal.h"
#include "cdriver.h"

int yyparse();

std::map<std::string, tuple4_vec> function_defs;

void onFinish(CodeTreePtr program) {
    context c;
    tuple4_vec code = program->genCode(c);

    for (auto kv : function_defs) {
        std::cout << "::::: " << kv.first << '\n';
        printTuples(std::cout, kv.second);
        std::cout << std::endl;
    }

    std::cout << "::::: main\n";
    printTuples(std::cout, code);

    std::cout << "\n=============\n\n";

    outputCCode(std::cout, code);
}

int main() {
    yyparse();
}
