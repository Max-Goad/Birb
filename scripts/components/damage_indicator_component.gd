class_name DamageIndicatorComponent extends Node2D

const pl_damage_indicator = preload("res://resources/ui/damage_indicator.tscn")

### Variables
@export var health_component: HealthComponent

@export var speed = 0.5
@export var ignore_zero = true
@export var damage_color = Color.BROWN
@export var heal_color = Color.PALE_GREEN
@export var position_dither = 50
@export_range(0,100) var color_dither = 0

### Signals

### Engine Functions
func _ready() -> void:
	assert(health_component != null, "missing health component")
	health_component.on_damage.connect(_on_health_damage)
	health_component.on_heal.connect(_on_health_heal)

### Public Functions

### Private Functions
func _on_health_damage(amount: int, _type: DamageComponent.DamageType, _direction: Vector2):
	if amount == 0 and ignore_zero:
		return
	_spawn_damage_indicator(-amount, damage_color)


func _on_health_heal(amount: int):
	if amount == 0 and ignore_zero:
		return
	_spawn_damage_indicator(amount, heal_color)

func _spawn_damage_indicator(amount: int, color: Color = Color.WHITE):
	var di = pl_damage_indicator.instantiate()
	di.position = Math.dither_v_pos(self.get_parent().position + self.position, self.position_dither)
	di.scale = self.scale
	di.damage = amount
	di.color = Math.dither_c(color, float(self.color_dither)/100)
	di.speed = speed
	di.top_level = true # Detach movement (transforms) from parent once spawned
	add_child(di)
