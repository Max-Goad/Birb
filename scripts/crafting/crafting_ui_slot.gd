class_name CraftingUISlot extends PanelContainer

### Variables
@export var slot_index: int = -1
@export var root: MenuRoot

var component: CraftingComponent
@onready var label: Label = $Label

### Engine Functions
func _ready() -> void:
	assert(root, "MenuRoot not set")
	Crafting.slot_updated.connect(_on_slot_updated)

### Private Functions
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		Crafting.select_slot(slot_index, Crafting.current_component)

func _on_slot_updated(slot_index, component):
	if slot_index == self.slot_index:
		self.component = component
		label.text = component.label
