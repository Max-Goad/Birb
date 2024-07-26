class_name CraftingComponentMenu extends GridContainer

const button_template = preload("res://resources/ui/menu_component_grid_button.tscn")

#region Variables
var buttons: Array[Button] = []
var button_group = ButtonGroup.new()
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	_populate_buttons()
	_adjust_columns()
	Data.component_unlocked.connect(_on_component_unlocked)
#endregion

#region Public Functions
func has_button(component: CraftingComponent):
	return component.id < buttons.size()

func get_button(component: CraftingComponent):
	assert(has_button(component), "no button available for id (%s)" % component.id)
	return buttons[component.id]
#endregion

#region Private Functions
func _populate_buttons():
	for child in get_children():
		if child is Button:
			child.button_group = button_group
			child.toggled.connect(_on_button_toggled.bind(buttons.size()))
			buttons.append(child)

func _generate_buttons_until(limit: int):
	while buttons.size() <= limit:
		var new_button = button_template.instantiate()
		new_button.button_group = button_group
		new_button.toggled.connect(_on_button_toggled.bind(buttons.size()))
		buttons.append(new_button)
		add_child(new_button)
		_adjust_columns()

func _adjust_columns():
	# No more than 5 columns (to allow for scroll to activate)
	# Purposefully doing integer division to ignore remainders
	@warning_ignore("integer_division")
	self.columns = min(((buttons.size() - 1) / 7) + 1, 5)

func _on_button_toggled(on: bool, i: int):
	if on:
		Crafting.current_component = Data.components_by_id[i]
	else:
		Crafting.current_component = Data.default_component

func _on_component_unlocked(component: CraftingComponent):
	print("CraftingComponentMenu: component updated (%s)" % component)
	if not has_button(component):
		_generate_buttons_until(component.id)
	var button = get_button(component)
	button.disabled = false
	button.text = component.label
	button.modulate = CraftingComponent.color(component.type)
#endregion
