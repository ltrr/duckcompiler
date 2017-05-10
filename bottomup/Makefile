
parser: lexparser.lex sintparser.yacc
	lex -o lexparser.cpp lexparser.lex
	yacc -o sintparser.cpp sintparser.yacc --defines=tokens.h
	g++ -o parser sintparser.cpp lexparser.cpp
