module lexer

pub type TokenType = string
pub type TokenMap = map[string]TokenType

pub struct GenericToken[T] {
pub mut:
	id      TokenType
	literal T
}

pub fn new_token[T](id string, lit T) {}

// NOTE: This is the old way, without generics
// pub fn new_token(ttype TokenType, ch byte) token.Token {
// 	return token.Token
// 	{
// 		literal:
// 		ch.ascii_str()
// 		token_type:
// 		ttype
// 	}
// }

pub fn (toki GenericToken[T]) str() string {
	return 'Type: ${toki.id} Value: ${toki.literal}'
}

pub struct Lexer {
	// this is reserved for future work
	regard_whitespace bool
mut:
	// this is too
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

pub fn new(inp string, tkns TokenMap, kwds TokenMap) Lexer {
	mut retv := Lexer{
		input: inp
		tokens: tkns
		keywords: kwds
	}
	retv.read_char()
	return retv
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

pub fn (mut lexx Lexer) peek_char() byte {
	if lexx.read_position >= lexx.input.len {
		return 0
	} else {
		return lexx.input[lexx.read_position]
	}
}

pub fn (mut lexx Lexer) ignore_whitespace() {
	if !lexx.regard_whitespace {
		for lexx.current == ` ` || lexx.current == `\t` || lexx.current == `\n`
			|| lexx.current == `\r` {
			lexx.read_char()
		}
	}
}

// TODO: This is s stub
pub fn (mut lexx Lexer) read_identifier() string {
	return ' '
}

// TODO: This is a stub
pub fn (mut lexx Lexer) read_string() string {
	return ' '
}

// TODO: this is a stub
pub fn (mut lexx Lexer) read_number() string {
	return ' '
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

pub fn (mut lexx Lexer) next_token[T]() GenericToken[T] {}

fn is_letter(ch byte) bool {
	return (`a` <= ch && ch <= `z`) || (`A` <= ch && ch <= `Z`) || ch == `_`
}

fn is_digit(ch byte) bool {
	return (`0` <= ch && ch <= `9`) || ch == `.`
}
