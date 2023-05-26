module lexer

pub type TokenType = string
pub type TokenMap = map[string]TokenType

pub struct GenericToken[T] {
pub mut:
	id      TokenType
	literal T
}

pub fn new_token[T](id string, lit T) {}

pub fn (toki GenericToken[T]) str() string {
	return 'Type: ${toki.id} Value: ${toki.literal}'
}

pub struct Lexer {
mut:
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
	return Lexer{
		tokens: tkns
		keywords: kwds
	}
}

pub fn (toki Lexer) lookup_identifier(id string) TokenType {
	retv := toki.identifiers[id] or { return 'ILLEGAL' }
	return retv
}

pub fn (toki Lexer) lookup_token(id string) TokenType {
	retv := toki.tokens[id] or { return 'ILLEGAL' }
	return retv
}

pub fn (toki Lexer) lookup_keyword(id string) TokenType {
	retv := toki.keywords[id] or { return 'IDENT' }
	return retv
}
