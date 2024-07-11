class_name HealthComponent extends Node2D

### Variables
@export var current_hp: int = 100
@export var max_hp: int = 100

### Signals
signal on_heal(amount)
signal on_damage(amount, type, direction)
signal on_death

### Engine Functions
func _ready() -> void:
	assert(current_hp <= max_hp, "current_hp shouldn't be higher than max_hp")
	if current_hp > max_hp:
		current_hp = max_hp

### Public Functions
func heal(amount: int):
	var missing = max_hp - current_hp
	var final_amount = min(amount, missing)
	current_hp += final_amount
	on_heal.emit(final_amount)

func damage(amount: int, type: DamageComponent.DamageType, direction: Vector2):
	print("damage received %s (%s)" % [amount, type])
	if amount < current_hp:
		current_hp -= amount
		on_damage.emit(amount, type, direction)
	else:
		var remaining_hp = current_hp
		current_hp = 0
		on_damage.emit(min(remaining_hp, amount), type, direction)
		on_death.emit()

### Private Functions
