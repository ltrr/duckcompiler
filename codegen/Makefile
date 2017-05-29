
duckc: main.cpp instr.cpp literal.cpp lexparser.lex sintparser.yacc
	lex -o lexparser.cpp lexparser.lex
	yacc -o sintparser.cpp sintparser.yacc --defines=tokens.h
	g++ -std=c++11 main.cpp instr.cpp literal.cpp lexparser.cpp sintparser.cpp -o duckc
