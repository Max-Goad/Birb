extends Node

const _FILL_WITH_NULL = true
const _DO_NOT_FILL_WITH_NULL = false

### Variables
var active_slots: Array[Ability] = []
var passive_slots: Array[Ability] = []
var current_active: Ability = NullAbility.new()

### Signals
signal ability_set(category, slot, ability)
signal ability_reset(category, slot)
signal ability_executed(slot, cooldown)
signal ability_ready(slot)
signal ability_canceled(slot) # TODO: Currently unused

### Engine Functions
func _ready() -> void:
	Data.ability_slot_unlocked.connect(_on_ability_slot_unlocked)

### Public Functions
func has_ability(category: Ability.Category, slot: int) -> bool:
	return Data.ability_slots_unlocked(category) > slot

func get_ability(category: Ability.Category, slot: int) -> Ability:
	assert(has_ability(category, slot))
	return _get_slots(category)[slot]

func find_ability_slot(category: Ability.Category, ability: Ability) -> int:
	var slots := _get_slots(category)
	for i in slots.size():
		if slots[i] == ability:
			return i
	return -1

func set_ability(category: Ability.Category, slot: int, component: CraftingComponent):
	var slots: Array[Ability] = _get_slots(category)
	var slot_is_in_cooldown = slots[slot] and not slots[slot].ready()
	var is_default_component = component.id == Data.default_component.id
	var is_reassign = slots[slot] and component == slots[slot].info
	var ability: Ability
	# Cannot reassign slot that is currently in cooldown
	if slot_is_in_cooldown:
		return
	# Default component is mapped to NullAbility
	elif is_default_component:
		ability = NullAbility.new()
	# Reassigning the same ability to the same slot
	# results in the slot resetting to NullAbility
	elif is_reassign:
		ability = NullAbility.new()
	# Otherwise get the corresponding ability
	elif component in Data.abilities:
		ability = Data.abilities[component]
	else:
		print("trying to use component that doesn't have an ability!")
		return
	# Unset slot and leave empty (NOT null)
	unset_ability(category, slot, _DO_NOT_FILL_WITH_NULL)
	# SPECIAL: If this ability is already assigned to a DIFFERENT slot,
	#		   reset THAT slot as well (and fill it with null)
	if not is_default_component and find_ability_slot(category, ability) != -1:
		unset_ability(category, find_ability_slot(category, ability), _FILL_WITH_NULL)

	print("set ability %s as %s" % [slot, ability.info.label])
	_assign_ability_to_slot(category, ability, slot)
	ability.on_set()
	ability_set.emit(category, slot, ability)

# TODO: Should this be private?
func unset_ability(category: Ability.Category, slot: int, fill_with_null: bool):
	print("unset ability %s" % [slot])
	var ability: Ability = _get_slots(category)[slot]
	if ability == null:
		pass
	elif ability.is_null():
		ability.queue_free()
	else:
		ability.finished.disconnect(_on_ability_finished.bind(slot))
		ability.cooldown_complete.disconnect(_on_ability_cooldown.bind(slot))
		ability.on_unset()
		remove_child(ability)
		if fill_with_null:
			_assign_ability_to_slot(category, NullAbility.new(), slot)
		ability_reset.emit(category, slot)


# Only active abilities can be executed (theoretically)
# but I kept the naming scheme to be consistent
func execute_ability(slot: int, executer: Player, direction: Vector2) -> bool:
	print("execute ability in slot %s" % slot)
	if has_ability(Ability.Category.ACTIVE, slot):
		var ability = get_ability(Ability.Category.ACTIVE, slot)
		if ability.is_null():
			print("execute ability is null")
			return false
		if not ability.ready():
			print("execute ability not ready")
			return false
		current_active = ability
		current_active.execute(executer, direction)
		ability_executed.emit(slot, current_active.cooldown)
		print("execute ability success")
		return true
	else:
		print("execute ability slot %s doesn't exist" % slot)
		return false

### Private Functions
func _get_slots(category: Ability.Category) -> Array[Ability]:
	match category:
		Ability.Category.ACTIVE:
			return active_slots
		Ability.Category.PASSIVE:
			return passive_slots
		_:
			assert(true)
			return []

func _on_ability_finished(_slot: int):
	call_deferred("_clear_current_active")

func _clear_current_active():
	current_active = NullAbility.new()

func _on_ability_cooldown(slot: int):
	print("ability %s cooldown finished" % slot)
	ability_ready.emit(slot)

func _on_ability_slot_unlocked(category: Ability.Category, total_slots: int):
	var slots = _get_slots(category)
	var existing_slots = slots.size()
	var slots_unlocked = total_slots - existing_slots
	slots.resize(total_slots)
	for i in slots_unlocked:
		set_ability(category, existing_slots + i, CraftingComponent.new())

func _assign_ability_to_slot(category: Ability.Category, ability: Ability, slot: int):
	ability.finished.connect(_on_ability_finished.bind(slot))
	ability.cooldown_complete.connect(_on_ability_cooldown.bind(slot))
	add_child(ability)
	_get_slots(category)[slot] = ability
