
parser: lexparser.lex sintparser.yacc
	lex -o lexparser.cpp lexparser.lex
	yacc -o sintparser.cpp sintparser.yacc --defines=tokens.h
	g++ -std=c++11 -o parser sintparser.cpp lexparser.cpp
