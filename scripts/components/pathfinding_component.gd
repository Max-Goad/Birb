@tool
class_name PathfindingComponent extends Node

enum Strategy
{
	NONE,
	FOLLOW,
	TRACK_FROM_DISTANCE,
}

#region Variables
@export var strategy = Strategy.FOLLOW:
	set(value):
		strategy = value
		notify_property_list_changed()

@export var movement: CharacterMovementComponent
@export var target: Node2D

# Used in Strategy.TRACK_FROM_DISTANCE
@export var distance: float = 100.0
var distance_margin = 50.0
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	assert(movement)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_process_strategy(delta)
	movement.decelerate()

func _validate_property(property: Dictionary) -> void:
	if property.name == "distance" and strategy != Strategy.TRACK_FROM_DISTANCE:
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion

#region Public Functions
#endregion

#region Private Functions
func _process_strategy(_delta):
	match strategy:
		Strategy.FOLLOW:
			if target:
				movement.apply_velocity(_get_vector_moving_towards(target))
		Strategy.TRACK_FROM_DISTANCE:
			if target:
				var target_speed = movement.top_speed
				var magnitude = move_toward(movement.character.velocity.length(), target_speed, target_speed * movement.acceleration)
				var vector = _get_vector_to_target(target) * magnitude
				var perpendicular = vector.rotated(PI/2)
				movement.apply_rotation(vector.angle() + PI/2)
				var gap = movement.character.global_position.distance_to(target.global_position)
				if gap > distance + distance_margin:
					print("gap >")
					var x = vector + perpendicular
					movement.apply_velocity(x)
				elif gap < distance - distance_margin:
					print("gap <")
					var x = -vector + perpendicular
					movement.apply_velocity(x)
				else:
					print("gap within")
					movement.apply_velocity(perpendicular)

func _get_vector_moving_towards(target) -> Vector2:
	var character = movement.character
	var target_direction = _get_vector_to_target(target)
	var target_angle = character.velocity.angle_to(target_direction)
	var angle = move_toward(0, target_angle, movement.rotation_speed / 10)
	var direction = character.velocity.normalized().rotated(angle)
	if direction == Vector2.ZERO:
		direction = target_direction
	var target_speed = movement.top_speed
	var magnitude = move_toward(character.velocity.length(), target_speed, target_speed * movement.acceleration)
	return direction * magnitude

func _get_vector_to_target(target) -> Vector2:
	return (target.global_position - movement.character.global_position).normalized()
#endregion
