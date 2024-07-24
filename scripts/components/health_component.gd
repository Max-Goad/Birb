class_name HealthComponent extends Node2D

### Variables
@export var current_hp: int = 100
@export var max_hp: int = 100
@export var invul_seconds: float = 0.0

var invul_timer: Timer

var damage_modifier_fn = Callable()
var heal_modifier_fn = Callable()

### Signals
signal on_heal(amount)
signal on_damage(amount, type, direction)
signal on_invulnerable_start
signal on_invulnerable_stop
signal on_death

### Engine Functions
func _ready() -> void:
	assert(current_hp <= max_hp, "current_hp shouldn't be higher than max_hp")
	if current_hp > max_hp:
		current_hp = max_hp
	invul_timer = Timer.new()
	invul_timer.one_shot = true
	invul_timer.timeout.connect(func(): on_invulnerable_stop.emit())
	add_child(invul_timer)

### Public Functions
func heal(amount: int):
	if heal_modifier_fn.is_valid():
		var original_amount = amount
		amount = amount * heal_modifier_fn.call()
		print("HealthComponent: heal mod (%s -> %s)" % [original_amount, amount])
	var missing = max_hp - current_hp
	var final_amount = min(amount, missing)
	current_hp += final_amount
	on_heal.emit(final_amount)

# Return value indicates whether the damage is "ignored" or not
# This indicates to the damage source whether to consider the
# collision valid or whether the damage should continue to another body
func damage(amount: int, type: DamageComponent.DamageType, direction: Vector2) -> bool:
	if invulnerable():
		print("HealthComponent: invulnerable, ignoring %s damage" % amount)
		return false
	if damage_modifier_fn.is_valid():
		var original_amount = amount
		amount = amount * damage_modifier_fn.call()
		print("HealthComponent: damage mod (%s -> %s)" % [original_amount, amount])
	print("HealthComponent: damage received %s (%s)" % [amount, type])
	if amount < current_hp:
		current_hp -= amount
		on_damage.emit(amount, type, direction)
		set_invulnerable()
	else:
		var remaining_hp = current_hp
		current_hp = 0
		on_damage.emit(min(remaining_hp, amount), type, direction)
		on_death.emit()
	return true

func invulnerable() -> bool:
	return not invul_timer.is_stopped()

func set_invulnerable(sec: float = self.invul_seconds):
	# TODO: Should this check be done OUTSIDE or INSIDE this function?
	# 	    If it's inside, we can't technically "reset" or "override"
	if not invulnerable() and sec > 0.0:
		invul_timer.start(sec)
		on_invulnerable_start.emit()

### Private Functions
