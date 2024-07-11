class_name AbilitySlotGroup extends HBoxContainer

const template = preload("res://resources/attacks/ability_slot.tscn")

### Variables
@export var selectable = false
@export var category: Ability.Category = Ability.Category.ACTIVE

var currently_unlocked = 0

### Signals

### Engine Functions
func _ready() -> void:
	Data.ability_slot_unlocked.connect(_on_unlocked)
	clear()

### Public Functions
func clear():
	for child in get_children():
		child.queue_free()

### Private Functions
func _on_unlocked(category: Ability.Category, new_total: int):
	if category != self.category:
		return
	print("ui handling ability slot unlocked (%s -> %s)" % [currently_unlocked, new_total])
	var new_slots = new_total - currently_unlocked
	for i in new_slots:
		var new_slot = template.instantiate()
		new_slot.slot_id = currently_unlocked + i
		new_slot.category = category
		if not selectable:
			new_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(new_slot)
		print("new ability slot created")
	currently_unlocked = new_total

