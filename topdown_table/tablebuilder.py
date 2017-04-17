#!/usr/bin/env python3

import re

f = open('rules.txt')

tot_re = re.compile(r'(\d+)\s+(\w+) -> ([^\t]+)\t(.+)')

productions = []

lines = f.readlines()
for line in lines:
    match = tot_re.match(line)
    num = int(match.group(1))
    # print('num', match.group(1))
    left = match.group(2)
    # print('left', match.group(2))
    right = list(filter(lambda x: x != u'ε', match.group(3).strip().split()))
    # print('right', match.group(3).strip().split())
    pred = list(map(lambda x: x.strip(), match.group(4).strip().split(',')))
    # print('pred', match.group(4).strip().split(','))
    productions.append((left, right, pred))


symbols = set()
for l, r, p in productions:
    symbols.add(l)
    for s in r:
        symbols.add(s)
symbols.add('T_EOF')

terminals = sorted(list(filter(lambda x: x.startswith('T_'), symbols)))
nonterminals = sorted(list(filter(lambda x: x.startswith('NT_'), symbols)))

# print('terminals', terminals)
# print('nonterminals', nonterminals)

codes = {
    'T_ENDL': ord('\n'),
    'T_PLUS': ord('+'),
    'T_MINUS': ord('-'),
    'T_TIMES': ord('*'),
    'T_DIV': ord('/'),
    'T_ASSIGN': ord('='),
    'T_DOT': ord('.'),
    'T_LPARENS' :ord('('),
    'T_RPARENS' : ord(')'),
    'T_LBRACKET' : ord('['),
    'T_RBRACKET' : ord(']'),
    'T_LBRACES' : ord('{'),
    'T_RBRACES' : ord('}'),
    'T_COMMA' : ord(','),
    'T_COLON' : ord(':')
}

usedcodes = { codes[k] for k in codes }

i = 1
for t in terminals:
    if t in codes: continue
    while i in usedcodes: i += 1
    codes[t] = i
    usedcodes.add(i)

i = -1
for nt in nonterminals:
    codes[nt] = i
    i -= 1


maxterminal = max(codes.values())
maxnonterminal = -min(codes.values())

# print(maxterminal, maxnonterminal)


pds = []
for i in range(len(productions)):
    l, r, _ = productions[i]
    pds.append('{' + ','.join(reversed(r)) + '}')

pds = ','.join(pds)

# print(pds)

defs = '\n'.join(['const int {} = {};'.format(k, v) for k, v in codes.items()])


table = {}
i = 0
for l, r, p in productions:
    keys = [(codes[l], codes[pe]) for pe in p]
    for k in keys:
        assert k not in table
        table[k] = i
    i += 1

# print(table)


scancode = len(productions) + 1
popcode = scancode + 1

follow = {}
with open('follow.txt') as g:
    for line in g.readlines():
        nt, ls = line.split('\t')
        nt = nt.strip()
        ls = map(lambda s: s.strip(), ls.split(','))
        follow[codes[nt]] = list(map(lambda x: codes[x], ls))


tablefill = []
for nti in range(maxnonterminal+1):
    ls = []
    for ti in range(maxterminal+1):
        if (-nti, ti) in table:
            ls.append(table[(-nti, ti)])
        else:
            if nti == 0 or ti in follow[-nti]:
                ls.append(popcode)
            else:
                ls.append(scancode)
    tablefill.append(ls)

# print(tablefill)

table_expr = tablefill.__str__().replace('[','{').replace(']','}')

symbol_names = '{' \
    + ','.join(['{{{},"{}"}}'.format(v, k) for k, v in codes.items()]) \
    + '}'


sourcecode = '''
#ifndef __TOKENS_H__
#define __TOKENS_H__

#include <vector>
#include <map>

typedef std::vector<int> production;

const int MAXTERM = {};
const int MAXNONTERM = {};
const int POPCODE = {};
const int SCANCODE = {};

{}

std::vector<production> productions = {{{}}};

std::vector<std::vector<int>> table = {};


std::map<int, const char*> symbol_names = {};

#endif
'''.format(maxterminal, maxnonterminal, popcode, scancode, defs, pds, table_expr, symbol_names)

print(sourcecode)
