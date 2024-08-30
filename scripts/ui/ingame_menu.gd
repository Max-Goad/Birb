class_name InGameMenu extends TabContainer

enum Tabs {
	ABILITIES = 0,
	L_CRAFTING,
	TXT_CRAFTING,
	SETTINGS
}

#region Variables
@export var root: MenuRoot

@onready var save_menu: SaveMenu = %"Save Menu"
@onready var settings_menu: Settings = %"Settings Menu"
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(root, "MenuRoot not set")
	self.tab_changed.connect(_on_tab_changed)
	self.set_tab_hidden(Tabs.ABILITIES, false)
	self.set_tab_hidden(Tabs.L_CRAFTING, true)
	self.set_tab_hidden(Tabs.TXT_CRAFTING, true)
	self.set_tab_hidden(Tabs.SETTINGS, false)

	save_menu.save_requested.connect(_on_save_requested)
	save_menu.load_requested.connect(_on_load_requested)
	save_menu.delete_requested.connect(_on_delete_requested)
	# The Save/Settings menus are reusable and has their own close button
	# Let's leverage them to close the menu too
	save_menu.close_requested.connect(func(): root.closed.emit())
	settings_menu.close_requested.connect(func(): root.closed.emit())
	Data.recipe_type_unlocked.connect(_on_recipe_type_unlocked)
	Data.notify_available_components()
	Data.notify_available_recipe_types()
#endregion

#region Public Functions
#endregion

#region Private Functions
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

func _on_save_requested(slot: int, save_name: String):
	Data.save_file(slot, save_name)
	save_menu.refresh_save_slot_data()

func _on_load_requested(slot: int):
	Data.load_file(slot)
	# We close the whole menu on loads to avoid possible
	# strange side-effects of keeping the menu open.
	root.closed.emit()

func _on_delete_requested(slot: int):
	Data.erase_file(slot)
	save_menu.refresh_save_slot_data()
#endregion
