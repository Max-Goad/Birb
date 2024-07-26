class_name KnockbackComponent extends Node

### Variables
@export var health: HealthComponent
@export var movement: MovementComponent

@export_range(0.0, 5.0) var knockback_factor: float = 1.0

### Signals

### Engine Functions
func _ready() -> void:
	health.on_damage.connect(_on_damage)

### Public Functions

### Private Functions
func _on_damage(_amount: float, type: DamageComponent.DamageType, direction: Vector2):
	# TODO: Should the knockback be based on the damage?
	print("KnockbackComponent: %s" % direction)
	match type:
		DamageComponent.DamageType.NORMAL:
			movement.apply_velocity(direction * movement.top_speed * knockback_factor)
			movement.lock_until_stopped()
		DamageComponent.DamageType.HEAVY:
			movement.apply_velocity(direction * movement.top_speed * knockback_factor * 1.5)
			movement.lock_until_stopped()

