extends Node

### Save Data Variables
var saves: Array[SaveData]
var current_save: SaveData

# Unrelated data loaded at game start regardless of save data
var components_by_id: Dictionary	# {id:component}
var components_by_name: Dictionary	# {name:component}
var recipes: Array[CraftingRecipe]
var abilities: Dictionary # {component:ability}

var default_component := CraftingComponent.new()
var default_recipe_type := CraftingRecipe.Type.L_CRAFTING

### Misc Variables
const max_save_slot_size: int = 7
const max_save_name_size: int = 20

var crafting_file_parser := CraftingFileParser.new()

### Signals
signal component_unlocked
signal recipe_type_unlocked
signal ability_slot_unlocked(category, total) # always emit total

### Engine Functions
func _ready() -> void:
	# saves.clear()
	# saves.resize(max_slot_size)
	# saves.fill(null)
	_load_game_references()
	load_all_files()
	if save_exists(0):
		load_file(0)
	else:
		current_save = SaveData.new()
	call_deferred("notify_ability_slots", Ability.Category.ACTIVE)
	call_deferred("notify_ability_slots", Ability.Category.PASSIVE)


### Saving / Loading Functions
func file_name(slot: int) -> String:
	return "user://save_data_%d.save" % slot

func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(file_name(slot))

func save_file(slot: int, save_name = "Test"):
	current_save.save_name = save_name
	var save_data_string = JSON.stringify(SaveData.serialize(current_save))
	var file = FileAccess.open(file_name(slot), FileAccess.WRITE)
	file.store_line(save_data_string)

	# The save data loaded into memory has to be updated too
	saves[slot] = current_save
	print("saved file to slot %d: %s" % [slot, save_data_string])

func can_load_file(slot: int):
	return slot < saves.size() and saves[slot] != null

# Deserialize
func load_file(slot: int):
	if slot >= saves.size() or saves[slot] == null:
		assert(false, "bad load")
		return
	clear()
	current_save = saves[slot]
	print("loaded file from slot %d" % slot)


# Take all files and put their Dictionaries into memory
func load_all_files():
	saves.clear()
	saves.resize(max_save_slot_size)
	saves.fill(null)
	for slot in max_save_slot_size:
		if not save_exists(slot):
			continue
		var file = FileAccess.open(file_name(slot), FileAccess.READ)
		var save_string = file.get_line()
		var save_dict = JSON.parse_string(save_string)
		saves[slot] = SaveData.deserialize(save_dict)
		print("loaded slot %d from file: %s" % [slot, save_string])

func erase_file(slot: int):
	if not save_exists(slot):
		return
	DirAccess.remove_absolute(file_name(slot))
	saves[slot] = null

### Misc
func is_component_unlocked(id: int) -> bool:
	return id in current_save.components_unlocked

func unlock_component(component: CraftingComponent) -> void:
	assert(not is_component_unlocked(component.id))
	current_save.components_unlocked[component.id] = null
	component_unlocked.emit(component)

func notify_available_components():
	for id in current_save.components_unlocked:
		component_unlocked.emit(components_by_id[id])

func is_recipe_type_unlocked(type: CraftingRecipe.Type) -> bool:
	return type in current_save.recipe_types_unlocked

func unlock_recipe_type(type: CraftingRecipe.Type) -> void:
	assert(not is_recipe_type_unlocked(type))
	current_save.recipe_types_unlocked[type] = null
	recipe_type_unlocked.emit(type)

func notify_available_recipe_types():
	for id in current_save.recipe_types_unlocked:
		recipe_type_unlocked.emit(id)

func ability_slots_unlocked(category: Ability.Category) -> int:
	if category == Ability.Category.ACTIVE:
		return current_save.active_ability_slots_unlocked
	elif category == Ability.Category.PASSIVE:
		return current_save.passive_ability_slots_unlocked
	else:
		return 0

func unlock_ability_slot(category: Ability.Category, num_unlocked: int) -> void:
	if category == Ability.Category.ACTIVE:
		current_save.active_ability_slots_unlocked += num_unlocked
	elif category == Ability.Category.PASSIVE:
		current_save.passive_ability_slots_unlocked += num_unlocked

	notify_ability_slots(category)

func notify_ability_slots(category: Ability.Category):
	ability_slot_unlocked.emit(category, current_save.active_ability_slots_unlocked)

func clear():
	pass

### Game-Specific Private Functions
func _next_line(file: FileAccess) -> String:
	while not file.eof_reached():
		var line = file.get_line()
		if not line or line.begins_with("#"):
			continue
		else:
			return line
	return ""

func _load_game_references():
	var crafting_file_parser := CraftingFileParser.new("res://resources/data/crafting.txt")
	var success = crafting_file_parser.parse()
	assert(success)
	for component in crafting_file_parser.components:
		self.components_by_id[component.id] = component
		self.components_by_name[component.label] = component
	self.recipes = crafting_file_parser.recipes
	_generate_abilities()

func _generate_abilities():
	for component in components_by_id.values():
		abilities[component] = Ability.from_component(component)
