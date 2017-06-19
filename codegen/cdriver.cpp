#include "cdriver.h"

#include <string>
#include <vector>
#include <set>
#include "instr.h"
using std::string;

string prelude = R"PRELUDE(
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define DUCK_NILL 0
#define DUCK_FUNC 1
#define DUCK_OBJ 2
#define DUCK_STR 3
#define DUCK_INT 4
#define DUCK_FLOAT 5

struct duckentry_t;

typedef struct duckentry_t duckentry_t;

typedef struct {
    duckentry_t* head;
} duckobj_t;

typedef struct {
    int type;
    union {
        int ivalue;
        float fvalue;
        const char* svalue;
        const char* flabel;
        duckobj_t ovalue;
    } value;
} duckref_t;

struct duckentry_t {
    duckref_t key;
    duckref_t value;
    duckentry_t *next;
};


//////////// constructors
duckref_t make_nill() {
    duckref_t ref;
    ref.type = DUCK_NILL;
    return ref;
}

duckref_t make_func(const char* label) {
    duckref_t ref;
    ref.type = DUCK_FUNC;
    ref.value.flabel = label;
    return ref;
}

duckref_t make_obj() {
    duckref_t ref;
    ref.type = DUCK_OBJ;
    ref.value.ovalue.head = malloc(sizeof(duckentry_t));
    ref.value.ovalue.head->next = NULL;
    return ref;
}

duckref_t make_str(const char* str) {
    duckref_t ref;
    ref.type = DUCK_STR;
    ref.value.svalue = str;
    return ref;
}

duckref_t make_int(int x) {
    duckref_t ref;
    ref.type = DUCK_INT;
    ref.value.ivalue = x;
    return ref;
}

duckref_t make_float(float x) {
    duckref_t ref;
    ref.type = DUCK_FLOAT;
    ref.value.fvalue = x;
    return ref;
}

//////////// raw equality
int raw_eq(duckref_t ref1, duckref_t ref2) {
    if (ref1.type == ref2.type) goto endif_raweq;
    return 0;
    endif_raweq:
    switch (ref1.type) {
        case DUCK_NILL:
            return 1;
        case DUCK_FUNC:
            return (strcmp(ref1.value.flabel, ref2.value.flabel) == 0);
        case DUCK_OBJ:
            return (ref1.value.ovalue.head == ref2.value.ovalue.head);
        case DUCK_STR:
            return (strcmp(ref1.value.svalue, ref2.value.svalue) == 0);
        case DUCK_INT:
            return (ref1.value.ivalue == ref2.value.ivalue);
        case DUCK_FLOAT:
            return (ref1.value.fvalue == ref2.value.fvalue);
        default:
            return 0;
    }
}


//////////// objects
duckentry_t* make_entry(duckref_t key, duckref_t value) {
    duckentry_t *entry = malloc(sizeof(duckentry_t));
    entry->key = key;
    entry->value = value;
    return entry;
}

void add_entry(duckobj_t *obj, duckentry_t *entry) {
    duckentry_t *it = obj->head;
    startwhile_add_entry:
    if (it->next == NULL) goto endwhile_add_entry;
    it = it->next;
    goto startwhile_add_entry;
    endwhile_add_entry:
    it->next = entry;
    entry->next = NULL;
}

duckref_t getobjindex(duckobj_t* obj, duckref_t index) {
    duckentry_t *it = obj->head;

    startwhile_getobjindex:
    if (it->next == NULL) goto endwhile_getobjindex;
    it = it->next;
    if (!raw_eq(index, it->key)) goto endif_getobjindex;
    return it->value;
    endif_getobjindex:
    goto startwhile_getobjindex;
    endwhile_getobjindex:

    return make_nill();
}

void setobjindex(duckobj_t* obj, duckref_t index, duckref_t value) {
    duckentry_t *it = obj->head;

    startwhile_setobjindex:
    if (it->next == NULL) goto endwhile_setobjindex;
    it = it->next;
    if (!raw_eq(index, it->key)) goto endif_setobjindex;
    it->value = value;
    return;
    endif_setobjindex:
    goto startwhile_setobjindex;
    duckentry_t *entry;
    endwhile_setobjindex:
    entry = make_entry(index, value);
    add_entry(obj, entry);
}


