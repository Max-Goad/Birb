class_name KnockbackComponent extends Node

#region Variables
@export var health: HealthComponent
@export var movement: MovementComponent

@export_range(0.0, 5.0) var knockback_factor: float = 1.0
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	health.on_damage.connect(_on_damage)
#endregion

#region Public Functions
func apply_knockback(direction: Vector2, modifier: float = 1.0, stun_time: float = 0.0):
	movement.apply_direction(direction, MovementComponent.IGNORE_LOCK)
	movement.apply_speed(movement.top_speed * knockback_factor * modifier, MovementComponent.IGNORE_LOCK)
	if stun_time > 0.0:
		movement.lock(stun_time)
	else:
		movement.lock_until_stopped()

#endregion

#region Private Functions
func _on_damage(_amount: float, type: DamageComponent.DamageType, direction: Vector2):
	# TODO: Should the knockback be based on the damage?
	print("KnockbackComponent: %s" % direction)
	match type:
		DamageComponent.DamageType.NO_RECOIL:
			pass
		DamageComponent.DamageType.LIGHT:
			apply_knockback(direction, 0.34)
		DamageComponent.DamageType.NORMAL:
			apply_knockback(direction)
		DamageComponent.DamageType.HEAVY:
			apply_knockback(direction, 2.5)
#endregion
