class_name AbilitySlotGroup extends HBoxContainer

const template = preload("res://resources/attacks/ability_slot.tscn")

#region Variables
@export var selectable = false
@export var category: Ability.Category = Ability.Category.ACTIVE

var currently_unlocked = 0
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	Data.save_requested.connect(on_save)
	Data.load_requested.connect(on_load)
	Data.unload_requested.connect(on_unload)
	Data.ability_slot_unlocked.connect(_unlock_new_slot)
	clear()
#endregion

#region Public Functions
func clear():
	for child in get_children():
		child.queue_free()

func on_save(_data: SaveData) -> void:
	pass

func on_load(data: SaveData) -> void:
	for _i in data.active_ability_slots_unlocked:
		_unlock_new_slot(Ability.Category.ACTIVE)
	for _i in data.passive_ability_slots_unlocked:
		_unlock_new_slot(Ability.Category.PASSIVE)

func on_unload() -> void:
	currently_unlocked = 0
	clear()
#endregion

#region Private Functions
func _unlock_new_slot(category: Ability.Category):
	if category != self.category:
		return
	var new_slot = template.instantiate()
	new_slot.slot_id = currently_unlocked
	new_slot.category = category
	if not selectable:
		new_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(new_slot)
	print("AbilitySlotGroup: new ability slot created")
	currently_unlocked += 1
#endregion