//////////// variables
int vartable_array_size = 0;
duckobj_t* vartable_array[1024];

void raise_scope(void) {
    duckobj_t* obj = malloc(sizeof(duckobj_t));
    obj->head = malloc(sizeof(duckentry_t));
    obj->head->next = NULL;
    vartable_array[vartable_array_size] = obj;
    vartable_array_size += 1;
}

void drop_scope(void) {
    if (vartable_array_size <= 0)
        return;
    duckobj_t* arr = vartable_array[vartable_array_size];
    //if (arr != NULL) free(arr);
    vartable_array_size -= 1;
}

duckref_t load(const char *name) {
    duckref_t name_str;
    name_str.type = DUCK_STR;
    name_str.value.svalue = name;

    duckref_t ref = getobjindex(vartable_array[vartable_array_size-1], name_str);
    if (ref.type == DUCK_NILL) goto load_endif;
    return ref;
    load_endif:
    return getobjindex(vartable_array[0], name_str);

}

void save(duckref_t ref, const char *name) {
    duckref_t name_str;
    name_str.type = DUCK_STR;
    name_str.value.svalue = name;

    duckref_t vref = getobjindex(vartable_array[0], name_str);

    if (vref.type == DUCK_NILL) goto save_endif;
    setobjindex(vartable_array[0], name_str, ref);
    return;
    save_endif:
    setobjindex(vartable_array[vartable_array_size-1], name_str, ref);
}

duckref_t call_stack[1024];
int call_stack_size = 0;

void push(duckref_t ref) {
    call_stack[call_stack_size] = ref;
    call_stack_size += 1;
}

duckref_t pop(void) {
    if (call_stack_size != 0) goto endif_pop;
    return make_nill();
    endif_pop:
    call_stack_size -= 1;
    return call_stack[call_stack_size];
}

duckref_t getindex(duckref_t ref, duckref_t index) {
    if (ref.type == DUCK_OBJ) goto endif_getindex;
    fprintf(stderr, "cannot index: not a object\n");
    return make_nill();
    endif_getindex:
    return getobjindex(&ref.value.ovalue, index);
}

void setindex(duckref_t ref, duckref_t index, duckref_t value) {
    if (ref.type == DUCK_OBJ) goto endif_setindex;
    fprintf(stderr, "cannot index: not a object\n");
    return;
    endif_setindex:
    setobjindex(&ref.value.ovalue, index, value);
}

void init(void) {
    raise_scope();

    duckref_t ducklib = make_obj();
    duckref_t printfn = make_func("duck.print");
    duckref_t printfn_name = make_str("print");
    setindex(ducklib, printfn_name, printfn);
    duckref_t printlnfn = make_func("duck.println");
    duckref_t printlnfn_name = make_str("println");
    setindex(ducklib, printlnfn_name, printlnfn);
    save(ducklib, "duck");
}

int to_bool(duckref_t ref) {
    switch (ref.type) {
        case DUCK_NILL:
            return 0;
        case DUCK_FUNC:
            return 1;
        case DUCK_OBJ:
            return 1;
        case DUCK_STR:
            return strlen(ref.value.svalue);
        case DUCK_INT:
            return ref.value.ivalue;
        case DUCK_FLOAT:
            return (ref.value.fvalue != 0) ? 1 : 0;
    }
    return 0;
}

duckref_t op_inv(duckref_t ref) {
    switch (ref.type) {
        case DUCK_INT:
            return make_int(-ref.value.ivalue);
        case DUCK_FLOAT:
            return make_int(-ref.value.fvalue);
        default:
            return make_nill();
    }
}

duckref_t op_neg(duckref_t ref) {
    return make_nill();
}

duckref_t op_not(duckref_t ref) {
    if (!to_bool(ref)) goto endif_op_not;
    return make_int(0);
    endif_op_not:
    return make_int(1);
}

duckref_t op_add(duckref_t ref1, duckref_t ref2) {
    switch (ref1.type) {
        case DUCK_INT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_int(ref1.value.ivalue + ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.ivalue + ref2.value.fvalue);
                default:
                    return make_nill();
            }
        case DUCK_FLOAT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_float(ref1.value.fvalue + ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.fvalue + ref2.value.fvalue);
                default:
                    return make_nill();
            }
        default:
            return make_nill();
    }
}

