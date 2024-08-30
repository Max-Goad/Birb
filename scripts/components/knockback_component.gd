class_name KnockbackComponent extends Node

enum Degree
{
	## Standard amount of recoil.
	## Velocity change will be small but noticable,
	## but overall control will not be majorly impeded.
	NORMAL = 0,
	## Large amount of recoil.
	## Velocity will be mostly entirely overwritten,
	## and overall control will be affected.
	HEAVY = 1,
	## Small amount of recoil.
	## While recoil will still be applied (as opposed to NO_RECOIL),
	## the overall effects will be much harder to notice.
	## Produces more of a movement "stutter" effect.
	LIGHT = 2,
	## No recoil will be processed.
	## Useful for multi-hit attacks or attacks that already
	## manipulate velocity of whatever is being attacked.
	NO_RECOIL = 3,
	## TODO: Implement
	## Amount of knockback will be determined based on the
	## amount of damage inflicted/received.
	## TODO: Should it be percentage based (vs max hp) or flat?
	DAMAGE_DEPENDENT = 4,
}

enum Style
{
	## Knockback in a fixed, known direction.
	## Used for things like projectiles or melee attacks.
	DIRECTIONAL,
	## Knockback outwards from a fixed, known point.
	## Used for push-away effects like explosions.
	RADIAL,
	## (Variant of RADIAL)
	## Knockback inwards towards a fixed, known point.
	## Used for pull-towards effects like implosions.
	INVERSE_RADIAL
}

class KBData:
	var style: Style
	var degree: Degree
	var vector: Vector2

#region Variables
@export var health: HealthComponent
@export var movement: MovementComponent

@export_range(0.0, 5.0) var knockback_factor: float = 1.0
#endregion

#region Signals
signal knockback_finished
#endregion

#region Engine Functions
func _ready() -> void:
	health.on_damage.connect(_on_damage)
#endregion

#region Public Functions
func apply_knockback(direction: Vector2, modifier: float = 1.0, stun_time: float = 0.0):
	assert(direction.is_normalized())
	movement.apply_direction(direction, MovementComponent.IGNORE_LOCK)
	movement.apply_speed(movement.top_speed * knockback_factor * modifier, MovementComponent.IGNORE_LOCK)
	if not movement.currently_locked:
		movement.unlocked.connect(knockback_finished.emit, CONNECT_ONE_SHOT)
	if stun_time > 0.0:
		movement.lock(stun_time)
	else:
		movement.lock_until_stopped()

#endregion

#region Private Functions
func _on_damage(_amount: float, kb_data: KBData):
	print("KnockbackComponent: %s" % KBData)
	var knockback_direction = Vector2.ZERO
	match kb_data.style:
		KnockbackComponent.Style.DIRECTIONAL:
			# Directional KB define their own knockback direction
			# Just take it as it is
			knockback_direction = kb_data.vector.normalized()
		KnockbackComponent.Style.RADIAL, KnockbackComponent.Style.INVERSE_RADIAL:
			# Radial KB pass the damage origin position as the vector
			# The knockback direction is the difference between
			# the damage origin position and the affected object's position
			knockback_direction = (movement.character.global_position - kb_data.vector).normalized()
			if kb_data.style == KnockbackComponent.Style.INVERSE_RADIAL:
				knockback_direction = -knockback_direction

	match kb_data.degree:
		KnockbackComponent.Degree.NO_RECOIL:
			pass
		KnockbackComponent.Degree.LIGHT:
			apply_knockback(knockback_direction, 0.34)
		KnockbackComponent.Degree.NORMAL:
			apply_knockback(knockback_direction)
		KnockbackComponent.Degree.HEAVY:
			apply_knockback(knockback_direction, 2.5)
		KnockbackComponent.Degree.DAMAGE_DEPENDENT:
			# TODO: Implement DamageDependent
			assert(false, "Not implemented yet")
#endregion
