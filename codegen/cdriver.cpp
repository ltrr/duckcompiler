#include "cdriver.h"

#include <string>
#include "instr.h"
using std::string;

void dumpC(std::ostream& out, tuple4 instr) {
    out << "\t";

    if (instr.instr == "label") {
        out << instr.addr1 << ":\n";
    }
    else if (instr.instr == "goto") {
        out << "goto " << instr.addr1 << ";\n";
    }
    else if (instr.instr == "push") {
        out << "push(" << instr.addr1 << ");\n";
    }
    else if (instr.instr == "pop") {
        out << "pop(&" << instr.addr1 << ");\n";
    }
    else if (instr.instr == "save") {
        out << "save(" << instr.addr1 << ", \"" << instr.addr2 << "\");\n";
    }
    else if (instr.instr == "load") {
        out << instr.addr1 << " = load(\"" << instr.addr2 << "\");\n";
    }
    else if (instr.instr == "push") {
        out << "pop(&" << instr.addr1 << ");\n";
    }
    else if (instr.instr == "getindex") {
        out << instr.addr1 << " = getindex(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "setindex") {
        out << "setindex(" << instr.addr1 << ", " << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "lit") {
        out << instr.addr1 << " = make_str(\"" << instr.addr2 << "\");\n";
    }
    else if (instr.instr == "liti") {
        out << instr.addr1 << " = make_int(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "litf") {
        out << instr.addr1 << " = make_float(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "nill") {
        out << instr.addr1 << " = make_nill();\n";
    }
    else if (instr.instr == "inv") {
        out << instr.addr1 << " = inv(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "neg") {
        out << instr.addr1 << " = neg(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "not") {
        out << instr.addr1 << " = not(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "add") {
        out << instr.addr1 << " = add(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "sub") {
        out << instr.addr1 << " = sub(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "mul") {
        out << instr.addr1 << " = mul(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "div") {
        out << instr.addr1 << " = div(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "eq") {
        out << instr.addr1 << " = eq(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "neq") {
        out << instr.addr1 << " = neq(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "lt") {
        out << instr.addr1 << " = lt(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "le") {
        out << instr.addr1 << " = le(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "gt") {
        out << instr.addr1 << " = gt(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "ge") {
        out << instr.addr1 << " = ge(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "and") {
        out << instr.addr1 << " = and(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "or") {
        out << instr.addr1 << " = or(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "call") {
        out << "call(" << instr.addr1 << ");\n";
    }
    else if (instr.instr == "return") {
        out << "return 0;\n";
    }
    else {
        out << "...;\n";
    }
}

void outputCCode(std::ostream& out, tuple4_vec& main_program) {

    for (auto& kv : function_defs) {
        out << "int " << kv.first << "() {\n";
        out << "\traise_scope();\n";
        for (tuple4& instr : kv.second) {
            dumpC(out, instr);
        }
        out << "\tdrop_scope();\n";
        out << "}\n";
    }

    out << "int main() {\n";
    out << "\tinit();\n";
    for (tuple4& instr : main_program) {
        dumpC(out, instr);
    }
    out << "}\n";

}
