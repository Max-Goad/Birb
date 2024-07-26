extends Node

#region Variables
var current_slots: Array[CraftingComponent]
var current_component: CraftingComponent
var current_recipe_type: CraftingRecipe.Type
#endregion

#region Signals
signal slot_updated(int, CraftingComponent)
signal craft_ready(bool)
signal craft_success
signal craft_failure_not_found
signal craft_failure_already_known
#endregion

#region Engine Functions
func _ready() -> void:
	Data.component_unlocked.connect(_on_component_unlocked)
	Data.recipe_type_unlocked.connect(_on_recipe_type_unlocked)
	clear_slots()
#endregion

#region Public Functions
func select_recipe_type(type: CraftingRecipe.Type):
	assert(Data.is_recipe_type_unlocked(type), "attempting to select locked recipe type")
	match type:
		CraftingRecipe.Type.L_CRAFTING:
			current_slots.resize(3)
		CraftingRecipe.Type.TXT_CRAFTING:
			current_slots.resize(9)
	current_recipe_type = type

func select_slot(slot_index, current):
	update_slot(slot_index, current)
	if _get_matching_recipe(_current_slot_components()) != null:
		craft_ready.emit(true)
	else:
		craft_ready.emit(false)

func clear_slots():
	update_all_slots(Data.default_component)
	craft_ready.emit(false)

func update_slot(i, c: CraftingComponent):
	# TODO: Is this "toggle" behavior what I want long-term?
	if current_slots[i] == c:
		c = Data.default_component
	print("Crafting: update slot (%s) with (%s)" % [i,c.label])
	current_slots[i] = c
	slot_updated.emit(i, c)

func update_all_slots(c: CraftingComponent):
	for i in current_slots.size():
		update_slot(i, c)

func craft():
	for recipe in Data.recipes:
		if recipe.type != current_recipe_type:
			continue
		if recipe.components == _current_slot_components():
			var result_component: CraftingComponent = Data.components_by_name[recipe.result]
			if Data.is_component_unlocked(result_component.id):
				print("Crafting: recipe result already known...")
				craft_failure_already_known.emit()
			else:
				print("Crafting: matched recipe!")
				Data.unlock_component(result_component)
				craft_success.emit()
			return
	# else
	craft_failure_not_found.emit()
#endregion

#region Private Functions
func _current_slot_components() -> Array[String]:
	var out: Array[String] = []
	for slot in current_slots:
		if slot.id == CraftingComponent.empty_id:
			out.append(CraftingRecipe.empty_char)
		else:
			out.append(slot.label)
	return out

func _get_matching_recipe(components: Array[String], skip_known = true) -> CraftingRecipe:
	for recipe in Data.recipes:
		if recipe.type != current_recipe_type:
			continue
		if skip_known and Data.is_component_unlocked(Data.components_by_name[recipe.result].id):
			continue
		if recipe.components == components:
			return recipe
	return null

func _on_component_unlocked(_component: CraftingComponent):
	pass

func _on_recipe_type_unlocked(_recipe_type: CraftingRecipe.Type):
	pass
#endregion