duckref_t op_sub(duckref_t ref1, duckref_t ref2) {
    switch (ref1.type) {
        case DUCK_INT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_int(ref1.value.ivalue - ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.ivalue - ref2.value.fvalue);
                default:
                    return make_nill();
            }
        case DUCK_FLOAT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_float(ref1.value.fvalue - ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.fvalue - ref2.value.fvalue);
                default:
                    return make_nill();
            }
        default:
            return make_nill();
    }
}

duckref_t op_mul(duckref_t ref1, duckref_t ref2) {
    switch (ref1.type) {
        case DUCK_INT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_int(ref1.value.ivalue * ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.ivalue * ref2.value.fvalue);
                default:
                    return make_nill();
            }
        case DUCK_FLOAT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_float(ref1.value.fvalue * ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.fvalue * ref2.value.fvalue);
                default:
                    return make_nill();
            }
        default:
            return make_nill();
    }
}

duckref_t op_div(duckref_t ref1, duckref_t ref2) {
    switch (ref1.type) {
        case DUCK_INT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_int(ref1.value.ivalue / ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.ivalue / ref2.value.fvalue);
                default:
                    return make_nill();
            }
        case DUCK_FLOAT:
            switch (ref2.type) {
                case DUCK_INT:
                    return make_float(ref1.value.fvalue / ref2.value.ivalue);
                case DUCK_FLOAT:
                    return make_float(ref1.value.fvalue / ref2.value.fvalue);
                default:
                    return make_nill();
            }
        default:
            return make_nill();
    }
}

duckref_t op_eq(duckref_t ref1, duckref_t ref2) {
    if (raw_eq(ref1, ref2)) goto op_eq_endif;
    return make_int(0);
    op_eq_endif:
    return make_int(1);
}

duckref_t op_neq(duckref_t ref1, duckref_t ref2) {
    if (raw_eq(ref1, ref2)) goto op_eq_endif;
    return make_int(1);
    op_eq_endif:
    return make_int(0);
}

duckref_t op_lt(duckref_t ref1, duckref_t ref2) {
    float v1, v2;
    switch (ref1.type) {
        case DUCK_INT:
            v1 = ref1.value.ivalue;
            break;
        case DUCK_FLOAT:
            v1 = ref1.value.fvalue;
            break;
        default:
            return make_nill();
    }
    switch (ref2.type) {
        case DUCK_INT:
            v2 = ref2.value.ivalue;
            break;
        case DUCK_FLOAT:
            v2 = ref2.value.fvalue;
            break;
        default:
            return make_nill();
    }
    return make_int(v1 < v2 ? 1 : 0);
}

duckref_t op_le(duckref_t ref1, duckref_t ref2) {
    float v1, v2;
    switch (ref1.type) {
        case DUCK_INT:
            v1 = ref1.value.ivalue;
            break;
        case DUCK_FLOAT:
            v1 = ref1.value.fvalue;
            break;
        default:
            return make_nill();
    }
    switch (ref2.type) {
        case DUCK_INT:
            v2 = ref2.value.ivalue;
            break;
        case DUCK_FLOAT:
            v2 = ref2.value.fvalue;
            break;
        default:
            return make_nill();
    }
    return make_int(v1 <= v2 ? 1 : 0);
}

duckref_t op_gt(duckref_t ref1, duckref_t ref2) {
    float v1, v2;
    switch (ref1.type) {
        case DUCK_INT:
            v1 = ref1.value.ivalue;
            break;
        case DUCK_FLOAT:
            v1 = ref1.value.fvalue;
            break;
        default:
            return make_nill();
    }
    switch (ref2.type) {
        case DUCK_INT:
            v2 = ref2.value.ivalue;
            break;
        case DUCK_FLOAT:
            v2 = ref2.value.fvalue;
            break;
        default:
            return make_nill();
    }
    return make_int(v1 > v2 ? 1 : 0);
}

