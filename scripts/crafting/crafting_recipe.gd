class_name CraftingRecipe extends Resource

### Enum
enum Type {
	DEBUG = 0,
	L_CRAFTING,
	TXT_CRAFTING
}

static func type_to_string(type: Type) -> String:
	match type:
		Type.L_CRAFTING:
			return "L"
		Type.TXT_CRAFTING:
			return "3"
		_:
			return "?"

### Variables
const empty_char = "_"
const empty_comp: Array[String] = [ empty_char,empty_char,empty_char,
									empty_char,empty_char,empty_char,
									empty_char,empty_char,empty_char]

@export var result: String
@export var type: Type
@export var components: Array[String]

### Engine Functions
func _init(result = empty_char, type = Type.DEBUG, components: Array[String] = []) -> void:
	self.result = result
	self.type = type
	self.components = components

func _to_string() -> String:
	return "CraftingRecipe[%s,%s,%s]" % [result, CraftingRecipe.type_to_string(type), components]

### Public Functions
