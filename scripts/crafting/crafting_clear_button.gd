class_name CraftingClearButton extends Button

### Variables
@export var root: MenuRoot

### Signals

### Engine Functions
func _ready() -> void:
	assert(root, "MenuRoot not set")

func _pressed() -> void:
	Crafting.clear_slots()

### Public Functions

### Private Functions