duckref_t op_ge(duckref_t ref1, duckref_t ref2) {
    float v1, v2;
    switch (ref1.type) {
        case DUCK_INT:
            v1 = ref1.value.ivalue;
            break;
        case DUCK_FLOAT:
            v1 = ref1.value.fvalue;
            break;
        default:
            return make_nill();
    }
    switch (ref2.type) {
        case DUCK_INT:
            v2 = ref2.value.ivalue;
            break;
        case DUCK_FLOAT:
            v2 = ref2.value.fvalue;
            break;
        default:
            return make_nill();
    }
    return make_int(v1 > v2 ? 1 : 0);
}

duckref_t op_and(duckref_t ref1, duckref_t ref2) {

    if (!to_bool(ref1)) goto endif_op_and;
    return ref2;
    endif_op_and:
    return make_int(0);
}

duckref_t op_or(duckref_t ref1, duckref_t ref2) {
    if (!to_bool(ref1)) goto endif_op_or;
    return make_int(1);
    endif_op_or:
    return ref2;
}

////////// ducklib
void duckprint() {
    duckref_t arg = pop();
    switch (arg.type) {
        case DUCK_NILL:
            printf("nill");
            break;
        case DUCK_FUNC:
            printf("<function>");
            break;
        case DUCK_OBJ:
            printf("<object>");
            break;
        case DUCK_STR:
            printf("%s", arg.value.svalue);
            break;
        case DUCK_INT:
            printf("%d", arg.value.ivalue);
            break;
        case DUCK_FLOAT:
            printf("%f", arg.value.fvalue);
            break;
    }
}


void duckprintln() {
    duckprint();
    printf("\n");
}


void call(duckref_t ref);
)PRELUDE";


string epilogue_part1 = R"EPILOGUEP1(
void call(duckref_t ref) {
    if (ref.type != DUCK_FUNC) {
        fprintf(stderr, "not a function\n");
        return;
    }
    const char* name = ref.value.flabel;
    if (strcmp(name, "duck.print") == 0) {
        duckprint();
        return;
    }
    if (strcmp(name, "duck.println") == 0) {
        duckprintln();
        return;
    }
)EPILOGUEP1";

string epilogue_part2 = R"EPILOGUEP2(
}
)EPILOGUEP2";


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
    else if (instr.instr == "lito") {
        out << instr.addr1 << " = make_obj();\n";
    }
    else if (instr.instr == "nill") {
        out << instr.addr1 << " = make_nill();\n";
    }
    else if (instr.instr == "func") {
        out << instr.addr1 << " = make_func(\"" << instr.addr2 << "\");\n";
    }
    else if (instr.instr == "inv") {
        out << instr.addr1 << " = op_inv(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "neg") {
        out << instr.addr1 << " = op_neg(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "not") {
        out << instr.addr1 << " = op_not(" << instr.addr2 << ");\n";
    }
    else if (instr.instr == "add") {
        out << instr.addr1 << " = op_add(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "sub") {
        out << instr.addr1 << " = op_sub(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "mul") {
        out << instr.addr1 << " = op_mul(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "div") {
        out << instr.addr1 << " = op_div(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "eq") {
        out << instr.addr1 << " = op_eq(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "neq") {
        out << instr.addr1 << " = op_neq(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "lt") {
        out << instr.addr1 << " = op_lt(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "le") {
        out << instr.addr1 << " = op_le(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "gt") {
        out << instr.addr1 << " = op_gt(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "ge") {
        out << instr.addr1 << " = op_ge(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "and") {
        out << instr.addr1 << " = op_and(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "or") {
        out << instr.addr1 << " = op_or(" << instr.addr2 << ", " << instr.addr3 << ");\n";
    }
    else if (instr.instr == "call") {
        out << "call(" << instr.addr1 << ");\n";
    }
    else if (instr.instr == "return") {
        out << "drop_scope(); return 0;\n";
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
    out << "\treturn 0;\n";
    out << "}\n";

    out << epilogue_part1;
    for (auto& kv : function_defs) {
        out << "\tif (strcmp(name, \"" << kv.first <<"\") == 0) {\n"
            << "\t\t" << kv.first << "();\n"
            << "\t}";
    }
    out << epilogue_part2;

}
