class_name MultiButton extends Control

### Variables
enum Type
{
	NULL = 0,
	POSITIVE = 1,
	NEGATIVE = 2,
	CANCEL = 3,
	QUIT = 4,
	SAVE = 5,
	LOAD = 6,

	CHOICE_1 = 101,
	CHOICE_2 = 102,
	CHOICE_3 = 103,
	CHOICE_4 = 104,
	CHOICE_5 = 105,
	CHOICE_6 = 106,
	CHOICE_7 = 107,
	CHOICE_8 = 108,
	CHOICE_9 = 109,
}

static func to_str(type : MultiButton.Type) -> String:
	for i in range(MultiButton.Type.keys().size()):
		var key = MultiButton.Type.keys()[i]
		var value = MultiButton.Type.values()[i]
		if type == value:
			return key
	assert(false, "ERROR MultiButton.Type.to_str() %s" % type)
	return "ERROR MultiButton.Type.to_str() %s" % type

@export var pairs: Array[MultiButtonPair]

### Signals
signal pressed(Type)

### Public Functions
func has_button(type: Type) -> bool:
	return get_button(type) != null

func get_button(type: Type) -> BaseButton:
	for pair in pairs:
		if pair.type == type:
			return get_node(pair.button)
	return null

### Engine Functions
func _ready() -> void:
	_verify_buttons()
	_setup_button_callbacks()

### Private Functions
func _verify_buttons():
	var type_set = []
	for pair in pairs:
		assert(pair.type not in type_set, "Duplicate button types in ButtonContainer")
		if pair.type not in type_set:
			type_set.push_back(pair.type)
		assert(pair.button, "Missing button node path")

func _setup_button_callbacks():
	for pair in pairs:
		var button: BaseButton = get_node(pair.button)
		button.pressed.connect(func(): self.pressed.emit(pair.type))
