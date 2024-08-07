class_name CraftingButton extends Button

#region Variables
@export var root: MenuRoot
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(root)
	Crafting.craft_ready.connect(_on_craft_ready)
	Crafting.craft_success.connect(self.set_modulate.bind(Color.WHITE))
	Crafting.craft_failure_not_found.connect(self.set_modulate.bind(Color.LIGHT_CORAL))
	Crafting.craft_failure_already_known.connect(self.set_modulate.bind(Color.WHITE))

func _pressed() -> void:
	Crafting.craft()
#endregion

#region Public Functions
#endregion

#region Private Functions
func _on_craft_ready(b: bool):
	if root.debug:
		if b:
			self.modulate = Color.LIGHT_GREEN
		else:
			self.modulate = Color.WHITE
#endregion

