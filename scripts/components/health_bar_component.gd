extends Node2D

### Variables
@export var health_component: HealthComponent
@export var hide_when_full: bool = false
@export var hide_when_empty: bool = true

@onready var health_bar: ProgressBar = $"Health Bar"

### Signals

### Engine Functions
func _ready() -> void:
	assert(health_component != null, "missing health component")
	health_bar.max_value = health_component.max_hp
	health_bar.value = health_component.current_hp
	health_component.on_damage.connect(_on_health_damage)
	health_component.on_heal.connect(_on_health_heal)
	_update_visibility()

### Public Functions

### Private Functions
func _on_health_damage(amount: int, _type: DamageComponent.DamageType, _direction: Vector2):
	health_bar.change_value(-amount)
	_update_visibility()


func _on_health_heal(amount: int):
	health_bar.change_value(amount)
	_update_visibility()

func _update_visibility():
	var full = health_component.current_hp >= health_component.max_hp
	var empty = health_component.current_hp <= 0
	print("HealthBarComponent: curr %s, max %s" % [health_component.current_hp, health_component.max_hp])
	print("HealthBarComponent: full %s, hwf %s, empty %s, hwe %s" % [full, hide_when_full, empty, hide_when_empty])
	if (full and hide_when_full) or (empty and hide_when_empty):
		self.visible = false
	else:
		self.visible = true
