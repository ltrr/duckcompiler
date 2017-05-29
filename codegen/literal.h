#include "instr.h"

class StringLit : public CodeTree {
public:
	StringLit(std::string value) : value(value) {}

	tuple4_vec genCode(context c);

private:
	std::string value;
};


class IntLit : public CodeTree {
public:
	IntLit(int value) : value(value) {}

	tuple4_vec genCode(context c);

private:
	int value;
};


class FloatLit : public CodeTree {
public:
	FloatLit(float value) : value(value) {}

	tuple4_vec genCode(context c);

private:
	float value;
};


class BoolLit : public CodeTree {
public:
	BoolLit(bool value) : value(value) {}

	tuple4_vec genCode(context c);

private:
	bool value;
};
