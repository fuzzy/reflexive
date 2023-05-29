module main

import lexer

fn col(c int, s string) string {
	return '\033[1;3${c}m${s}\033[0m'
}

fn test_lookup_token() {
	mut tkns := lexer.TokenMap(map[string]lexer.TokenType{})
	tkns['let'] = 'LET'
	tkns['illegal'] = 'ILLEGAL'
	tkns['eof'] = 'EOF'
	tkns['ident'] = 'IDENT'
	tkns['integer'] = 'INT'
	tkns['float'] = 'FLOAT'
	tkns['initialize'] = ':='
	tkns['assign'] = '='
	tkns['plus'] = '+'
	tkns['minus'] = '-'
	tkns['divide'] = '/'
	tkns['multiply'] = '*'
	tkns['remainder'] = '%'
	tkns['powerof'] = '^'
	tkns['lessthan'] = '<'
	tkns['greaterthan'] = '>'
	tkns['keyend'] = ':'
	tkns['exclamation'] = '!'
	tkns['comma'] = ','
	tkns['semicolon'] = ';'
	tkns['lbracket'] = '['
	tkns['rbracket'] = ']'
	tkns['lparen'] = '('
	tkns['rparen'] = ')'
	tkns['lbrace'] = '{'
	tkns['rbrace'] = '}'
	tkns['squote'] = "'"
	tkns['dquote'] = '"'
	tkns['str'] = 'STRING'
	tkns['function'] = 'FUNCTION'
	tkns['cond_if'] = 'IF'
	tkns['cond_else'] = 'ELSE'
	tkns['returnval'] = 'RETURN'
	tkns['bool_t'] = 'TRUE'
	tkns['bool_f'] = 'FALSE'
	tkns['equals'] = '=='
	tkns['notequals'] = '!='
	tkns['ltorequals'] = '<='
	tkns['gtorequals'] = '>='
	tkns['l_and'] = '&&'
	tkns['l_or'] = '||'
	kwds := lexer.TokenMap(map[string]lexer.TokenType{})
	mut tknz := lexer.new('', tkns, kwds)
	for k, v in tkns {
		assert tknz.lookup_token(k) == v
	}
}

fn test_lookup_keyword() {
	tkns := lexer.TokenMap(map[string]lexer.TokenType{})
	mut kwds := lexer.TokenMap(map[string]lexer.TokenType{})
	kwds['let'] = 'LET'
	kwds['fn'] = 'FUNCTION'
	kwds['if'] = 'IF'
	kwds['else'] = 'ELSE'
	kwds['return'] = 'RETURN'
	kwds['true'] = 'TRUE'
	kwds['false'] = 'FALSE'
	kwds['and'] = '&&'
	kwds['or'] = '||'
	mut tknz := lexer.new('', tkns, kwds)
	for k, v in kwds {
		assert tknz.lookup_keyword(k) == v
	}
}

fn test_lookup_identifier() {
	mut tknz := lexer.new('', lexer.TokenMap(map[string]lexer.TokenType{}), lexer.TokenMap(map[string]lexer.TokenType{}))
	tknz.identifiers['foo'] = 'bar'
	assert tknz.lookup_identifier('foo') == 'bar'
}

fn test_lexer_next_token_single_chars() {
	mut tkns := lexer.TokenMap(map[string]lexer.TokenType{})
	tkns['initialize'] = ':='
	tkns['assign'] = '='
	tkns['plus'] = '+'
	tkns['minus'] = '-'
	tkns['divide'] = '/'
	tkns['multiply'] = '*'
	tkns['remainder'] = '%'
	tkns['powerof'] = '^'
	tkns['lessthan'] = '<'
	tkns['greaterthan'] = '>'
	tkns['keyend'] = ':'
	tkns['exclamation'] = '!'
	tkns['comma'] = ','
	tkns['semicolon'] = ';'
	tkns['lbracket'] = '['
	tkns['rbracket'] = ']'
	tkns['lparen'] = '('
	tkns['rparen'] = ')'
	tkns['lbrace'] = '{'
	tkns['rbrace'] = '}'
	tkns['squote'] = "'"
	tkns['dquote'] = '"'
	tkns['equals'] = '=='
	tkns['notequals'] = '!='
	tkns['ltorequals'] = '<='
	tkns['gtorequals'] = '>='
	tkns['l_and'] = '&&'
	tkns['l_or'] = '||'
	input := ['=', '+', '-', '/', '*', '%', '^', '<', '>', ':', '!', ',', ';', '[', ']', '(', ')',
		'{', '}']
	for _, inp in input {
		mut tknz := lexer.new(inp, tkns, lexer.TokenMap(map[string]lexer.TokenType{}))
		t := tknz.next_token()
		assert inp == t.literal
	}
}
