ducklex: duck.lex
	lex -o ducklex.c duck.lex
	gcc -o ducklex ducklex.c
