class_name CraftingFileParser

const split_char = ","

#region Variables
var file: FileAccess

var next_id = 0
var components: Array[CraftingComponent] = []
var recipes: Array[CraftingRecipe] = []
#endregion

#region Engine Functions
func _init(filename: String = "") -> void:
	self.file = FileAccess.open(filename, FileAccess.READ)
#endregion

#region Public Functions
func parse() -> bool:
	while true:
		var line = _next_line(self.file)
		if not line or self.file.eof_reached():
			return true
		# 3 splits: Comp, CompType, RecipeType, Recipe
		var parts = line.split(split_char, true, 3)
		var label = parts[0]
		var type = parts[1]
		var rtype = parts[2]
		var repeat_component = type == "R"
		var has_no_recipe = rtype == "N"
		if not repeat_component:
			var new_component = CraftingComponent.new(self.next_id, label, _parse_component_type(type))
			components.append(new_component)
			self.next_id += 1
		if not has_no_recipe:
			var raw_recipe = parts[3]
			self.recipes.append_array(_parse_recipe(label, rtype, raw_recipe))
	return false
#endregion

#region Private Functions
func _next_line(file: FileAccess) -> String:
	while not file.eof_reached():
		var line = file.get_line()
		if not line or line.begins_with("#"):
			continue
		else:
			return line
	return ""

func _parse_component_type(raw) -> CraftingComponent.Type:
	match raw:
		"A":
			return CraftingComponent.Type.ATTACK
		"S":
			return CraftingComponent.Type.SUPPORT
		"P":
			return CraftingComponent.Type.PASSIVE
		"U":
			return CraftingComponent.Type.UNLOCK
		"X":
			return CraftingComponent.Type.SPECIAL
		_:
			assert(true)
			return CraftingComponent.Type.NONE

func _parse_recipe(result, type, raw_recipe: String) -> Array[CraftingRecipe]:
	var recipe = CraftingRecipe.new()
	recipe.result = result
	match type:
		"N": # No recipe
			return []
		"H": # Horizontal L Crafting
			recipe.type = CraftingRecipe.Type.L_CRAFTING
			recipe.components = _generate_H_components(raw_recipe)
			return [recipe] as Array[CraftingRecipe] + _generate_3_recipes_from_H_recipe(recipe)
		"V": # Vertical L Crafting
			recipe.type = CraftingRecipe.Type.L_CRAFTING
			recipe.components = _generate_V_components(raw_recipe)
			return [recipe] as Array[CraftingRecipe] + _generate_3_recipes_from_V_recipe(recipe)
		"L": # L Crafting
			recipe.type = CraftingRecipe.Type.L_CRAFTING
			recipe.components = _generate_L_components(raw_recipe)
			return [recipe] as Array[CraftingRecipe] + _generate_3_recipes_from_L_recipe(recipe)
		"3": # 3x3 Crafting
			recipe.type = CraftingRecipe.Type.TXT_CRAFTING
			recipe.components = _generate_3_components(raw_recipe)
			return [recipe] as Array[CraftingRecipe]
		_:
			assert(true, "error parsing recipe - %s, %s, %s" % [result, type, raw_recipe])
			return []

func _generate_H_components(h: String) -> Array[String]:
	var h_components: Array[String] = []
	h_components.assign(h.split(split_char))
	assert(h_components.size() == 2, "Incorrect H array passed: %s" % h)
	h_components.append(CraftingRecipe.empty_char)
	return h_components

func _generate_V_components(v: String) -> Array[String]:
	var v_components: Array[String] = []
	v_components.assign(v.split(split_char))
	assert(v_components.size() == 2, "Incorrect V array passed: %s" % v)
	return [v_components[0], CraftingRecipe.empty_char, v_components[1]]

func _generate_L_components(l: String) -> Array[String]:
	var l_components: Array[String] = []
	l_components.assign(l.split(split_char))
	assert(l_components.size() == 3, "Incorrect L array passed: %s" % l)
	return l_components

func _generate_3_components(txt: String) -> Array[String]:
	var txt_components: Array[String] = []
	txt_components.assign(txt.split(split_char))
	assert(txt_components.size() == 9, "Incorrect 3 array passed: %s" % txt)
	return txt_components

func _generate_3_recipes_from_H_recipe(h: CraftingRecipe) -> Array[CraftingRecipe]:
	var recipes: Array[CraftingRecipe] = []
	var left = h.components[0]
	var right = h.components[1]
	for i in 3:
		for j in 2:
			var recipe = CraftingRecipe.new()
			recipe.result = h.result
			recipe.type = CraftingRecipe.Type.TXT_CRAFTING
			recipe.components = CraftingRecipe.empty_comp.duplicate()
			recipe.components[(i*3)+j] = left
			recipe.components[(i*3)+j+1] = right
			recipes.append(recipe)
	return recipes

func _generate_3_recipes_from_V_recipe(v: CraftingRecipe) -> Array[CraftingRecipe]:
	var recipes: Array[CraftingRecipe] = []
	var top = v.components[0]
	var bottom = v.components[2]
	for i in 2:
		for j in 3:
			var recipe = CraftingRecipe.new()
			recipe.result = v.result
			recipe.type = CraftingRecipe.Type.TXT_CRAFTING
			recipe.components = CraftingRecipe.empty_comp.duplicate()
			recipe.components[(i*3)+j] = top
			recipe.components[(i*3)+j+3] = bottom
			recipes.append(recipe)
	return recipes

func _generate_3_recipes_from_L_recipe(l: CraftingRecipe) -> Array[CraftingRecipe]:
	var recipes: Array[CraftingRecipe] = []
	var corner = l.components[0]
	var right = l.components[1]
	var bottom = l.components[2]
	for i in 2:
		for j in 2:
			var recipe = CraftingRecipe.new()
			recipe.result = l.result
			recipe.type = CraftingRecipe.Type.TXT_CRAFTING
			recipe.components = CraftingRecipe.empty_comp.duplicate()
			recipe.components[(i*3)+j] = corner
			recipe.components[(i*3)+j+1] = right
			recipe.components[(i*3)+j+3] = bottom
			recipes.append(recipe)
	return recipes
#endregion
