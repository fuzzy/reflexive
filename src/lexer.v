module lexer

pub type TokenType = string
pub type TokenMap = map[string]TokenType

pub struct GenericToken {
pub:
	id      TokenType
	literal string
}

// new_token returns a token with the appropriate type.
pub fn new_token(id TokenType, lit string) GenericToken {
	return GenericToken{
		literal: lit
		id: id
	}
}

// we'll keep this around just to make debugging things a bit easier.
// I can't think of any other use for it
pub fn (toki GenericToken) str() string {
	return 'Type: ${toki.id} Value: ${toki.literal}'
}

// this is a random comment
pub struct Lexer {
	// this is reserved for future work
	regard_whitespace bool
mut:
	// standard types, custom ones can be added
	types map[string]string = {
		'int':    'INTEGER'
		'float':  'FLOAT'
		'byte':   'BYTE'
		'string': 'STRING'
		'array':  'ARRAY'
		'hash':   'HASH'
	}
	// these two are  also reserved for future work
	innumber bool
	instring bool
pub:
	input    string
	tokens   TokenMap
	keywords TokenMap
pub mut:
	position      int
	read_position int
	current       byte
	identifiers   TokenMap
}

// new returns a Lexer instance, once given input, and a token and keyword map
pub fn new(inp string, tkns TokenMap, kwds TokenMap) Lexer {
	mut retv := Lexer{
		input: inp
		tokens: tkns
		keywords: kwds
	}
	// initialize the struct and get it ready for parsing
	retv.read_char()
	return retv
}

pub fn (mut lexx Lexer) next_token() GenericToken {
	mut tok := GenericToken{}
	lexx.ignore_whitespace()
	// first pass checks to see if it's a standardized token
	for k, v in lexx.tokens {
		match lexx.current {
			v[0] {
				if v.len == 2 && lexx.peek_char() == v[1] {
					lexx.read_char()
					tok = new_token(k, v)
					break
				} else if v.len == 1 {
					tok = new_token(k, v)
					break
				}
			}
			else {}
		}
	}
	if tok.literal.len == 0 {
		if is_letter(lexx.current) {
			return new_token('IDENTIFIER', lexx.read_identifier())
		} else if is_digit(lexx.current) {
			return new_token('NUMBER', lexx.read_number())
		} else {
			return new_token('ILLEGAL', lexx.current.ascii_str())
		}
	}

	lexx.read_char()
	return tok
}

pub fn (mut lexx Lexer) read_char() {
	if lexx.read_position >= lexx.input.len {
		lexx.current = 0
	} else {
		lexx.current = lexx.input[lexx.read_position]
	}
	lexx.position = lexx.read_position
	lexx.read_position += 1
}

fn (mut lexx Lexer) peek_char() byte {
	if lexx.read_position >= lexx.input.len {
		return 0
	} else {
		return lexx.input[lexx.read_position]
	}
}

fn (mut lexx Lexer) ignore_whitespace() {
	if !lexx.regard_whitespace {
		for lexx.current == ` ` || lexx.current == `\t` || lexx.current == `\n`
			|| lexx.current == `\r` {
			lexx.read_char()
		}
	}
}

// identifiers are alpha only + _ so read till there's no more of that
fn (mut lexx Lexer) read_identifier() string {
	pos := lexx.position
	for is_letter(lexx.current) {
		lexx.read_char()
	}
	return lexx.input[pos..lexx.position]
}

// strings go from opening char to closing char, which match, so this is easy
fn (mut lexx Lexer) read_string() string {
	pos := lexx.position
	lexx.read_char()
	for lexx.current != lexx.input[pos] {
		lexx.read_char()
	}
	end := lexx.position + 1
	return lexx.input[pos..end]
}

// numbers can include a period, assuming there is a number after it.
fn (mut lexx Lexer) read_number() string {
	pos := lexx.position
	for is_digit(lexx.current) {
		lexx.read_char()
	}
	return lexx.input[pos..lexx.position]
}

// lookup an identifier to see if it is valid or not.
pub fn (mut lexx Lexer) lookup_identifier(id string) TokenType {
	retv := lexx.identifiers[id] or { return 'ILLEGAL' }
	return retv
}

// lookup a given token to see if it is valid or not.
pub fn (mut lexx Lexer) lookup_token(id string) TokenType {
	retv := lexx.tokens[id] or { return 'ILLEGAL' }
	return retv
}

// lookup a given ident to see if it is a keyword or not.
pub fn (mut lexx Lexer) lookup_keyword(id string) TokenType {
	retv := lexx.keywords[id] or { return 'IDENT' }
	return retv
}

fn is_letter(ch byte) bool {
	return (`a` <= ch && ch <= `z`) || (`A` <= ch && ch <= `Z`) || ch == `_`
}

fn is_digit(ch byte) bool {
	return (`0` <= ch && ch <= `9`) || ch == `.`
}
