ducklex: duck.lex
	lex -o ducklex.c duck.lex
	gcc -o ducklex ducklex.c

ducktable: table.lex tokens.h 
	lex -o tablelex.cpp table.lex
	g++ -std=c++11 -o ducktable tablelex.cpp

