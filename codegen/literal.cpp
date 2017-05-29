#include "literal.h"
#include "instr.h"

tuple4_vec StringLit::genCode(context c) {
	return { tuple4("lits", value, "", "") };
}

tuple4_vec IntLit::genCode(context c) {
	return { tuple4("liti", std::to_string(value), "", "") };
}

tuple4_vec FloatLit::genCode(context c) {
	return { tuple4("litf", std::to_string(value), "", "") };
}

tuple4_vec BoolLit::genCode(context c) {
	tuple4 instr;
	if (value)
		instr = tuple4("liti", "1", "", "");
	else
		instr = tuple4("liti", "0", "", "");
	return { instr };
}
