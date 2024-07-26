class_name CraftingClearButton extends Button

#region Variables
@export var root: MenuRoot
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(root, "MenuRoot not set")

func _pressed() -> void:
	Crafting.clear_slots()
#endregion

#region Public Functions
#endregion

#region Private Functions
#endregion

