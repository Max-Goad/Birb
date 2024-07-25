class_name PathfindingComponent extends Node

enum Strategy
{
	NONE,
	FOLLOW
}

### Variables
@export var strategy = Strategy.FOLLOW
@export var movement: CharacterMovementComponent
@export var target: Node2D

### Signals

### Engine Functions
func _ready() -> void:
	assert(movement)

func _process(delta: float) -> void:
	_process_strategy(delta)

### Public Functions
func follow(target: Node2D):
	self.strategy = Strategy.FOLLOW
	self.target = target

### Private Functions
func _process_strategy(_delta):
	match strategy:
		Strategy.FOLLOW:
			if target:
				var character = movement.character
				var target_direction = (target.global_position - character.global_position).normalized()
				var target_angle = character.velocity.angle_to(target_direction)
				var angle = move_toward(0, target_angle, movement.rotation_speed / 10)
				var direction = character.velocity.normalized().rotated(angle)
				if direction == Vector2.ZERO:
					direction = target_direction
				var target_speed = movement.top_speed
				var magnitude = move_toward(character.velocity.length(), target_speed, target_speed * movement.acceleration / 10)
				movement.apply_velocity(direction * magnitude)
