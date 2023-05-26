module main

import token

fn col(c int, s string) string {
	return '\033[1;3${c}m${s}\033[0m'
}

fn test_lookup_token() {
	mut tkns := token.TokenMap(map[string]token.TokenType{})
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
	kwds := token.TokenMap(map[string]token.TokenType{})
	tknz := token.new_tokenizer(tkns, kwds)
	for k, v in tkns {
		assert tknz.lookup_token(k) == v
	}
}

fn test_lookup_keyword() {
	tkns := token.TokenMap(map[string]token.TokenType{})
	mut kwds := token.TokenMap(map[string]token.TokenType{})
	kwds['let'] = 'LET'
	kwds['fn'] = 'FUNCTION'
	kwds['if'] = 'IF'
	kwds['else'] = 'ELSE'
	kwds['return'] = 'RETURN'
	kwds['true'] = 'TRUE'
	kwds['false'] = 'FALSE'
	kwds['and'] = '&&'
	kwds['or'] = '||'
	tknz := token.new_tokenizer(tkns, kwds)
	for k, v in kwds {
		assert tknz.lookup_keyword(k) == v
	}
}

fn test_lookup_identifier() {
	mut tknz := token.new_tokenizer(token.TokenMap(map[string]token.TokenType{}), token.TokenMap(map[string]token.TokenType{}))
	tknz.identifiers['foo'] = 'bar'
	assert tknz.lookup_identifier('foo') == 'bar'
}
