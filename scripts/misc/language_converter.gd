class_name LanguageConverter extends Object

class Result:
	var success: bool
	var remaining: String
	var parsed: String

	func _init(success: bool, remaining = "", parsed = ""):
		self.success = success
		self.remaining = remaining
		self.parsed = parsed

const UNICODE_OFFSET = 33 # All before are control
const PUNCTUATIONS = 10
const VOWELS = 12
const CONSONENTS = 24
const TOTAL_COMBINATIONS = ((CONSONENTS+1) * (VOWELS+1)) + PUNCTUATIONS

### Public Functions
func string_to_unicode(input: String) -> String:
	var symbols = string_to_symbols(input)
	var unicode = symbols_to_unicode(symbols)
	return unicode

func string_to_symbols(input: String) -> String:
	var symbols: String
	# First, convert to symbols
	while not input.is_empty():
		var result = _next_symbol(input)
		# assert(result.success)
		if not result.success:
			print("LanguageConverter: Failed to parse next symbol from \"%s\"" % input)
			assert(false)
			return ""
		assert(_is_valid_symbol(result.parsed))
		symbols = symbols + result.parsed
		input = result.remaining
	return symbols

func symbols_to_unicode(symbols: String) -> String:
	var unicode: String
	while not symbols.is_empty():
		var result = _next_unicode(symbols)
		if not result.success:
			print("LanguageConverter: Failed to parse next unicode from \"%s\"" % symbols)
			assert(false)
			return ""
		if not _is_valid_unicode(result.parsed):
			print("LanguageConverter: Invalid unicode \"%s\" (%s)" % [result.parsed, result.parsed.unicode_at(0)])
			assert(false)
			return ""
		unicode = unicode + result.parsed
		symbols = result.remaining
	return unicode


### Private Functions

## RAW
func _is_valid_punctuation(raw_char: String) -> bool:
	assert(raw_char.length() == 1)
	return raw_char in [" ", ".", ",", "?", "!"]

func _is_raw_simple_consonent(raw_char: String) -> bool:
	assert(raw_char.length() == 1)
	return raw_char in ["m", "p", "b", "f", "v", "k", "g", "l", "r", "j", "w", "h"]

func _is_raw_dependent_consonent(raw_char: String) -> bool:
	assert(raw_char.length() == 1)
	return raw_char in ["n", "t", "d", "c", "s", "z"]

func _is_raw_vowel(raw_char: String) -> bool:
	assert(raw_char.length() == 1)
	return raw_char in ["a", "i", "e", "o", "u"]

## SYMBOL
func _is_valid_symbol(symbol: String) -> bool:
	return (
		_is_consonent_symbol(symbol)
	 or _is_vowel_symbol(symbol)
	 or _is_valid_punctuation(symbol)
	)

func _is_consonent_symbol(symbol: String) -> bool:
	return symbol in [
		"m","p","b","f","v","k","g","l","r","j","w","h",
		"n","t","d","s","z","ŋ","θ","ð","ʃ","ʒ","ʧ","ʤ"
	]

func _is_vowel_symbol(symbol: String) -> bool:
	return symbol in [
		"a","ɑ","ᴀ","ᴜ","e","ᴇ","i","ɪ","o","ᴏ","u","ʌ",
		#   aw  ai  au      ei     ih      oi      uh
	]

func _next_symbol(line: String) -> Result:
	if line.is_empty():
		return Result.new(false)
	var raw_char = line[0]
	var raw_char_2 = ""
	if line.length() >= 2:
		raw_char_2 = line[1]

	if _is_raw_simple_consonent(raw_char) or _is_valid_punctuation(raw_char):
		return Result.new(true, line.substr(1), raw_char)
	elif _is_raw_dependent_consonent(raw_char):
		return _get_symbol_for_dependent_consonent(line, raw_char, raw_char_2)
	elif _is_raw_vowel(raw_char):
		return _get_symbol_for_vowel(line, raw_char, raw_char_2)
	else:
		print("LanguageConverter: Failed to identify \"%s\"" % raw_char)
		return Result.new(false)

