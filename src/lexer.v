module token

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

pub struct Tokenizer {
pub:
	tokens   TokenMap
	keywords TokenMap
pub mut:
	identifiers TokenMap
}

pub fn new_tokenizer(tkns TokenMap, kwds TokenMap) Tokenizer {
	return Tokenizer{
		tokens: tkns
		keywords: kwds
	}
}

pub fn (toki Tokenizer) lookup_identifier(id string) TokenType {
	retv := toki.identifiers[id] or { return illegal }
	return retv
}

pub fn (toki Tokenizer) lookup_token(id string) TokenType {
	retv := toki.tokens[id] or { return illegal }
	return retv
}

pub fn (toki Tokenizer) lookup_keyword(id string) TokenType {
	retv := toki.keywords[id] or { return ident }
	return retv
}
