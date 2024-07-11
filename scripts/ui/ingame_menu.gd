class_name InGameMenu extends TabContainer

enum Tabs {
	ABILITIES = 0,
	L_CRAFTING,
	TXT_CRAFTING,
}

### Variables
@export var root: MenuRoot

### Signals

### Engine Functions
func _ready() -> void:
	assert(root, "MenuRoot not set")
	self.tab_changed.connect(_on_tab_changed)
	self.set_tab_hidden(Tabs.ABILITIES, false)
	self.set_tab_hidden(Tabs.L_CRAFTING, true)
	self.set_tab_hidden(Tabs.TXT_CRAFTING, true)
	Data.recipe_type_unlocked.connect(_on_recipe_type_unlocked)
	Data.notify_available_components()
	Data.notify_available_recipe_types()

### Public Functions

### Private Functions
func _on_tab_changed(tab_id: int):
	match tab_id:
		Tabs.L_CRAFTING:
			Crafting.select_recipe_type(CraftingRecipe.Type.L_CRAFTING)
		Tabs.TXT_CRAFTING:
			Crafting.select_recipe_type(CraftingRecipe.Type.TXT_CRAFTING)
	Crafting.clear_slots()

func _on_recipe_type_unlocked(type: CraftingRecipe.Type):
	match type:
		CraftingRecipe.Type.L_CRAFTING:
			self.set_tab_hidden(Tabs.L_CRAFTING, false)
		CraftingRecipe.Type.TXT_CRAFTING:
			self.set_tab_hidden(Tabs.TXT_CRAFTING, false)