func _get_symbol_for_dependent_consonent(line: String, raw_char: String, dchar: String) -> Result:
	assert(_is_raw_dependent_consonent(raw_char))
	match raw_char:
		"n":
			if dchar == "g":
				return Result.new(true, line.substr(2), "ŋ")
			else:
				return Result.new(true, line.substr(1), "n")
		"t":
			if dchar == "h":
				return Result.new(true, line.substr(2), "θ")
			else:
				return Result.new(true, line.substr(1), "t")
		"d":
			if dchar == "h":
				return Result.new(true, line.substr(2), "ð")
			elif dchar == "j":
				return Result.new(true, line.substr(2), "ʤ")
			else:
				return Result.new(true, line.substr(1), "d")
		"c":
			if dchar == "h":
				return Result.new(true, line.substr(2), "ʧ")
			else:
				print("LanguageConverter: Dependent consonent parse failure \"%s\", \"%s\"" % [raw_char, dchar])
				assert(dchar == "h")
				return Result.new(false)
		"s":
			if dchar == "h":
				return Result.new(true, line.substr(2), "ʃ")
			else:
				return Result.new(true, line.substr(1), "s")
		"z":
			if dchar == "h":
				return Result.new(true, line.substr(2), "ʒ")
			else:
				return Result.new(true, line.substr(1), "z")
	# Just in case, should never reach here
	print("LanguageConverter: Dependent consonent fallthrough \"%s\", \"%s\"" % [raw_char, dchar])
	return Result.new(false)

func _get_symbol_for_vowel(line: String, raw_char: String, dchar: String) -> Result:
	assert(_is_raw_vowel(raw_char))
	match raw_char:
		"a":
			if dchar == "w":
				return Result.new(true, line.substr(2), "ɑ")
			elif dchar == "u":
				return Result.new(true, line.substr(2), "ᴜ")
			elif dchar == "i":
				return Result.new(true, line.substr(2), "ᴀ")
			elif dchar == "_":
				return Result.new(true, line.substr(2), "a")
			else:
				return Result.new(true, line.substr(1), "a")
		"i":
			if dchar == "h":
				return Result.new(true, line.substr(2), "ɪ")
			elif dchar == "_":
				return Result.new(true, line.substr(2), "i")
			else:
				return Result.new(true, line.substr(1), "i")
		"e":
			if dchar == "i":
				return Result.new(true, line.substr(2), "ᴇ")
			elif dchar == "_":
				return Result.new(true, line.substr(2), "e")
			else:
				return Result.new(true, line.substr(1), "e")
		"o":
			if dchar == "i":
				return Result.new(true, line.substr(2), "ᴏ")
			elif dchar == "_":
				return Result.new(true, line.substr(2), "o")
			else:
				return Result.new(true, line.substr(1), "o")
		"u":
			if dchar == "h":
				return Result.new(true, line.substr(2), "ʌ")
			elif dchar == "_":
				return Result.new(true, line.substr(2), "u")
			else:
				return Result.new(true, line.substr(1), "u")
	# Just in case, should never reach here
	print("LanguageConverter: Raw vowel fallthrough \"%s\", \"%s\"" % [raw_char, dchar])
	return Result.new(false)

## UNICODE
func _is_valid_unicode(unicode: String) -> bool:
	var unicode_integer = unicode.unicode_at(0)
	return unicode_integer >= UNICODE_OFFSET and unicode_integer < (UNICODE_OFFSET + TOTAL_COMBINATIONS)

func _next_unicode(line: String) -> Result:
	if line.is_empty():
		return Result.new(false)
	var symbol = line[0]
	var should_combine = _is_consonent_symbol(symbol) and line.length() > 1 and _is_vowel_symbol(line[1])
	if should_combine:
		return _get_combined_unicode(line, symbol, line[1])
	return _get_unicode(line, symbol)

