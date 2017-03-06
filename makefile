ducklex: duck.lex
	lex -oducklex.c duck.lex
	gcc -o ducklex ducklex.c