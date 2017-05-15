#ifndef __STRINGTREE_H__
#define __STRINGTREE_H__

#include <iostream>
#include <string>
#include <vector>

#define YYSTYPE StringTree

struct StringTree {

	std::string value;
	std::vector<StringTree> children;

	StringTree() : value("UNDEF"), children() {}

	StringTree(std::string _value) : value(_value) {}

	StringTree(std::string _value, std::vector<StringTree> _children) 
		: value(_value), children(_children) {

	}
};

std::ostream& pprint(std::ostream& os, const StringTree& tree, int level);
std::ostream& operator<<(std::ostream& os, const StringTree& tree);

#endif
