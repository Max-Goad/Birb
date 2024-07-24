class_name PathfindingComponent extends Node

enum Strategy
{
	NONE,
	FOLLOW
}

### Variables
@export var strategy = Strategy.FOLLOW
@export var character: CharacterBody2D
@export var target: Node2D
@export var speed: SpeedComponent

### Signals

### Engine Functions
func _ready() -> void:
	assert(character)
	assert(speed)

func _process(delta: float) -> void:
	_process_strategy(delta)
	character.move_and_slide()

### Public Functions
func follow(target: Node2D):
	self.strategy = Strategy.FOLLOW
	self.target = target

### Private Functions
func _process_strategy(delta):
	match strategy:
		Strategy.FOLLOW:
			if target:
				character.velocity = character.velocity.move_toward(target.global_position - character.global_position, speed.top_speed * delta)

