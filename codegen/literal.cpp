#include "literal.h"
#include "instr.h"

tuple4_vec StringLit::genCode(context c) {
	return { tuple4("lit", c.hook_addr, value, "") };
}

tuple4_vec IntLit::genCode(context c) {
	return { tuple4("liti", c.hook_addr, std::to_string(value), "") };
}

tuple4_vec FloatLit::genCode(context c) {
	return { tuple4("litf", c.hook_addr, std::to_string(value), "") };
}

tuple4_vec BoolLit::genCode(context c) {
	if (value)
		return { tuple4("liti", c.hook_addr, "1", "") };
	else
		return { tuple4("liti", c.hook_addr, "0", "") };
}

tuple4_vec NillLit::genCode(context c) {
	return { tuple4("nill", c.hook_addr, "", "") };
}
