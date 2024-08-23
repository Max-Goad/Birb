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

const SHOULD_ACCELERATE = true
const SHOULD_DECELERATE = false

#region Variables
@export var movement: CharacterMovementComponent

@export var target_player: bool = true:
	set(value):
		target_player = value
		notify_property_list_changed()

@export var target: Node2D

@export var strategy = Strategy.FOLLOW:
	set(value):
		strategy = value
		notify_property_list_changed()

@export_group("Strategy Parameters")
@export var distance: float = 350.0
@export var distance_margin = 100.0
@export_group("","")


var current_track_state: TrackState
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	assert(movement)
	if target_player:
		target = Data.get_player()
	if target == null:
		push_error("PathfindingComponent: No target set!")

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var movement_result = _process_strategy(delta)
	if movement_result == SHOULD_ACCELERATE:
		movement.accelerate()
	else:
		movement.decelerate()

func _validate_property(property: Dictionary) -> void:
	if property.name in ["distance", "distance_margin"] and strategy != Strategy.TRACK_FROM_DISTANCE:
		property.usage &= ~PROPERTY_USAGE_EDITOR
	elif property.name == "target" and target_player:
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion

#region Public Functions
#endregion

#region Private Functions
func _process_strategy(_delta) -> bool:
	match strategy:
		Strategy.FOLLOW:
			if target:
				return movement.rotate_velocity_toward(_get_vector_to_target(target))
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
				# always face the target
				movement.apply_rotation(direction_to_target.angle() + PI/2)
				return movement.rotate_velocity_toward(next_direction)
	return SHOULD_DECELERATE

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