func _get_unicode_integer(symbol) -> int:
	assert(_is_valid_symbol(symbol))
	match symbol:
		# Punctutation
		# 	Order:
		#		No particular reasoning
		#	Value:
		#		i + UNICODE_OFFSET
		#	10 values are reserved, only some are used
		" ":
			return 0 + UNICODE_OFFSET
		".":
			return 1 + UNICODE_OFFSET
		",":
			return 2 + UNICODE_OFFSET
		"?":
			return 3 + UNICODE_OFFSET
		"!":
			return 4 + UNICODE_OFFSET
		# 5-9 are currently reserved but not used

		# Vowels
		# 	Order:
		#		clockwise from the top,
		#		then clockwise i dipthongs,
		# 		then au
		#	Value:
		#		i + PUNCTUATIONS + UNICODE_OFFSET
		"i":
			return 0 + PUNCTUATIONS + UNICODE_OFFSET
		"u":
			return 1 + PUNCTUATIONS + UNICODE_OFFSET
		"o":
			return 2 + PUNCTUATIONS + UNICODE_OFFSET
		"ɑ":
			return 3 + PUNCTUATIONS + UNICODE_OFFSET
		"ʌ":
			return 4 + PUNCTUATIONS + UNICODE_OFFSET
		"a":
			return 5 + PUNCTUATIONS + UNICODE_OFFSET
		"e":
			return 6 + PUNCTUATIONS + UNICODE_OFFSET
		"ɪ":
			return 7 + PUNCTUATIONS + UNICODE_OFFSET
		"ᴏ":
			return 8 + PUNCTUATIONS + UNICODE_OFFSET
		"ᴇ":
			return 9 + PUNCTUATIONS + UNICODE_OFFSET
		"ᴀ":
			return 10 + PUNCTUATIONS + UNICODE_OFFSET
		"ᴜ":
			return 11 + PUNCTUATIONS + UNICODE_OFFSET

		# Consonents
		#		Order follows IPA chart
		#		Value is ((VOWELS+1)*i) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"m":
			return ((VOWELS+1)*0) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"n":
			return ((VOWELS+1)*1) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"ŋ":
			return ((VOWELS+1)*2) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"p":
			return ((VOWELS+1)*3) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"b":
			return ((VOWELS+1)*4) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"t":
			return ((VOWELS+1)*5) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"d":
			return ((VOWELS+1)*6) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"k":
			return ((VOWELS+1)*7) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"g":
			return ((VOWELS+1)*8) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"f":
			return ((VOWELS+1)*9) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"v":
			return ((VOWELS+1)*10) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"θ":
			return ((VOWELS+1)*11) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"ð":
			return ((VOWELS+1)*12) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"s":
			return ((VOWELS+1)*13) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"z":
			return ((VOWELS+1)*14) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"ʃ":
			return ((VOWELS+1)*15) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"ʒ":
			return ((VOWELS+1)*16) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"ʧ":
			return ((VOWELS+1)*17) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"ʤ":
			return ((VOWELS+1)*18) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"h":
			return ((VOWELS+1)*19) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"w":
			return ((VOWELS+1)*20) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"l":
			return ((VOWELS+1)*21) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"r":
			return ((VOWELS+1)*22) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
		"j":
			return ((VOWELS+1)*23) + PUNCTUATIONS + VOWELS + UNICODE_OFFSET
	return -1

func _get_unicode(line, symbol) -> Result:
	var integer = _get_unicode_integer(symbol)
	if integer == -1:
		return Result.new(false)
	else:
		var unicode = String.chr(integer)
		assert(not unicode.is_empty())
		assert(_is_valid_unicode(unicode))
		return Result.new(true, line.substr(1), unicode)

func _get_combined_unicode(line, c, v) -> Result:
	var ci = _get_unicode_integer(c)
	var vi = _get_unicode_integer(v)
	if ci == -1 or vi == -1:
		return Result.new(false)
	else:
		# When we combine a consonent and a vowel, we have to
		# not "double count" the offsets that both share!
		var CV_SHARED_OFFSETS = UNICODE_OFFSET + PUNCTUATIONS
		var unicode = String.chr(ci + vi - CV_SHARED_OFFSETS)
		assert(not unicode.is_empty())
		assert(_is_valid_unicode(unicode))
		return Result.new(true, line.substr(2), unicode)
