SOURCES = main.cpp instr.cpp literal.cpp statement.cpp lvalue.cpp loops.cpp cdriver.cpp if_else.cpp arrayinit.cpp dictinit.cpp object.cpp

duckc: $(SOURCES) lexparser.lex sintparser.yacc
	lex -o lexparser.cpp lexparser.lex
	yacc -o sintparser.cpp sintparser.yacc --defines=tokens.h
	g++ -std=c++11 $(SOURCES) lexparser.cpp sintparser.cpp -o duckc

clean:
	rm -f lexparser.cpp sintparser.cpp duckc tokens.h
