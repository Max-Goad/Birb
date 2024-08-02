@tool
class_name PathfindingComponent extends Node

enum Strategy
{
	NONE,
	FOLLOW,
	TRACK_FROM_DISTANCE,
}

enum TrackState
{
	IN_RANGE,
	FAR,
	CLOSE,
}

#region Variables
@export var strategy = Strategy.FOLLOW:
	set(value):
		strategy = value
		notify_property_list_changed()

@export var movement: CharacterMovementComponent
@export var target: Node2D

# Used in Strategy.TRACK_FROM_DISTANCE
@export var distance: float = 350.0
@export var distance_margin = 100.0

var current_track_state: TrackState
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
				var direction_to_target = _get_vector_to_target(target)
				current_track_state = _update_track_state()
				var next_direction = Vector2.ZERO
				match current_track_state:
					TrackState.FAR:
						# move towards the target
						next_direction = direction_to_target
					TrackState.IN_RANGE:
						# circle the target
						next_direction = direction_to_target.rotated(PI/2)
					TrackState.CLOSE:
						# move away from the target
						next_direction = -direction_to_target
				movement.rotate_velocity_toward(next_direction)
				movement.accelerate()
				# print(movement.character.velocity)
				# always face the target
				movement.apply_rotation(direction_to_target.angle() + PI/2)

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

func _update_track_state() -> TrackState:
	var gap = movement.character.global_position.distance_to(target.global_position)
	match current_track_state:
		TrackState.FAR when gap > distance:
			return TrackState.FAR
		TrackState.FAR:
			return TrackState.IN_RANGE
		TrackState.IN_RANGE when gap > distance + distance_margin:
			return TrackState.FAR
		TrackState.IN_RANGE when gap < distance - distance_margin:
			return TrackState.CLOSE
		TrackState.IN_RANGE:
			return TrackState.IN_RANGE
		TrackState.CLOSE when gap < distance:
			return TrackState.CLOSE
		TrackState.CLOSE:
			return TrackState.IN_RANGE
		_:
			assert(false)
			return TrackState.IN_RANGE
#endregion
