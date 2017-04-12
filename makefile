lexparser: lexical/lexparser.lex
	cd lexical; \
	lex -o lexparser.c lexparser.lex; \
	gcc -o ../lexparser lexparser.c


tableparser: topdown_table/tableparser.lex topdown_table/table.h
	cd topdown_table; \
	lex -o tableparser.cpp tableparser.lex; \
	g++ -std=c++11 -o ../tableparser tableparser.cpp


topdown_table/table.h: topdown_table/rules.txt
	cd topdown_table; \
	tablebuilder.py > table.h


