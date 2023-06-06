module main

// stdlib
import json
// internal
import lexer
import os

struct ConfigData {
pub:
	tokens map[string]string
}

fn col(c int, s string) string {
	return '\033[1;3${c}m${s}\033[0m'
}

fn test_lookup_token() {
	mut data := ConfigData{}
	for _, v in ['${os.getwd()}/lexer_test.json', '${os.getwd()}/src/lexer_test.json'] {
		if os.is_file(v) {
			mut eof := false
			mut tag := 0
			fp := os.open_file(v, 'r')!
			mut fdata := []u8{}
			read := fp.read(mut fdata) or {
				if typeof(err).name.contains('os.Eof') {
					println('wellp')
					eof = true
				}
				1
			}
			if eof {
				println('read ${read} bytes')
				println(fdata)
				data = json.decode(ConfigData, fdata.bytestr()) or { panic(err) }
				break
			}
		}
	}
	println(data)
	println(os.getwd())
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
	tknz.identifiers['bar'] = 'baz'
	tknz.identifiers['baz'] = 'qux'
	for k, v in tknz.identifiers {
		assert tknz.lookup_identifier(k) == v
	}
}

fn test_lexer_next_token_single_chars() {
	mut tkns := lexer.TokenMap(map[string]lexer.TokenType{})
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
	input := ['=', '+', '-', '/', '*', '%', '^', '<', '>', ':', '!', ',', ';', '[', ']', '(', ')',
		'{', '}', "'", '"']
	for _, inp in input {
		mut tknz := lexer.new(inp, tkns, lexer.TokenMap(map[string]lexer.TokenType{}))
		t := tknz.next_token()
		assert inp == t.literal
	}
}

fn test_lexer_next_token_double_chars() {
	mut tkns := lexer.TokenMap(map[string]lexer.TokenType{})
	tkns['initialize'] = ':='
	tkns['equals'] = '=='
	tkns['notequals'] = '!='
	tkns['ltorequals'] = '<='
	tkns['gtorequals'] = '>='
	tkns['l_and'] = '&&'
	tkns['l_or'] = '||'
	input := [':=', '==', '!=', '<=', '>=', '&&', '||']
	for _, inp in input {
		mut tknz := lexer.new(inp, tkns, lexer.TokenMap(map[string]lexer.TokenType{}))
		t := tknz.next_token()
		assert inp == t.literal
	}
}

fn test_lexer_identifiers() {
	input := ['foo', 'bar']
	tkns := lexer.TokenMap(map[string]lexer.TokenType{})
	for _, inp in input {
		mut tknz := lexer.new(inp, tkns, tkns)
		t := tknz.next_token()
		assert inp == t.literal
	}
}

fn test_lexer_numbers() {
	input := ['4', '4.2', '94.16', '7', '22', '99', '4']
	tkns := lexer.TokenMap(map[string]lexer.TokenType{})
	for _, inp in input {
		mut tknz := lexer.new(inp, tkns, tkns)
		t := tknz.next_token()
		assert inp == t.literal
	}
}
