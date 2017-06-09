#include "cdriver.h"

#include <string>
#include <vector>
#include <set>
#include "instr.h"
using std::string;

string prelude = R"PRELUDE(
typedef struct {
    int id;
} duckref_t;

int to_bool(duckref_t ref) {
    return 0;
}

void push(duckref_t ref) {}

duckref_t pop(void) {
    duckref_t ref;
    return ref;
}

void save(duckref_t ref, const char *name) {

}

duckref_t load(const char *name) {

}

duckref_t getindex(duckref_t ref, duckref_t index) {

}

void setindex(duckref_t ref, duckref_t index, duckref_t value) {

}

duckref_t make_str(const char* str) {

}

duckref_t make_int(int x) {

}

duckref_t make_float(float x) {

}

duckref_t make_nill(float x) {

}

duckref_t make_func(const char* label) {

}

duckref_t inv(duckref_t ref) {

}

duckref_t neg(duckref_t ref) {

}

duckref_t not(duckref_t ref) {

}

duckref_t add(duckref_t ref1, duckref_t ref2) {

}

duckref_t sub(duckref_t ref1, duckref_t ref2) {

}

duckref_t mul(duckref_t ref1, duckref_t ref2) {

}

duckref_t div(duckref_t ref1, duckref_t ref2) {

}

duckref_t eq(duckref_t ref1, duckref_t ref2) {

}

duckref_t neq(duckref_t ref1, duckref_t ref2) {

}

duckref_t lt(duckref_t ref1, duckref_t ref2) {

}

duckref_t le(duckref_t ref1, duckref_t ref2) {

}

duckref_t gt(duckref_t ref1, duckref_t ref2) {

}

duckref_t ge(duckref_t ref1, duckref_t ref2) {

}

duckref_t and(duckref_t ref1, duckref_t ref2) {

}

duckref_t or(duckref_t ref1, duckref_t ref2) {

}

void call(duckref_t ref) {

}

void raise_scope(void) {}

void drop_scope(void) {}

void init(void) {}

)PRELUDE";

void dumpC(std::ostream& out, tuple4 instr) {
    out << "\t";

    if (instr.instr == "label") {
        out << instr.addr1 << ":\n";
    }
    else if (instr.instr == "goto") {
        out << "goto " << instr.addr1 << ";\n";
    }
    else if (instr.instr == "ifgoto") {
        out << "if (to_bool(" << instr.addr1 << ")) goto " << instr.addr2 << ";\n";
    }
    else if (instr.instr == "push") {
        out << "push(" << instr.addr1 << ");\n";
    }
    else if (instr.instr == "pop") {
        out << instr.addr1 << " = pop();\n";
    }
    else if (instr.instr == "save") {
        out << "save(" << instr.addr1 << ", \"" << instr.addr2 << "\");\n";
    }
    else if (instr.instr == "load") {
        out << instr.addr1 << " = load(\"" << instr.addr2 << "\");\n";
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
    else if (instr.instr == "func") {
        out << instr.addr1 << " = make_func(\"" << instr.addr2 << "\");\n";
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

std::vector<string> getAddrNames(tuple4_vec& func) {

    std::set<string> labels;

    for (tuple4& instr : func) {
        string iname = instr.instr;
        if (iname == "push" || iname == "pop" || iname == "ifgoto" || iname == "load"
            || iname == "save" || iname == "nill" || iname == "lit" || iname == "liti"
            || iname == "litf" || iname == "func" || iname == "call") {
            labels.insert(instr.addr1);
        }
        else if (iname == "inv" || iname == "neg" || iname == "not") {
            labels.insert(instr.addr1);
            labels.insert(instr.addr2);
        }
        else if (iname == "add" || iname == "sub" || iname == "mul" || iname == "div"
            || iname == "eq" || iname == "neq" || iname == "lt" || iname == "le"
            || iname == "gt" || iname == "ge" || iname == "and" || iname == "or"
            || iname == "getindex" || iname == "setindex") {

            labels.insert(instr.addr1);
            labels.insert(instr.addr2);
            labels.insert(instr.addr3);
        }
    }

    return std::vector<string>(begin(labels), end(labels));
}

void declareAddrs(std::ostream& out, tuple4_vec& func) {

    std::vector<string> names = getAddrNames(func);
    if (func.empty()) return;

    out << "\tduckref_t";
    bool first = true;
    for (string& name : names) {

        if (first) {
            out << " " << name;
            first = false;
        }
        else {
            out << ", " << name;
        }
    }
    out << ";\n";
}

void outputCCode(std::ostream& out, tuple4_vec& main_program) {

    out << prelude;

    for (auto& kv : function_defs) {
        out << "int " << kv.first << "(void) {\n";
        declareAddrs(out, kv.second);
        out << "\traise_scope();\n";
        for (tuple4& instr : kv.second) {
            dumpC(out, instr);
        }
        out << "\tdrop_scope();\n";
        out << "}\n";
    }

    out << "int main(void) {\n";
    declareAddrs(out, main_program);
    out << "\tinit();\n";
    for (tuple4& instr : main_program) {
        dumpC(out, instr);
    }
    out << "}\n";

}
