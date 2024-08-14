@tool
extends PanelContainer

@onready var input: TextEdit = $"Section Seperator/Textboxes/Input"
@onready var simplified: TextEdit = $"Section Seperator/Textboxes/Simplified"
@onready var unicode: TextEdit = $"Section Seperator/Textboxes/Unicode Section/Unicode"
@onready var unicode_with_font: TextEdit = $"Section Seperator/Textboxes/Unicode With Font"
@onready var convert_button: Button = $"Section Seperator/Textboxes/Convert and Error/Convert Button"
@onready var error: Label = $"Section Seperator/Textboxes/Convert and Error/Error"
@onready var character_num: Label = $"Section Seperator/Textboxes/Unicode Section/Character Section/Character Num"

var converter: LanguageConverter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	converter = LanguageConverter.new()
	convert_button.pressed.connect(_on_convert)

func _on_convert():
	var simplified_result = converter.string_to_symbols(input.text)
	if not simplified_result.success:
		_error(simplified_result.error)
		return
	var unicode_result = converter.symbols_to_unicode(simplified_result.parsed)
	if not unicode_result.success:
		_error(unicode_result.error)
		return
	_reset()
	simplified.text = simplified_result.parsed
	unicode.text = unicode_result.parsed
	unicode_with_font.text = unicode_result.parsed
	character_num.text = str(unicode_result.parsed.length())

func _reset():
	simplified.text = ""
	unicode.text = ""
	unicode_with_font.text = ""
	character_num.text = ""
	error.text = ""

func _error(text):
	_reset()
	error.text = text
	push_error(text)
